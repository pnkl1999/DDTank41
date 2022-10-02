using Bussiness;
using Bussiness.Managers;
using Game.Base;
using Game.Base.Events;
using Game.Logic;
using Game.Logic.Game.Logic;
using Game.Server.Battle;
using Game.Server.ConsortiaTask;
using Game.Server.Games;
using Game.Server.LittleGame;
using Game.Server.Managers;
using Game.Server.Packets;
using Game.Server.RingStation;
using Game.Server.Rooms;
using Game.Server.Statics;
using Game.Server.Task;
using log4net;
using log4net.Config;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Reflection;
using System.Text;
using System.Threading;

namespace Game.Server
{
    public class GameServer : BaseServer
    {
        private LoginServerConnector _loginServer;

        private List<LoginServerConnector> _loginServers = new List<LoginServerConnector>();

        private int _shutdownCount = 6;

        private Timer _shutdownTimer;

        private const int BUF_SIZE = 8192;

        public static readonly string Edition = "2612558";

        public static bool KeepRunning = false;

        public static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected Timer m_bagMailScanTimer;

        protected Timer m_buffScanTimer;

        private static bool m_compiled = false;

        private GameServerConfig m_config;

        private bool m_debugMenory;

        private static GameServer m_instance = null;

        private bool m_isRunning;

        private Queue m_packetBufPool;

        protected Timer m_pingCheckTimer;

        protected Timer m_qqTipScanTimer;

        protected Timer m_saveDbTimer;

        protected Timer m_saveRecordTimer;

        protected Timer m_renameInterval;

        protected Timer m_worldBossScanTimer1;

        protected Timer m_worldBossScanTimer2;

        protected Timer m_LittleGameScanTimer;

        protected Timer m_LeagueScanTimer;

        protected Timer m_weekScanTimer;

        private static int m_tryCount = 4;
        private static int tryOtherServer = 15;

        public GameServerConfig Configuration => m_config;

        public static GameServer Instance => m_instance;

        public LoginServerConnector LoginServer => _loginServer;
        public List<LoginServerConnector> OtherLoginServer => _loginServers;

        public int PacketPoolSize => m_packetBufPool.Count;

        protected GameServer(GameServerConfig config)
        {
            m_config = config;
            if (log.IsDebugEnabled)
            {
                log.Debug("Current directory is: " + Directory.GetCurrentDirectory());
                log.Debug("Gameserver root directory is: " + Configuration.RootDirectory);
                log.Debug("Changing directory to root directory");
            }
            Directory.SetCurrentDirectory(Configuration.RootDirectory);
        }

        public byte[] AcquirePacketBuffer()
        {
            lock (m_packetBufPool.SyncRoot)
            {
                if (m_packetBufPool.Count > 0)
                {
                    return (byte[])m_packetBufPool.Dequeue();
                }
            }
            log.Warn("packet buffer pool is empty!");
            return new byte[8192];
        }

        private bool AllocatePacketBuffers()
        {
            int num = Configuration.MaxClientCount * 3;
            m_packetBufPool = new Queue(num);
            for (int i = 0; i < num; i++)
            {
                m_packetBufPool.Enqueue(new byte[8192]);
            }
            if (log.IsDebugEnabled)
            {
                log.DebugFormat("allocated packet buffers: {0}", num.ToString());
            }
            return true;
        }

        protected void BuffScanTimerProc(object sender)
        {
            try
            {
                int tickCount = Environment.TickCount;
                if (log.IsInfoEnabled)
                {
                    log.Info("Buff Scaning ...");
                    log.Debug("BuffScan ThreadId=" + Thread.CurrentThread.ManagedThreadId);
                }
                int num = 0;
                ThreadPriority priority = Thread.CurrentThread.Priority;
                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
                GamePlayer[] array = allPlayers;
                foreach (GamePlayer gamePlayer in array)
                {
                    if (gamePlayer.BufferList != null)
                    {
                        gamePlayer.BufferList.Update();
                        num++;
                    }
                }
                Thread.CurrentThread.Priority = priority;
                tickCount = Environment.TickCount - tickCount;
                if (log.IsInfoEnabled)
                {
                    log.Info("Buff Scan complete!");
                    log.Info("Buff all " + num + " players in " + tickCount + "ms");
                }
                if (tickCount > 120000)
                {
                    log.WarnFormat("Scan all Buff and {0} players in {1} ms", num, tickCount);
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("BuffScanTimerProc", exception);
                }
            }
            finally
            {
                if (log.IsErrorEnabled)
                {
                    log.Info("GameMgr Scaning ...");
                }
                if (GameMgr.SynDate < 0)
                {
                    GameMgr.ClearAllGames();
                    GameMgr.Stop();
                    GameMgr.Setup(Configuration.ServerID, GameProperties.BOX_APPEAR_CONDITION);
                    GameMgr.Start();
                    if (log.IsInfoEnabled)
                    {
                        log.Warn("Game PVE Restart Success!");
                    }
                }
                else if (log.IsInfoEnabled)
                {
                    log.InfoFormat("GameMgr.SynDate: {0}", GameMgr.SynDate);
                }
                if (log.IsInfoEnabled)
                {
                    log.Info("GameMgr Scan complete!");
                }
            }
        }

        public static void CreateInstance(GameServerConfig config)
        {
            if (m_instance == null)
            {
                FileInfo fileInfo = new FileInfo(config.LogConfigFile);
                if (!fileInfo.Exists)
                {
                    ResourceUtil.ExtractResource(fileInfo.Name, fileInfo.FullName, Assembly.GetAssembly(typeof(GameServer)));
                }
                XmlConfigurator.ConfigureAndWatch(fileInfo);
                m_instance = new GameServer(config);
            }
        }

        private void CurrentDomain_UnhandledException(object sender, UnhandledExceptionEventArgs e)
        {
            try
            {
                log.Fatal("Unhandled exception!\n" + e.ExceptionObject.ToString());
                if (e.IsTerminating)
                {
                    Stop();
                }
            }
            catch
            {
                try
                {
                    using FileStream stream = new FileStream("c:\\testme.log", FileMode.Append, FileAccess.Write);
                    using StreamWriter streamWriter = new StreamWriter(stream, Encoding.UTF8);
                    streamWriter.WriteLine(e.ExceptionObject);
                }
                catch
                {
                }
            }
        }

        public new GameClient[] GetAllClients()
        {
            GameClient[] array = null;
            lock (_clients.SyncRoot)
            {
                array = new GameClient[_clients.Count];
                _clients.Keys.CopyTo(array, 0);
                return array;
            }
        }

        protected override BaseClient GetNewClient()
        {
            return new GameClient(this, AcquirePacketBuffer(), AcquirePacketBuffer());
        }

        protected bool InitComponent(bool componentInitState, string text)
        {
            if (m_debugMenory)
            {
                log.Debug("Start Memory " + text + ": " + GC.GetTotalMemory(forceFullCollection: false) / 1024 / 1024);
            }
            if (log.IsInfoEnabled)
            {
                log.Info(text + ": " + componentInitState);
            }
            if (!componentInitState)
            {
                Stop();
            }
            if (m_debugMenory)
            {
                log.Debug("Finish Memory " + text + ": " + GC.GetTotalMemory(forceFullCollection: false) / 1024 / 1024);
            }
            return componentInitState;
        }

        public bool InitGlobalTimer()
        {
            int num = Configuration.DBSaveInterval * 60 * 1000;
            if (m_saveDbTimer == null)
            {
                m_saveDbTimer = new Timer(SaveTimerProc, null, num, num);
            }
            else
            {
                m_saveDbTimer.Change(num, num);
            }
            num = Configuration.PingCheckInterval * 60 * 1000;
            if (m_pingCheckTimer == null)
            {
                m_pingCheckTimer = new Timer(PingCheck, null, num, num);
            }
            else
            {
                m_pingCheckTimer.Change(num, num);
            }
            num = Configuration.SaveRecordInterval * 60 * 1000;
            if (m_saveRecordTimer != null)
            {
                m_saveRecordTimer.Change(num, num);
            }
            num = 60000;
            if (m_buffScanTimer == null)
            {
                m_buffScanTimer = new Timer(BuffScanTimerProc, null, num, num);
            }
            else
            {
                m_buffScanTimer.Change(num, num);
            }

            //if (m_worldBossScanTimer1 == null)
            //{
            //    m_worldBossScanTimer1 = new Timer(WorldBossScan1, null, 60000 - DateTime.Now.Second * 1000, 60000);
            //}
            //else
            //{
            //    m_worldBossScanTimer1.Change(num, num);
            //}

            //if (m_worldBossScanTimer2 == null)
            //{
            //    m_worldBossScanTimer2 = new Timer(WorldBossScan2, null, 60000 - DateTime.Now.Second * 1000, 60000);
            //}
            //else
            //{
            //    m_worldBossScanTimer2.Change(num, num);
            //}

            if (m_LittleGameScanTimer == null)
            {
                m_LittleGameScanTimer = new Timer(LittleGameScan, null, 60000 - DateTime.Now.Second * 1000, 60000);
            }
            else
            {
                m_LittleGameScanTimer.Change(num, num);
            }

            //if (m_weekScanTimer == null)
            //{
            //    m_weekScanTimer = new Timer(WeekScan, null, 60000 - DateTime.Now.Second * 1000, 60000);
            //}
            //else
            //{
            //    m_weekScanTimer.Change(num, num);
            //}

            int time = 24 * 60 * 60 * 1000;
            //int time = 60 * 1000;
            if (m_renameInterval == null)
            {
                m_renameInterval = new Timer(RenameBatchs, null, time, time);
            }

            //if (m_LeagueScanTimer == null)
            //{
            //    m_LeagueScanTimer = new Timer(LeagueScan, null, 60000 - DateTime.Now.Second * 1000, 60000);
            //}
            //else
            //{
            //    m_LeagueScanTimer.Change(num, num);
            //}
            return true;
        }

        protected void LeagueScan(object sender)
        {
            try
            {
                int tickCount = Environment.TickCount;
                if (log.IsInfoEnabled)
                {
                    log.Info("League Scaning ...");
                    log.Debug("League ThreadId=" + Thread.CurrentThread.ManagedThreadId);
                }

                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                GamePlayer[] players = WorldMgr.GetAllPlayers();
                DateTime startTime = Convert.ToDateTime("08:30:00");
                DateTime stopTime = Convert.ToDateTime("23:59:00");

                List<DayOfWeek> opendays = new List<DayOfWeek>
                {
                    DayOfWeek.Monday,
                    DayOfWeek.Tuesday,
                    DayOfWeek.Wednesday,
                    DayOfWeek.Thursday,
                    DayOfWeek.Friday,
                    DayOfWeek.Saturday,
                    DayOfWeek.Sunday
                };

                if (opendays.Contains(DateTime.Now.DayOfWeek))
                {
                    if (!ActiveSystemMgr.IsLeagueOpen && startTime <= DateTime.Now && DateTime.Now < stopTime)
                    {
                        ActiveSystemMgr.UpdateIsLeagueOpen(true);
                        Console.WriteLine("UpdateIsLeagueOpen(true)");
                    }
                    else if (ActiveSystemMgr.IsLeagueOpen && DateTime.Now >= stopTime)
                    {
                        ActiveSystemMgr.UpdateIsLeagueOpen(false);
                        Console.WriteLine("UpdateIsLeagueOpen(false)");
                    }
                }
                if (log.IsInfoEnabled)
                {
                    log.Info("LeagueScan completed!");
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("LeagueScan fail", exception);
                }
            }
        }


        protected void WorldBossScan1(object sender)
        {
            try
            {
                int tickCount = Environment.TickCount;
                if (log.IsInfoEnabled)
                {
                    log.Info("WorldBoss Scaning ...");
                    log.Debug("WorldBossScan ThreadId=" + Thread.CurrentThread.ManagedThreadId);
                }

                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                GamePlayer[] players = WorldMgr.GetAllPlayers();
                DateTime startTime = Convert.ToDateTime(GameProperties.WorldBossStart.Split('|')[0]);
                DateTime stopTime = Convert.ToDateTime(GameProperties.WorldBossEnd.Split('|')[0]);
                DateTime closeTime = stopTime.AddMinutes(1.0);
                int npcID = 30004;
                int configblood = NPCInfoMgr.GetNpcInfoById(npcID).Blood;
                string configname = NPCInfoMgr.GetNpcInfoById(npcID).Name;
                List<DayOfWeek> opendays = new List<DayOfWeek>
                {
                    DayOfWeek.Monday,
                    //DayOfWeek.Tuesday,
                    DayOfWeek.Wednesday,
                    //DayOfWeek.Thursday,
                    DayOfWeek.Friday,
                    DayOfWeek.Saturday,
                    DayOfWeek.Sunday
                };
                if (opendays.Contains(DateTime.Now.DayOfWeek) /*&& DateTime.Now >= startTime && DateTime.Now < stopTime*/)
                {
                    if (!RoomMgr.WorldBossRoom.WorldOpen && DateTime.Now >= startTime && DateTime.Now < stopTime)
                    {
                        RoomMgr.WorldBossRoom.BeginTime = startTime;
                        RoomMgr.WorldBossRoom.EndTime = stopTime;
                        RoomMgr.WorldBossRoom.MaxBlood = configblood;
                        RoomMgr.WorldBossRoom.Blood = configblood;
                        RoomMgr.WorldBossRoom.Name = configname;
                        RoomMgr.WorldBossRoom.BossResourceId = "4";
                        RoomMgr.WorldBossRoom.CurrentPve = npcID;
                        RoomMgr.WorldBossRoom.FightOver = false;
                        RoomMgr.WorldBossRoom.RoomClose = false;
                        RoomMgr.WorldBossRoom.WorldOpen = true;
                        RoomMgr.WorldBossRoom.FightTime = (int)stopTime.Subtract(startTime).TotalMinutes;
                        foreach (var xxx in players)
                        {
                            xxx.Out.SendOpenWorldBoss(0, 0);
                            xxx.Out.SendMessage(eMessageType.GM_NOTICE, "Boss thế giới đã mở, hãy tham gia ngay từ mục Sự Kiện!");
                        }
                    }
                    else if (DateTime.Now >= stopTime && DateTime.Now < closeTime && RoomMgr.WorldBossRoom.WorldOpen)
                    {
                        RoomMgr.WorldBossRoom.FightOver = true;
                        RoomMgr.WorldBossRoom.RoomClose = false;
                        RoomMgr.WorldBossRoom.WorldOpen = true;
                        RoomMgr.WorldBossRoom.SendFightOver();
                        foreach (var xxx in players)
                        {
                            xxx.Out.SendOpenWorldBoss(0, 0);
                            xxx.Out.SendMessage(eMessageType.GM_NOTICE, "Boss thế giới kết thúc, các bạn còn 10 phút đổi điểm.");
                        }
                        RoomMgr.WorldBossRoom.SendRoomClose();
                        RoomMgr.WorldBossRoom.WorldBossClose();
                        RoomMgr.WorldBossRoom.SendGiftForUserJoined();
                    }
                    else if (DateTime.Now >= closeTime && !RoomMgr.WorldBossRoom.RoomClose)
                    {
                        RoomMgr.WorldBossRoom.FightOver = true;
                        RoomMgr.WorldBossRoom.RoomClose = true;
                        RoomMgr.WorldBossRoom.WorldOpen = false;
                        foreach (var xxx in players)
                        {
                            xxx.Out.SendOpenWorldBoss(0, 0);
                            xxx.Out.SendMessage(eMessageType.GM_NOTICE, "Boss thế giới đã đóng, hẹn các bạn tham gia vào những lần sau...");
                            xxx.PlayerCharacter.damageScores = 0;
                        }
                        RoomMgr.WorldBossRoom.SendAllOver();
                    }
                    else if (startTime.Subtract(DateTime.Now).TotalMinutes <= 5 && startTime.Subtract(DateTime.Now).TotalMinutes > 0 && !RoomMgr.WorldBossRoom.WorldOpen && DateTime.Now < closeTime)
                    {
                        foreach (var xxx in players)
                        {
                            xxx.Out.SendMessage(eMessageType.GM_NOTICE, $"Boss thế giới còn {startTime.Subtract(DateTime.Now).TotalMinutes} phút sẽ bắt đầu, mọi người chuẩn bị tham gia nàoo.");
                        }
                    }
                }

                if (log.IsInfoEnabled)
                {
                    log.Info("WorldBossScan completed!");
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("WorldBossScan fail", exception);
                }
            }
            finally
            {
                if (log.IsErrorEnabled)
                {
                    log.Info("GameMgr Scaning ...");
                }
                if (GameMgr.SynDate < 0)
                {
                    GameMgr.ClearAllGames();
                    GameMgr.Stop();
                    GameMgr.Setup(Configuration.ServerID, GameProperties.BOX_APPEAR_CONDITION);
                    GameMgr.Start();
                    if (log.IsInfoEnabled)
                    {
                        log.Warn("Game PVE Restart Success!");
                    }
                }
                else if (log.IsInfoEnabled)
                {
                    log.InfoFormat("GameMgr.SynDate: {0}", GameMgr.SynDate);
                }
                if (log.IsInfoEnabled)
                {
                    log.Info("GameMgr Scan complete!");
                }
            }
        }

        protected void WorldBossScan2(object sender)
        {
            try
            {
                int tickCount = Environment.TickCount;
                if (log.IsInfoEnabled)
                {
                    log.Info("WorldBoss Scaning ...");
                    log.Debug("WorldBossScan ThreadId=" + Thread.CurrentThread.ManagedThreadId);
                }

                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                GamePlayer[] players = WorldMgr.GetAllPlayers();
                DateTime startTime = Convert.ToDateTime(GameProperties.WorldBossStart.Split('|')[1]);
                DateTime stopTime = Convert.ToDateTime(GameProperties.WorldBossEnd.Split('|')[1]);
                DateTime closeTime = stopTime.AddMinutes(1.0);
                int npcID = 1243;
                int configblood = NPCInfoMgr.GetNpcInfoById(npcID).Blood;
                string configname = NPCInfoMgr.GetNpcInfoById(npcID).Name;
                List<DayOfWeek> opendays = new List<DayOfWeek>
                {
                    DayOfWeek.Monday,
                    //DayOfWeek.Tuesday,
                    DayOfWeek.Wednesday,
                    //DayOfWeek.Thursday,
                    DayOfWeek.Friday,
                    DayOfWeek.Saturday,
                    DayOfWeek.Sunday
                };
                if (opendays.Contains(DateTime.Now.DayOfWeek) /*&& DateTime.Now >= startTime && DateTime.Now < stopTime*/)
                {
                    if (!RoomMgr.WorldBossRoom.WorldOpen && DateTime.Now >= startTime && DateTime.Now < stopTime)
                    {
                        RoomMgr.WorldBossRoom.BeginTime = startTime;
                        RoomMgr.WorldBossRoom.EndTime = stopTime;
                        RoomMgr.WorldBossRoom.MaxBlood = configblood;
                        RoomMgr.WorldBossRoom.Blood = configblood;
                        RoomMgr.WorldBossRoom.Name = configname;
                        RoomMgr.WorldBossRoom.BossResourceId = "1";
                        RoomMgr.WorldBossRoom.CurrentPve = npcID;
                        RoomMgr.WorldBossRoom.FightOver = false;
                        RoomMgr.WorldBossRoom.RoomClose = false;
                        RoomMgr.WorldBossRoom.WorldOpen = true;
                        RoomMgr.WorldBossRoom.FightTime = (int)stopTime.Subtract(startTime).TotalMinutes;
                        foreach (var xxx in players)
                        {
                            xxx.Out.SendOpenWorldBoss(0, 0);
                            xxx.Out.SendMessage(eMessageType.GM_NOTICE, "Boss thế giới đã mở, hãy tham gia ngay từ mục Sự Kiện!");
                        }
                    }
                    else if (DateTime.Now >= stopTime && DateTime.Now < closeTime && RoomMgr.WorldBossRoom.WorldOpen)
                    {
                        RoomMgr.WorldBossRoom.FightOver = true;
                        RoomMgr.WorldBossRoom.RoomClose = false;
                        RoomMgr.WorldBossRoom.WorldOpen = true;
                        RoomMgr.WorldBossRoom.SendFightOver();
                        foreach (var xxx in players)
                        {
                            xxx.Out.SendOpenWorldBoss(0, 0);
                            xxx.Out.SendMessage(eMessageType.GM_NOTICE, "Boss thế giới kết thúc, các bạn còn 10 phút đổi điểm.");
                        }
                        RoomMgr.WorldBossRoom.SendRoomClose();
                        RoomMgr.WorldBossRoom.WorldBossClose();
                        RoomMgr.WorldBossRoom.SendGiftForUserJoined();
                    }
                    else if (DateTime.Now >= closeTime && !RoomMgr.WorldBossRoom.RoomClose)
                    {
                        RoomMgr.WorldBossRoom.FightOver = true;
                        RoomMgr.WorldBossRoom.RoomClose = true;
                        RoomMgr.WorldBossRoom.WorldOpen = false;
                        foreach (var xxx in players)
                        {
                            xxx.Out.SendOpenWorldBoss(0, 0);
                            xxx.Out.SendMessage(eMessageType.GM_NOTICE, "Boss thế giới đã đóng, hẹn các bạn tham gia vào những lần sau...");
                            xxx.PlayerCharacter.damageScores = 0;
                        }
                        RoomMgr.WorldBossRoom.SendAllOver();
                    }
                    else if (startTime.Subtract(DateTime.Now).TotalMinutes <= 5 && startTime.Subtract(DateTime.Now).TotalMinutes > 0 && !RoomMgr.WorldBossRoom.WorldOpen && DateTime.Now < closeTime)
                    {
                        foreach (var xxx in players)
                        {
                            xxx.Out.SendMessage(eMessageType.GM_NOTICE, $"Boss thế giới còn {startTime.Subtract(DateTime.Now).TotalMinutes} phút sẽ bắt đầu, mọi người chuẩn bị tham gia nàoo.");
                        }
                    }
                }

                if (log.IsInfoEnabled)
                {
                    log.Info("WorldBossScan completed!");
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("WorldBossScan fail", exception);
                }
            }
            finally
            {
                if (log.IsErrorEnabled)
                {
                    log.Info("GameMgr Scaning ...");
                }
                if (GameMgr.SynDate < 0)
                {
                    GameMgr.ClearAllGames();
                    GameMgr.Stop();
                    GameMgr.Setup(Configuration.ServerID, GameProperties.BOX_APPEAR_CONDITION);
                    GameMgr.Start();
                    if (log.IsInfoEnabled)
                    {
                        log.Warn("Game PVE Restart Success!");
                    }
                }
                else if (log.IsInfoEnabled)
                {
                    log.InfoFormat("GameMgr.SynDate: {0}", GameMgr.SynDate);
                }
                if (log.IsInfoEnabled)
                {
                    log.Info("GameMgr Scan complete!");
                }
            }
        }


        protected void LittleGameScan(object sender)
        {
            try
            {
                int tickCount = Environment.TickCount;
                if (log.IsInfoEnabled)
                {
                    log.Info("Little Game Scaning ...");
                    log.Debug("LittleGameScan ThreadId=" + Thread.CurrentThread.ManagedThreadId);
                }

                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                List<DayOfWeek> opendays = new List<DayOfWeek>//3 5 7
                {
                    DayOfWeek.Monday,
                    DayOfWeek.Tuesday,
                    DayOfWeek.Wednesday,
                    DayOfWeek.Thursday,
                    DayOfWeek.Friday,
                    DayOfWeek.Saturday,
                    DayOfWeek.Sunday
                };
                if (opendays.Contains(DateTime.Now.DayOfWeek))
                {
                    int startTime = GameProperties.LittleGameStartHourse;
                    int stopTime = GameProperties.LittleGameStartHourse + GameProperties.LittleGameTimeSpending;
                    if (DateTime.Now.Hour == startTime && !LittleGameWorldMgr.IsOpen)
                    {
                        LittleGameWorldMgr.OpenLittleGameSetup();
                    }
                    else if (DateTime.Now.Hour >= stopTime && LittleGameWorldMgr.IsOpen)
                    {
                        LittleGameWorldMgr.CloseLittleGame();
                    }
                    else if (DateTime.Now.Hour == startTime - 1 && !LittleGameWorldMgr.IsOpen && DateTime.Now.Minute >= 55)
                    {
                        foreach (var player in WorldMgr.GetAllPlayers())
                        {
                            player.Actives.SendLittleGameActived();
                            player.Out.SendMessage(eMessageType.Normal, $"Sự kiện Đại chiến Hút Gà còn {(int)(60 - DateTime.Now.Minute)} phút sẽ bắt đầu, tham gia từ Đặc Sắc ở sảnh game nhé !");
                        }
                    }
                    else if (DateTime.Now.Hour == startTime && LittleGameWorldMgr.IsOpen && DateTime.Now.Minute >= 55)
                    {
                        foreach (var player in WorldMgr.GetAllPlayers())
                        {
                            player.Actives.SendLittleGameActived();
                            player.Out.SendMessage(eMessageType.Normal, $"Sự kiện Đại chiến Hút Gà còn {(int)(60 - DateTime.Now.Minute)} phút sẽ kết thúc. Nhanh chóng đổi thưởng nàoo !");
                        }
                    }
                    if (log.IsInfoEnabled)
                    {
                        log.Info("LittleGame today scan completed!");
                    }
                }
                else if (log.IsInfoEnabled)
                {
                    log.Info("LittleGame scan not today!");
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("LittleGameScan fail", exception);
                }
            }
            finally
            {
                if (log.IsErrorEnabled)
                {
                    log.Info("GameMgr Scaning ...");
                }
                if (GameMgr.SynDate < 0)
                {
                    GameMgr.ClearAllGames();
                    GameMgr.Stop();
                    GameMgr.Setup(Configuration.ServerID, GameProperties.BOX_APPEAR_CONDITION);
                    GameMgr.Start();
                    if (log.IsInfoEnabled)
                    {
                        log.Warn("Game PVE Restart Success!");
                    }
                }
                else if (log.IsInfoEnabled)
                {
                    log.InfoFormat("GameMgr.SynDate: {0}", GameMgr.SynDate);
                }
                if (log.IsInfoEnabled)
                {
                    log.Info("GameMgr Scan complete!");
                }
            }
        }

        protected void WeekScan(object sender)
        {
            try
            {
                if (DateTime.Now.DayOfWeek == DayOfWeek.Monday)
                {
                    GamePlayer[] p = WorldMgr.GetAllPlayers();
                    foreach (GamePlayer player in p)
                    {
                        if (player.PlayerCharacter.ID > 0)
                        {
                            player.Extra.ResetNoviceEvent(NoviceActiveType.RECHANGE_MONEY_ACTIVE_OFWEEK);
                            player.Extra.ResetNoviceEvent(NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK);
                        }
                    }
                    log.Info("Week Scaning ...");
                    log.Debug("WeekScan ThreadId=" + Thread.CurrentThread.ManagedThreadId);
                }
            }
            catch (Exception ex)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("WeekScan fail", ex);
                }
            }
        }

        private bool InitLoginServer()
        {
            _loginServer = new LoginServerConnector(m_config.LoginServerIp, m_config.LoginServerPort, m_config.ServerID, m_config.ServerName, AcquirePacketBuffer(), AcquirePacketBuffer());
            _loginServer.Disconnected += loginServer_Disconnected;
            return _loginServer.Connect();
        }

        private bool InitOtherLoginServer()
        {
            foreach (var item in m_config.OtherLoginServer.Split('|'))
            {
                try
                {
                    var svId = int.Parse(item.Split(':')[0]);
                    var ip = item.Split(':')[1];
                    var port = int.Parse(item.Split(':')[2]);
                    var loginServer = new LoginServerConnector(ip, port, svId, m_config.ServerName, AcquirePacketBuffer(), AcquirePacketBuffer());
                    loginServer.Disconnected += (BaseClient client) => otherLoginServer_Disconnected(client, ip, port);
                    if (loginServer.Connect())
                    {
                        _loginServers.Add(loginServer);
                    }
                    else
                    {
                        _loginServers.Add(loginServer);
                        otherLoginServer_Disconnected(loginServer, ip, port);
                    }
                }
                catch (Exception)
                {

                    log.Error(string.Concat("Cant parse other login server!"));
                }

            }
            return true;
        }

        private void otherLoginServer_Disconnected(BaseClient client, string ip, int port)
        {
            Thread t = new Thread(() =>
            {
                log.ErrorFormat("Reconnecting after 5 minutes");
                Thread.Sleep(5 * 60 * 1000);

                if (tryOtherServer > 0)
                {
                    tryOtherServer--;
                    log.ErrorFormat("Reconnecting after :{0} try", tryOtherServer);
                    Thread.Sleep(1000);

                    for (int i = 0; i < _loginServers.Count; i++)
                    {
                        var item = _loginServers[i];
                        if (item.RemoteEP == new IPEndPoint(IPAddress.Parse(ip), port))
                        {
                            item = new LoginServerConnector(ip, port, m_config.ServerID, m_config.ServerName, AcquirePacketBuffer(), AcquirePacketBuffer());
                            item.Disconnected += (BaseClient client) => otherLoginServer_Disconnected(client, ip, port);
                            if (item.Connect())
                            {
                                tryOtherServer = 15;
                                log.Error(string.Concat("Reconnect to ", ip, ":", port, " success!"));
                            }
                            _loginServers[i] = item;
                            break;
                        }
                    }
                }
                else
                {
                    if (tryOtherServer == 0)
                    {
                        tryOtherServer = 15;
                        log.Error(string.Concat("Reconnect to ", ip, ":", port, " failed!"));
                    }
                }
            });

            t.Start();
        }

        private void loginServer_Disconnected(BaseClient client)
        {
            bool isRunning = m_isRunning;
            Stop();
            if (isRunning && m_tryCount > 0)
            {
                m_tryCount--;
                log.Error("Center Server Disconnect! Stopping Server");
                log.ErrorFormat("Start the game server again after 1 second,and left try times:{0}", m_tryCount);
                Thread.Sleep(1000);
                if (Start())
                {
                    log.Error("Restart the game server success!");
                }
            }
            else
            {
                if (m_tryCount == 0)
                {
                    log.ErrorFormat("Restart the game server failed after {0} times.", 4);
                    log.Error("Server Stopped!");
                }
                LogManager.Shutdown();
            }
        }

        public String GetHashHMACSHA256(String text, String key)
        {
            Byte[] textBytes = Encoding.UTF8.GetBytes(text);
            Byte[] keyBytes = Encoding.UTF8.GetBytes(key);

            Byte[] hashBytes;

            using (System.Security.Cryptography.HMACSHA256 hash = new System.Security.Cryptography.HMACSHA256(keyBytes))
                hashBytes = hash.ComputeHash(textBytes);
            return Convert.ToBase64String(hashBytes);
        }

        protected void PingCheck(object sender)
        {
            try
            {
                //this.RepingServer();
                log.Info("Begin ping check....");
                long num = (long)Configuration.PingCheckInterval * 60L * 1000 * 1000 * 10;
                GameClient[] allClients = GetAllClients();
                if (allClients != null)
                {
                    GameClient[] array = allClients;
                    GameClient[] array2 = array;
                    foreach (GameClient gameClient in array2)
                    {
                        if (gameClient == null)
                        {
                            continue;
                        }
                        if (gameClient.IsConnected)
                        {
                            if (gameClient.Player != null)
                            {
                                gameClient.Out.SendPingTime(gameClient.Player);
                                if (AntiAddictionMgr.ISASSon && AntiAddictionMgr.count == 0)
                                {
                                    AntiAddictionMgr.count++;
                                }
                            }
                            else if (gameClient.PingTime + num < DateTime.Now.Ticks)
                            {
                                gameClient.Disconnect();
                            }
                        }
                        else
                        {
                            gameClient.Disconnect();
                        }
                    }
                }
                log.Info("End ping check....");
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("PingCheck callback", exception);
                }
            }
            try
            {
                log.Info("Begin ping center check....");
                Instance.LoginServer.SendPingCenter();
                log.Info("End ping center check....");
            }
            catch (Exception exception2)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("PingCheck center callback", exception2);
                }
            }
        }

        public bool RecompileScripts()
        {
            m_compiled = false;
            if (!m_compiled)
            {
                string path = Configuration.RootDirectory + Path.DirectorySeparatorChar + "scripts";
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                string[] asm_names = Configuration.ScriptAssemblies.Split(',');
                m_compiled = ScriptMgr.CompileScripts(compileVB: false, path, Configuration.ScriptCompilationTarget, asm_names);
            }
            return m_compiled;
        }

        public void ReleasePacketBuffer(byte[] buf)
        {
            if (buf != null && GC.GetGeneration(buf) >= GC.MaxGeneration)
            {
                lock (m_packetBufPool.SyncRoot)
                {
                    m_packetBufPool.Enqueue(buf);
                }
            }
        }

        protected void SaveRecordProc(object sender)
        {
            try
            {
                int tickCount = Environment.TickCount;
                if (log.IsInfoEnabled)
                {
                    log.Info("Saving Record...");
                    log.Debug("Save ThreadId=" + Thread.CurrentThread.ManagedThreadId);
                }
                ThreadPriority priority = Thread.CurrentThread.Priority;
                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                LogMgr.Save();
                Thread.CurrentThread.Priority = priority;
                tickCount = Environment.TickCount - tickCount;
                if (log.IsInfoEnabled)
                {
                    log.Info("Saving Record complete!");
                }
                if (tickCount > 120000)
                {
                    log.WarnFormat("Saved all Record  in {0} ms", tickCount);
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("SaveRecordProc", exception);
                }
            }
        }

        protected void SaveTimerProc(object sender)
        {
            try
            {
                int startTick = Environment.TickCount;
                if (log.IsInfoEnabled)
                {
                    log.Info("Saving database...");
                    log.Debug("Save ThreadId=" + Thread.CurrentThread.ManagedThreadId);
                }
                int saveCount = 0;
                ThreadPriority priority = Thread.CurrentThread.Priority;
                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                GamePlayer[] list = WorldMgr.GetAllPlayers();
                foreach (GamePlayer p in list)
                {
                    p.SavePlayerInfo();
                    p.SaveIntoDatabase();
                    WorldMgr.IsAccountLimit(p);
                    saveCount++;
                }
                WorldMgr.UpdateCaddyRank();
                WorldMgr.ScanShopFreeVaildDate();
                AcademyMgr.RemoveOldRequest();
                Thread.CurrentThread.Priority = priority;
                startTick = Environment.TickCount - startTick;
                if (log.IsInfoEnabled)
                {
                    log.Info("Saving database complete!");
                    log.Info("Saved all databases and " + saveCount + " players in " + startTick + "ms");
                }
                if (startTick > 2 * 60 * 1000)
                {
                    log.WarnFormat("Saved all databases and {0} players in {1} ms", saveCount, startTick);
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("SaveTimerProc", exception);
                }
            }
            finally
            {
                GameEventMgr.Notify(GameServerEvent.WorldSave);
            }
        }

        protected void RenameBatchs(object value)
        {
            try
            {
                PlayerBussiness pb = new PlayerBussiness();
                pb.RenamesBatch();
                log.Info("RenamesBatch complete!");
            }
            catch (Exception err)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("RenamesBatch Error", err);
                }
            }
        }

        public void Shutdown()
        {
            Instance.LoginServer.SendShutdown(isStoping: true);
            _shutdownTimer = new Timer(ShutDownCallBack, null, 0, 60000);
        }

        private void ShutDownCallBack(object state)
        {
            try
            {
                _shutdownCount--;
                Console.WriteLine($"Server will shutdown after {_shutdownCount} mins!");
                GameClient[] allClients = Instance.GetAllClients();
                GameClient[] array = allClients;
                if (_shutdownCount == 0)
                {
                    Console.WriteLine("Server has stopped!");
                    Instance.LoginServer.SendShutdown(isStoping: false);
                    _shutdownTimer.Dispose();
                    _shutdownTimer = null;
                    Instance.Stop();
                    return;
                }
                foreach (GameClient gameClient in array)
                {
                    if (gameClient.Out != null)
                    {
                        gameClient.Out.SendMessage(eMessageType.GM_NOTICE, string.Format("{0}{1}{2}", LanguageMgr.GetTranslation("Game.Service.actions.ShutDown1"), _shutdownCount, LanguageMgr.GetTranslation("Game.Service.actions.ShutDown2")));
                    }
                }

            }
            catch (Exception message)
            {
                log.Error(message);
            }
        }

        public override bool Start()
        {
            if (m_isRunning)
            {
                return false;
            }
            try
            {
                AppDomain.CurrentDomain.UnhandledException += CurrentDomain_UnhandledException;
                Thread.CurrentThread.Priority = ThreadPriority.Normal;
                GameProperties.Refresh();
                if (!InitComponent(RecompileScripts(), "Recompile Scripts"))
                {
                    bool flag = false;
                }
                if (!InitComponent(ConsortiaLevelMgr.Init(), "ConsortiaLevelMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(StartScriptComponents(), "Script components"))
                {
                    return false;
                }
                if (!InitComponent(GameProperties.EDITION == Edition, "Edition: " + Edition))
                {
                    return false;
                }
                if (!InitComponent(InitSocket(IPAddress.Parse(Configuration.Ip), Configuration.Port), "InitSocket Port: " + Configuration.Port))
                {
                    return false;
                }
                if (!InitComponent(AllocatePacketBuffers(), "AllocatePacketBuffers()"))
                {
                    return false;
                }
                if (!InitComponent(LogMgr.Setup(Configuration.GAME_TYPE, Configuration.ServerID, Configuration.AreaID), "LogMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(WorldMgr.Init(), "WorldMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(MapMgr.Init(), "MapMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(ItemMgr.Init(), "ItemMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(ItemBoxMgr.Init(), "ItemBox Init"))
                {
                    return false;
                }
                if (!InitComponent(BallMgr.Init(), "BallMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(ExerciseMgr.Init(), "ExerciseMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(LevelMgr.Init(), "levelMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(BallConfigMgr.Init(), "BallConfigMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(FusionMgr.Init(), "FusionMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(UserBoxMgr.Init(), "UserBoxMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(AwardMgr.Init(), "AwardMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(AchievementMgr.Init(), "AchievementMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(NPCInfoMgr.Init(), "NPCInfoMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(MissionInfoMgr.Init(), "MissionInfoMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(PveInfoMgr.Init(), "PveInfoMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(DropMgr.Init(), "Drop Init"))
                {
                    return false;
                }
                if (!InitComponent(FightRateMgr.Init(), "FightRateMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(RefineryMgr.Init(), "RefineryMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(StrengthenMgr.Init(), "StrengthenMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(PropItemMgr.Init(), "PropItemMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(ShopMgr.Init(), "ShopMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(QuestMgr.Init(), "QuestMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(RoomMgr.Setup(Configuration.MaxRoomCount), "RoomMgr.Setup"))
                {
                    return false;
                }
                if (!InitComponent(GameMgr.Setup(Configuration.ServerID, GameProperties.BOX_APPEAR_CONDITION), "GameMgr.Start()"))
                {
                    return false;
                }
                if (!InitComponent(ConsortiaMgr.Init(), "ConsortiaMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(ConsortiaExtraMgr.Init(), "ConsortiaExtraMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(LanguageMgr.Setup(""), "LanguageMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(RateMgr.Init(Configuration), "ExperienceRateMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(WindMgr.Init(), "WindMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(CardMgr.Init(), "CardMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(CardBuffMgr.Init(), "CardBuffMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(FairBattleRewardMgr.Init(), "FairBattleRewardMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(PetMgr.Init(), "PetMgr Setup"))
                {
                    return false;
                }
                if (!InitComponent(MacroDropMgr.Init(), "MacroDropMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(MarryRoomMgr.Init(), "MarryRoomMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(RankMgr.Init(), "RankMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(CommunalActiveMgr.Init(), "CommunalActiveMgr Setup"))
                {
                    return false;
                }
                if (!InitComponent(QQTipsMgr.Init(), "QQTipsMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(SubActiveMgr.Init(), "SubActiveMgr Setup"))
                {
                    return false;
                }
                if (!InitComponent(EventAwardMgr.Init(), "EventAwardMgr Setup"))
                {
                    return false;
                }
                if (!InitComponent(EventLiveMgr.Init(), "EventLiveMgr Setup"))
                {
                    return false;
                }
                if (!InitComponent(AcademyMgr.Init(), "AcademyMgr Setup"))
                {
                    return false;
                }
                if (!InitComponent(BattleMgr.Setup(), "BattleMgr Setup"))
                {
                    return false;
                }
                if (!InitComponent(InitGlobalTimer(), "Init Global Timers"))
                {
                    return false;
                }
                if (!InitComponent(LogMgr.Setup(1, Configuration.ServerID, Configuration.AreaID), "LogMgr Setup"))
                {
                    return false;
                }
                GameEventMgr.Notify(ScriptEvent.Loaded);
                if (!InitComponent(InitLoginServer(), "Login To CenterServer"))
                {
                    return false;
                }
                if (!InitComponent(InitOtherLoginServer(), "Login To OtherCenterServer"))
                {
                    return false;
                }
                if (!InitComponent(HotSpringMgr.Init(), "HotSpringMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(PetMoePropertyMgr.Init(), "PetMoePropertyMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(RingStationMgr.Init(), "AutoBot Init"))
                {
                    return false;
                }
                if (!InitComponent(RobotManager.Init(), "RobotManager Start"))
                {
                    return false;
                }
                if (!InitComponent(LittleGameWorldMgr.Init(), "LittleGameWorldMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(TaskMgr.Init(), "TaskMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(AccumulActiveLoginMgr.Init(), "AccumulActiveLoginMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(NewTitleMgr.Init(), "NewTitleMgr Init"))
                {
                    return false;
                }
                if (!InitComponent(ConsortiaTaskMgr.Init(), "ConsortiaTaskMgr.Init"))
                    return false;
                if (!InitComponent(ActiveMgr.Init(), "ActiveMgr Init"))
                    return false;
                if (!InitComponent(WorldEventMgr.Init(), "WorldEventMgr Init"))
                    return false;
                if (!InitComponent(ActiveSystemMgr.Init(), "ActiveSystemMgr Init"))
                    return false;
                if (!InitComponent(FightSpiritTemplateMgr.Init(), "FightSpiritTemplateMgr Init"))
                    return false;
                if (!InitComponent(ClothGroupTemplateInfoMgr.Init(), "ClothGroupTemplateInfoMgr Setup"))
                    return false;
                if (!InitComponent(ClothPropertyTemplateInfoMgr.Init(), "ClothPropertyTemplateInfoMgr Setup"))
                    return false;
                if (!InitComponent(TotemMgr.Init(), "TotemMgr Init"))
                    return false;
                if (!InitComponent(TotemHonorMgr.Init(), "TotemHonorMgr Init"))
                    return false;
                //if (!InitComponent(DailyLeagueAwardMgr.Init(), "DailyLeagueAwardMgr Init"))
                //    return false;
                RoomMgr.Start();
                GameMgr.Start();
                BattleMgr.Start();
                MacroDropMgr.Start();
                if (!InitComponent(base.Start(), "base.Start()"))
                {
                    return false;
                }
                GameEventMgr.Notify(GameServerEvent.Started, this);
                GC.Collect(GC.MaxGeneration);
                if (log.IsInfoEnabled)
                {
                    log.Info("GameServer is now open for connections!");
                }
                m_isRunning = true;
                return true;
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Failed to start the server", exception);
                }
                return false;
            }
        }

        protected bool StartScriptComponents()
        {
            try
            {
                if (log.IsInfoEnabled)
                {
                    log.Info("Server rules: true");
                }
                ScriptMgr.InsertAssembly(typeof(GameServer).Assembly);
                ScriptMgr.InsertAssembly(typeof(BaseGame).Assembly);
                ScriptMgr.InsertAssembly(typeof(BaseServer).Assembly);
                foreach (Assembly item in new ArrayList(ScriptMgr.Scripts))
                {
                    GameEventMgr.RegisterGlobalEvents(item, typeof(GameServerStartedEventAttribute), GameServerEvent.Started);
                    GameEventMgr.RegisterGlobalEvents(item, typeof(GameServerStoppedEventAttribute), GameServerEvent.Stopped);
                    GameEventMgr.RegisterGlobalEvents(item, typeof(ScriptLoadedEventAttribute), ScriptEvent.Loaded);
                    GameEventMgr.RegisterGlobalEvents(item, typeof(ScriptUnloadedEventAttribute), ScriptEvent.Unloaded);
                }
                if (log.IsInfoEnabled)
                {
                    log.Info("Registering global event handlers: true");
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("StartScriptComponents", exception);
                }
                return false;
            }
            return true;
        }




        public override void Stop()
        {
            if (m_isRunning)
            {
                m_isRunning = false;
                if (!MarryRoomMgr.UpdateBreakTimeWhereServerStop())
                {
                    Console.WriteLine("Update BreakTime failed");
                }
                RoomMgr.Stop();
                GameMgr.Stop();
                WorldMgr.Stop();
                RingStationMgr.RingStationBattle.Stop();
                if (_loginServer != null)
                {
                    _loginServer.Disconnected -= loginServer_Disconnected;
                    _loginServer.Disconnect();
                }
                if (m_pingCheckTimer != null)
                {
                    m_pingCheckTimer.Change(-1, -1);
                    m_pingCheckTimer.Dispose();
                    m_pingCheckTimer = null;
                }
                if (m_saveDbTimer != null)
                {
                    m_saveDbTimer.Change(-1, -1);
                    m_saveDbTimer.Dispose();
                    m_saveDbTimer = null;
                }
                if (m_saveRecordTimer != null)
                {
                    m_saveRecordTimer.Change(-1, -1);
                    m_saveRecordTimer.Dispose();
                    m_saveRecordTimer = null;
                }
                if (m_buffScanTimer != null)
                {
                    m_buffScanTimer.Change(-1, -1);
                    m_buffScanTimer.Dispose();
                    m_buffScanTimer = null;
                }
                if (m_qqTipScanTimer != null)
                {
                    m_qqTipScanTimer.Change(-1, -1);
                    m_qqTipScanTimer.Dispose();
                    m_qqTipScanTimer = null;
                }
                if (m_bagMailScanTimer != null)
                {
                    m_bagMailScanTimer.Change(-1, -1);
                    m_bagMailScanTimer.Dispose();
                    m_bagMailScanTimer = null;
                }
                base.Stop();
                Thread.CurrentThread.Priority = ThreadPriority.BelowNormal;
                log.Info("Server Stopped!");
                Console.WriteLine("Server Stopped!");
            }
        }
    }
}
