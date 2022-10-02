using Bussiness;
using Game.Base;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.LittleGame.Data;
using Game.Server.LittleGame.Objects;
using Game.Server.Managers;
using log4net;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Game.Server.LittleGame
{
    public static class LittleGameWorldMgr
    {
        private readonly static ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static LittleGamePacketsOut Out = new LittleGamePacketsOut();
        public static LittleGameConfig Config = new LittleGameConfig();

        private static Random rnd = new Random();

        private static int playerCount = 0;

        private static int boguCount = 0;

        private static int boguCount2 = 0;

        public static MapInfo Map;

        public static int PlayerCount => playerCount;

        public static Dictionary<int, object> ScenariObjects = new Dictionary<int, object>();

        private static Timer _ScanTimer;

        private static Timer _SpawTimer;

        public static bool IsOpen = false;

        public static bool Init()
        {
            var result = false;
            try
            {
                InitializeMap();
                ReloadConfig();
                result = true;
            }
            catch (Exception e)
            {
                log.Error(@"LittleGameWorld initialization error", e);
            }
            return result;
        }

        public static void ReloadConfig()
        {
            var strConf = GameProperties.LittleGameBoguConfig.Split('|');

            Config.SmallBoguScore = int.Parse(strConf[0].Split(',')[0]);
            Config.SmallBoguHP = int.Parse(strConf[0].Split(',')[1]);

            Config.MediumBoguScore = int.Parse(strConf[1].Split(',')[0]);
            Config.MediumBoguHP = int.Parse(strConf[1].Split(',')[1]);

            Config.BigBoguScore = int.Parse(strConf[2].Split(',')[0]);
            Config.BigBoguHP = int.Parse(strConf[2].Split(',')[1]);
            Config.BigBoguCatchers = int.Parse(strConf[2].Split(',')[2]);

            Config.HugeBoguScore = int.Parse(strConf[3].Split(',')[0]);
            Config.HugeBoguHP = int.Parse(strConf[3].Split(',')[1]);
            Config.HugeBoguCatchers = int.Parse(strConf[3].Split(',')[2]);

            Config.MaxBoguCount = GameProperties.LittleGameMaxBoguCount;

            if (log.IsInfoEnabled) log.Info(@"LittleGameConfig initialized");
        }

        public static void OpenLittleGameSetup()
        {
            try
            {
                lock (ScenariObjects)
                {
                    boguCount2 = 0;
                    boguCount = 0;
                    playerCount = 0;
                    BoguGenerator();
                    _ScanTimer = new Timer(ScanTimerProc, null, 60000, 60000);
                    _SpawTimer = new Timer(SpawnTimerProc, null, 60000, 60000);
                    IsOpen = true;
                    log.Warn("LittleGame Opened");
                    foreach (var player in WorldMgr.GetAllPlayers())
                    {
                        player.Actives.SendLittleGameActived();
                        player.Out.SendMessage(eMessageType.Normal, "Sự kiện Đại chiến Hút Gà đã bắt đầu! Hãy tham gia từ mục Đặc Sắc tại sảnh game nhé!");
                    }
                }
            }
            catch (Exception e)
            {
                log.Error("LittleGame Setup error", e);
            }
        }

        public static void CloseLittleGame()
        {
            lock (ScenariObjects)
            {
                _ScanTimer?.Dispose();
                _ScanTimer = null;
                _SpawTimer?.Dispose();
                _SpawTimer = null;
                IsOpen = false;

                log.Warn("LittleGame Closed");

                foreach (var keyValuePair in ScenariObjects.Where(kvp => kvp.Value is Bogu).ToList())
                {
                    RemoveBogu((Bogu)keyValuePair.Value);
                }

                foreach (var keyValuePair in ScenariObjects.Where(kvp => kvp.Value is GamePlayer).ToList())
                {
                    RemovePlayer((GamePlayer)keyValuePair.Value);
                }

                foreach (var player in WorldMgr.GetAllPlayers())
                {
                    player.Actives.SendLittleGameActived();
                    player.Out.SendMessage(eMessageType.Normal, "Sự kiện Đại chiến Hút Gà đã kết thúc! \n Hẹn gặp bạn vào lần sau.");
                }
            }
        }


        private static void SpawnTimerProc(object state)
        {
            BoguGenerator();
        }

        public static void RemoveAllBogu()
        {
            try
            {
                lock (ScenariObjects)
                {
                    foreach (var keyValuePair in ScenariObjects.Where(kvp => kvp.Key > 1000000000).ToList())
                    {
                        RemoveBogu((Bogu)keyValuePair.Value);
                    }
                    boguCount = 0;
                }
            }
            catch (Exception error)
            {
                log.Error("LittleGame RemovePlayer Error:", error);
            }
        }

        private static void BoguGenerator()
        {
            if (boguCount > Config.MaxBoguCount)
                return;

            lock (ScenariObjects)
            {
                RemoveAllBogu();
                for (int i = 0; i < Config.MaxBoguCount; i++)
                {
                    int rand = ThreadSafeRandom.NextStatic(0, 1000);
                    Point p = Map.points[ThreadSafeRandom.NextStatic(Map.points.Count - 1)];
                    int id = 1000000000 + boguCount2;
                    Bogu b;
                    if (rand > 900 && rand < 920)
                    {
                        b = new Bogu(id, p.X, p.Y, "bogu7", 3);
                    }
                    else if (rand < 400)
                    {
                        b = new Bogu(id, p.X, p.Y, "bogu" + ThreadSafeRandom.NextStatic(1, 3), 0);
                    }
                    else if (rand > 400 && rand < 900)
                    {
                        string[] model = { "bogu4", "bogu4", "bogu8" };
                        b = new Bogu(id, p.X, p.Y, model[ThreadSafeRandom.NextStatic(0, 2)], 1);
                    }
                    else
                    {
                        b = new Bogu(id, p.X, p.Y, "bogu6", 2);
                    }
                    ScenariObjects.Add(id, b);
                    Out.SendAddBoguToAll(b);
                    boguCount += 1;
                    boguCount2 += 1;
                }
            }
        }

        private static void InitializeMap()
        {
            if (!File.Exists("datas/LittleGame/map.data"))
            {
                throw new Exception("Map Not Found");
            }
            var data = File.ReadAllBytes("datas/LittleGame/map.data");
            var map = new MapReader(Marshal.Uncompress(data));
            Map = new MapInfo(map.ReadInt(), map.ReadInt());
            for (var i = 0; i < Map.Width; i++)
            {
                for (var j = 0; j < Map.Height; j++)
                {
                    if (map.ReadByte() == 1)
                    {
                        Map.points.Add(new Point(i, j));
                        //Map.Cell[i, j] = map.ReadByte() == (byte)1;
                    }
                    map.ReadByte();
                }
            }
        }

        private static void ScanTimerProc(object state)
        {
            try
            {
                if (log.IsInfoEnabled)
                {
                    log.Info("LittleGame Scaning ...");
                    log.Debug(string.Concat("LittleGame ThreadId=", Thread.CurrentThread.ManagedThreadId));
                    log.Info("LittleGame Scan complete!");
                    log.Info(string.Concat(new object[] { "ScenariObjects count ", ScenariObjects.Count, ". Player count ", playerCount }));
                }
            }
            catch (Exception e)
            {

            }
        }

        public static void AddPlayer(GamePlayer player)
        {
            
            try
            {
                lock (ScenariObjects)
                {
                    player.LittleGameInfo.ID = player.PlayerCharacter.ID;
                    player.LittleGameInfo.Actions.DidEnqueue += Actions_DidEnqueue;
                    ScenariObjects.Add(player.LittleGameInfo.ID, player);
                    playerCount += 1;
                    Out.SendEnterWorld(player);
                    Out.SendAddPlayerToAll(player);
                }
            }
            catch (Exception error)
            {
                log.Error("LittleGame AddPlayer Error:", error);
            }
        }

        private static void Actions_DidEnqueue(object sender, DidEnqueueEventArgs<string> e)
        {
            var player = sender as GamePlayer;
            Out.SendActionToAll(player);
            if (e.EnqueuedItem == "livingInhale") return;
            player?.LittleGameInfo.Actions.Dequeue();
        }

        public static void RemovePlayer(GamePlayer player)
        {
            try
            {
                lock (ScenariObjects)
                {
                    Out.SendRemoveLivingToAll(player);
                    ScenariObjects.Remove(player.LittleGameInfo.ID);
                    player.LittleGameInfo.Actions.DidEnqueue -= Actions_DidEnqueue;
                    player.LittleGameInfo.X = 275;
                    player.LittleGameInfo.Y = 30;
                    player.LittleGameInfo.ID = 0;
                    playerCount -= 1;
                }
            }
            catch (Exception error)
            {
                log.Error("LittleGame RemovePlayer Error:", error);
            }
        }

        public static void RemoveBogu(Bogu bogu)
        {
            try
            {
                lock (ScenariObjects)
                {
                    if (ScenariObjects.ContainsKey(bogu.ID))
                    {
                        Out.SendRemoveLivingToAll(bogu);
                        ScenariObjects.Remove(bogu.ID);
                        bogu = null;
                        boguCount--;
                    }
                }
            }
            catch (Exception error)
            {
                log.Error("LittleGame RemovePlayer Error:", error);
            }
        }

        public static void OpenLittleGame(GamePlayer player)
        {
            OpenLittleGameSetup();
            log.Warn($"LittleGame was opened by other player [{player.PlayerCharacter.NickName}]");
        }

        public static void CloseLittleGame(GamePlayer player)
        {
            CloseLittleGame();
            log.Warn($"LittleGame was closed by other player [{player.PlayerCharacter.NickName}]");
        }

        public class MapInfo
        {
            public int Width = 0;
            public int Height = 0;
            public bool[,] Cell;

            public List<Point> points = new List<Point>();

            public MapInfo(int width, int height)
            {
                Width = width;
                Height = height;
                Cell = new bool[width, height];
            }
        }

    }
}
