using Bussiness;
using Bussiness.Managers;
using Bussiness.Protocol;
using Center.Server.Managers;
using Center.Server.Statics;
using Game.Base;
using Game.Base.Events;
using Game.Base.Packets;
using Game.Server.Managers;
using log4net;
using log4net.Config;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.Reflection;
using System.Threading;

namespace Center.Server
{
    public class CenterServer : BaseServer
    {
        private bool _aSSState;

        private CenterServerConfig _config;

        private bool _dailyAwardState;

        private static CenterServer _instance;

        private readonly int awardTime = 20;

        private bool boss = true;

        private bool close = true;

        private string Edition = "2612558";

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private Timer m_consortiaboss;

        private Timer m_loginLapseTimer;

        private Timer m_saveDBTimer;

        private Timer m_saveRecordTimer;

        private Timer m_scanAuction;

        private Timer m_scanConsortia;

        private Timer m_scanMail;

        private Timer m_sytemNotice;

        private Timer m_worldEvent;

        private int minute = 5;

        private DateTime minute1;

        private Random rand = new Random();

        public bool ASSState
        {
			get
			{
				return _aSSState;
			}
			set
			{
				_aSSState = value;
			}
        }

        public bool DailyAwardState
        {
			get
			{
				return _dailyAwardState;
			}
			set
			{
				_dailyAwardState = value;
			}
        }

        public static CenterServer Instance=> _instance;

        public CenterServer(CenterServerConfig config)
        {
			_config = config;
			LoadConfig();
        }

        public bool AvailTime(DateTime startTime, int min)
        {
			int num = min - (int)(DateTime.Now - startTime).TotalMinutes;
			return num > 0;
        }

        public static void CreateInstance(CenterServerConfig config)
        {
			if (Instance == null)
			{
				FileInfo configFile = new FileInfo(config.LogConfigFile);
				if (!configFile.Exists)
				{
					ResourceUtil.ExtractResource(configFile.Name, configFile.FullName, Assembly.GetAssembly(typeof(CenterServer)));
				}
				XmlConfigurator.ConfigureAndWatch(configFile);
				_instance = new CenterServer(config);
			}
        }

        private void CurrentDomain_UnhandledException(object sender, UnhandledExceptionEventArgs e)
        {
			log.Fatal("Unhandled exception!\n" + e.ExceptionObject.ToString());
			if (e.IsTerminating)
			{
				LogManager.Shutdown();
			}
        }

        public void DisposeGlobalTimers()
        {
			if (m_saveDBTimer != null)
			{
				m_saveDBTimer.Dispose();
			}
			if (m_loginLapseTimer != null)
			{
				m_loginLapseTimer.Dispose();
			}
			if (m_saveRecordTimer != null)
			{
				m_saveRecordTimer.Dispose();
			}
			if (m_scanAuction != null)
			{
				m_scanAuction.Dispose();
			}
			if (m_scanMail != null)
			{
				m_scanMail.Dispose();
			}
			if (m_scanConsortia != null)
			{
				m_scanConsortia.Dispose();
			}
			if (m_worldEvent != null)
			{
				m_worldEvent.Dispose();
			}
			if (m_sytemNotice != null)
			{
				m_sytemNotice.Dispose();
			}
			if (m_consortiaboss != null)
			{
				m_consortiaboss.Dispose();
			}
        }

        public new ServerClient[] GetAllClients()
        {
			ServerClient[] array = null;
			lock (_clients.SyncRoot)
			{
				array = new ServerClient[_clients.Count];
				_clients.Keys.CopyTo(array, 0);
			}
			return array;
        }

        protected override BaseClient GetNewClient()
        {
			return new ServerClient(this);
        }

        protected bool InitComponent(bool componentInitState, string text)
        {
			log.Info(text + ": " + componentInitState);
			if (!componentInitState)
			{
				Stop();
			}
			return componentInitState;
        }

        public bool InitGlobalTimers()
        {
			int dueTime = _config.SaveIntervalInterval * 60 * 1000;
			if (m_saveDBTimer == null)
			{
				m_saveDBTimer = new Timer(SaveTimerProc, null, dueTime, dueTime);
			}
			else
			{
				m_saveDBTimer.Change(dueTime, dueTime);
			}
			dueTime = _config.SystemNoticeInterval * 60 * 1000;
			if (m_sytemNotice == null)
			{
				m_sytemNotice = new Timer(SystemNoticeTimerProc, null, dueTime, dueTime);
			}
			else
			{
				m_sytemNotice.Change(dueTime, dueTime);
			}
			dueTime = _config.LoginLapseInterval * 60 * 1000;
			if (m_loginLapseTimer == null)
			{
				m_loginLapseTimer = new Timer(LoginLapseTimerProc, null, dueTime, dueTime);
			}
			else
			{
				m_loginLapseTimer.Change(dueTime, dueTime);
			}
			dueTime = _config.SaveRecordInterval * 60 * 1000;
			if (m_saveRecordTimer == null)
			{
				m_saveRecordTimer = new Timer(SaveRecordProc, null, dueTime, dueTime);
			}
			else
			{
				m_saveRecordTimer.Change(dueTime, dueTime);
			}
			dueTime = _config.ScanAuctionInterval * 60 * 1000;
			if (m_scanAuction == null)
			{
				m_scanAuction = new Timer(ScanAuctionProc, null, dueTime, dueTime);
			}
			else
			{
				m_scanAuction.Change(dueTime, dueTime);
			}
			dueTime = _config.ScanMailInterval * 60 * 1000;
			if (m_scanMail == null)
			{
				m_scanMail = new Timer(ScanMailProc, null, dueTime, dueTime);
			}
			else
			{
				m_scanMail.Change(dueTime, dueTime);
			}
			dueTime = _config.ScanConsortiaInterval * 60 * 1000;
			if (m_scanConsortia == null)
			{
				m_scanConsortia = new Timer(ScanConsortiaProc, null, dueTime, dueTime);
			}
			else
			{
				m_scanConsortia.Change(dueTime, dueTime);
			}
			dueTime = 60000;
			if (m_worldEvent == null)
			{
				m_worldEvent = new Timer(ScanWorldEventProc, null, dueTime, dueTime);
			}
			else
			{
				m_worldEvent.Change(dueTime, dueTime);
			}
			dueTime = 60000;
			if (m_consortiaboss == null)
			{
				m_consortiaboss = new Timer(ScanConsortiabossProc, null, dueTime, dueTime);
			}
			else
			{
				m_consortiaboss.Change(dueTime, dueTime);
			}
			return true;
        }

        public void LoadConfig()
        {
			_aSSState = bool.Parse(ConfigurationManager.AppSettings["AAS"]);
			_dailyAwardState = bool.Parse(ConfigurationManager.AppSettings["DailyAwardState"]);
        }

        protected void LoginLapseTimerProc(object sender)
        {
			try
			{
				Player[] allPlayer = LoginMgr.GetAllPlayer();
				long ticks = DateTime.Now.Ticks;
				long num2 = (long)_config.LoginLapseInterval * 10L * 1000;
				Player[] array = allPlayer;
				Player[] array2 = array;
				foreach (Player player in array2)
				{
					if (player.State == ePlayerState.NotLogin)
					{
						if (player.LastTime + num2 < ticks)
						{
							LoginMgr.RemovePlayer(player.Id);
						}
					}
					else
					{
						player.LastTime = ticks;
					}
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("LoginLapseTimer callback", exception);
				}
			}
        }

        public int NoticeServerUpdate(int serverId, int type)
        {
			ServerClient[] allClients = GetAllClients();
			if (allClients != null)
			{
				ServerClient[] array = allClients;
				ServerClient[] array2 = array;
				foreach (ServerClient client in array2)
				{
					if (client.Info.ID == serverId)
					{
						GSPacketIn pkg = new GSPacketIn(11);
						pkg.WriteInt(type);
						client.SendTCP(pkg);
						return 0;
					}
				}
			}
			return 1;
        }

        public int RateUpdate(int serverId)
        {
			ServerClient[] allClients = GetAllClients();
			if (allClients != null)
			{
				ServerClient[] array = allClients;
				ServerClient[] array2 = array;
				foreach (ServerClient client in array2)
				{
					if (client.Info.ID == serverId)
					{
						GSPacketIn pkg = new GSPacketIn(177);
						pkg.WriteInt(serverId);
						client.SendTCP(pkg);
						return 0;
					}
				}
			}
			return 1;
        }

        public bool RecompileScripts()
        {
			string path = _config.RootDirectory + Path.DirectorySeparatorChar + "scripts";
			if (!Directory.Exists(path))
			{
				Directory.CreateDirectory(path);
			}
			string[] strArray = _config.ScriptAssemblies.Split(',');
			return ScriptMgr.CompileScripts(compileVB: false, path, _config.ScriptCompilationTarget, strArray);
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
					log.WarnFormat("Saved all Record  in {0} ms!", tickCount);
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

        protected void SaveTimerProc(object state)
        {
			try
			{
				int tickCount = Environment.TickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Saving database...");
					log.Debug("Save ThreadId=" + Thread.CurrentThread.ManagedThreadId);
				}
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				ServerMgr.SaveToDatabase();
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Saving database complete!");
					log.Info("Saved all databases " + tickCount + "ms");
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SaveTimerProc", exception);
				}
			}
        }

        protected void ScanAuctionProc(object sender)
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
				string noticeUserID = "";
				using (PlayerBussiness bussiness = new PlayerBussiness())
				{
					bussiness.ScanAuction(ref noticeUserID, GameProperties.Cess);
				}
				string[] array = noticeUserID.Split(',');
				string[] array2 = array;
				foreach (string str2 in array2)
				{
					if (!string.IsNullOrEmpty(str2))
					{
						GSPacketIn pkg = new GSPacketIn(117);
						pkg.WriteInt(int.Parse(str2));
						pkg.WriteInt(1);
						SendToALL(pkg);
					}
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Scan Auction complete!");
				}
				if (tickCount > 120000)
				{
					log.WarnFormat("Scan all Auction  in {0} ms", tickCount);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ScanAuctionProc", exception);
				}
			}
        }

        protected void ScanConsortiabossProc(object sender)
        {
			try
			{
				int tickCount = Environment.TickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Scan Consortiaboss...");
					log.Debug("Scan ThreadId=" + Thread.CurrentThread.ManagedThreadId);
				}
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				ConsortiaBossMgr.UpdateTime();
				ConsortiaBossMgr.TimeCheckingAward++;
				if (ConsortiaBossMgr.TimeCheckingAward > 5)
				{
					List<int> allConsortiaGetAward = ConsortiaBossMgr.GetAllConsortiaGetAward();
					GSPacketIn pkg = new GSPacketIn(185);
					pkg.WriteInt(allConsortiaGetAward.Count);
					foreach (int num2 in allConsortiaGetAward)
					{
						pkg.WriteInt(num2);
					}
					SendToALL(pkg);
					ConsortiaBossMgr.TimeCheckingAward = 0;
					log.Info("Scan Consortiaboss award complete!");
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Scan Consortiaboss complete!");
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ScanConsortiabossProc", exception);
				}
			}
        }

        protected void ScanConsortiaProc(object sender)
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
				string noticeID = "";
				using (ConsortiaBussiness bussiness = new ConsortiaBussiness())
				{
					bussiness.ScanConsortia(ref noticeID);
				}
				string[] array = noticeID.Split(',');
				string[] array2 = array;
				foreach (string str2 in array2)
				{
					if (!string.IsNullOrEmpty(str2))
					{
						GSPacketIn pkg = new GSPacketIn(128);
						pkg.WriteByte(2);
						pkg.WriteInt(int.Parse(str2));
						SendToALL(pkg);
					}
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Scan Consortia complete!");
				}
				if (tickCount > 120000)
				{
					log.WarnFormat("Scan all Consortia in {0} ms", tickCount);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ScanConsortiaProc", exception);
				}
			}
        }

        protected void ScanMailProc(object sender)
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
				string noticeUserID = "";
				using (PlayerBussiness bussiness = new PlayerBussiness())
				{
					bussiness.ScanMail(ref noticeUserID);
				}
				string[] array = noticeUserID.Split(',');
				string[] array2 = array;
				foreach (string str2 in array2)
				{
					if (!string.IsNullOrEmpty(str2))
					{
						GSPacketIn pkg = new GSPacketIn(117);
						pkg.WriteInt(int.Parse(str2));
						pkg.WriteInt(1);
						SendToALL(pkg);
					}
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Scan Mail complete!");
				}
				if (tickCount > 120000)
				{
					log.WarnFormat("Scan all Mail in {0} ms", tickCount);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ScanMailProc", exception);
				}
			}
        }

        protected void ScanWorldEventProc(object sender)
        {
			try
			{
				int tickCount = Environment.TickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Scan  WorldEvent ...");
					log.Debug("Scan ThreadId=" + Thread.CurrentThread.ManagedThreadId);
				}
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				SendUpdateWorldEvent();
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Scan WorldEvent complete!");
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Scan WorldEvent Proc", exception);
				}
			}
        }

        public bool SendAAS(bool state)
        {
			if (StaticFunction.UpdateConfig("Center.Service.exe.config", "AAS", state.ToString()))
			{
				ASSState = state;
				GSPacketIn pkg = new GSPacketIn(7);
				pkg.WriteBoolean(state);
				SendToALL(pkg);
				return true;
			}
			return false;
        }

        public void SendBattleGoundOpenClose(bool value)
        {
			GSPacketIn pkg = new GSPacketIn(88);
			pkg.WriteBoolean(value);
			SendToALL(pkg);
        }

        public void SendConfigState()
        {
			GSPacketIn pkg = new GSPacketIn(8);
			pkg.WriteBoolean(ASSState);
			pkg.WriteBoolean(DailyAwardState);
			SendToALL(pkg);
        }

        public bool SendConfigState(int type, bool state)
        {
			string name = string.Empty;
			switch (type)
			{
			case 1:
				name = "AAS";
				break;
			case 2:
				name = "DailyAwardState";
				break;
			default:
				return false;
			}
			if (!StaticFunction.UpdateConfig("Center.Service.exe.config", name, state.ToString()))
			{
				return false;
			}
			switch (type)
			{
			case 1:
				ASSState = state;
				break;
			case 2:
				DailyAwardState = state;
				break;
			}
			SendConfigState();
			return true;
        }

        public void SendConsortiaDelete(int consortiaID)
        {
			GSPacketIn pkg = new GSPacketIn(128);
			pkg.WriteByte(5);
			pkg.WriteInt(consortiaID);
			SendToALL(pkg);
        }

        public void SendFightFootballTime(bool value)
        {
			GSPacketIn pkg = new GSPacketIn(89);
			pkg.WriteBoolean(value);
			SendToALL(pkg);
        }

        public void SendLeagueOpenClose(bool value)
        {
			GSPacketIn pkg = new GSPacketIn(87);
			pkg.WriteBoolean(value);
			SendToALL(pkg);
        }

        public void SendPrivateInfo()
        {
			int index = WorldMgr.currentPVE_ID;
			GSPacketIn pkg = new GSPacketIn(80);
			pkg.WriteLong(WorldMgr.MAX_BLOOD);
			pkg.WriteLong(WorldMgr.current_blood);
			pkg.WriteString(WorldMgr.name[index]);
			pkg.WriteString(WorldMgr.bossResourceId[index]);
			pkg.WriteInt(WorldMgr.Pve_Id[index]);
			pkg.WriteBoolean(WorldMgr.fightOver);
			pkg.WriteBoolean(WorldMgr.roomClose);
			pkg.WriteDateTime(WorldMgr.begin_time);
			pkg.WriteDateTime(WorldMgr.end_time);
			pkg.WriteInt(WorldMgr.fight_time);
			pkg.WriteBoolean(WorldMgr.worldOpen);
			SendToALL(pkg);
        }

        public void SendPrivateInfo(string name)
        {
			if (WorldMgr.CheckName(name))
			{
				GSPacketIn pkg = new GSPacketIn(85);
				RankingPersonInfo singleRank = WorldMgr.GetSingleRank(name);
				pkg.WriteString(name);
				pkg.WriteInt(singleRank.Damage);
				pkg.WriteInt(singleRank.Honor);
				SendToALL(pkg);
			}
        }

        public bool SendReload(eReloadType type)
        {
			return SendReload(type.ToString());
        }

        public bool SendReload(string str)
        {
			try
			{
				eReloadType type = (eReloadType)Enum.Parse(typeof(eReloadType), str, ignoreCase: true);
				if (type == eReloadType.server)
				{
					_config.Refresh();
					InitGlobalTimers();
					LoadConfig();
					ServerMgr.ReLoadServerList();
					SendConfigState();
				}
				GSPacketIn pkg = new GSPacketIn(11);
				pkg.WriteInt((int)type);
				SendToALL(pkg, null);
				return true;
			}
			catch (Exception exception)
			{
				log.Error("Order is not Exist!", exception);
			}
			return false;
        }

        public void SendRoomClose(byte type)
        {
			GSPacketIn pkg = new GSPacketIn(83);
			pkg.WriteByte(type);
			SendToALL(pkg);
        }

        public void SendShutdown()
        {
			GSPacketIn pkg = new GSPacketIn(15);
			SendToALL(pkg);
        }

        public void SendSystemNotice(string msg)
        {
			GSPacketIn pkg = new GSPacketIn(10);
			pkg.WriteInt(0);
			pkg.WriteString(msg);
			SendToALL(pkg, null);
        }

        public void SendToALL(GSPacketIn pkg)
        {
			SendToALL(pkg, null);
        }

        public void SendToALL(GSPacketIn pkg, ServerClient except)
        {
			ServerClient[] allClients = GetAllClients();
			if (allClients == null)
			{
				return;
			}
			ServerClient[] array = allClients;
			ServerClient[] array2 = array;
			foreach (ServerClient client in array2)
			{
				if (client != except)
				{
					client.SendTCP(pkg);
				}
			}
        }

        public void SendUpdateRank(bool type)
        {
			List<RankingPersonInfo> list = WorldMgr.SelectTopTen();
			if (list.Count == 0)
			{
				return;
			}
			GSPacketIn pkg = new GSPacketIn(81);
			pkg.WriteBoolean(type);
			pkg.WriteInt(list.Count);
			foreach (RankingPersonInfo info in list)
			{
				pkg.WriteInt(info.ID);
				pkg.WriteString(info.Name);
				pkg.WriteInt(info.Damage);
			}
			SendToALL(pkg);
        }

        public void SendUpdateWorldBlood()
        {
			GSPacketIn pkg = new GSPacketIn(79);
			pkg.WriteLong(WorldMgr.MAX_BLOOD);
			pkg.WriteLong(WorldMgr.current_blood);
			SendToALL(pkg);
        }

        public void SendUpdateWorldEvent()
        {
			//int timenow = DateTime.Now.Hour;//.ToString("HH");
			//if (timenow >= 20 && timenow < 22)
			//{
			//	if (!ActiveSystemMgr.IsLeagueOpen)
			//	{
			//		SendLeagueOpenClose(true);
			//		_wzm.IsLeagueOpen = true;
			//		_wzm.LeagueOpenTime = DateTime.Now;
			//		SendSystemNotice(LanguageMgr.GetTranslation("Center.Server.ServerClient.LeagueOpen"));
			//	}
			//}
			//else
			//{
			//	if (_wzm.IsLeagueOpen)
			//	{
			//		SendLeagueOpenClose(false);
			//		_wzm.IsLeagueOpen = false;
			//		SendSystemNotice(LanguageMgr.GetTranslation("Center.Server.ServerClient.LeagueOpen"));
			//	}
			//}
		}

        public void SendWorldBossFightOver()
        {
			GSPacketIn pkg = new GSPacketIn(82);
			SendToALL(pkg);
        }

        public override bool Start()
        {
			try
			{
				Thread.CurrentThread.Priority = ThreadPriority.Normal;
				AppDomain.CurrentDomain.UnhandledException += CurrentDomain_UnhandledException;
				GameProperties.Refresh();
				if (!InitComponent(RecompileScripts(), "Recompile Scripts"))
				{
					return false;
				}
				if (!InitComponent(StartScriptComponents(), "Script components"))
				{
					return false;
				}
				if (!InitComponent(GameProperties.EDITION == Edition, "Check Server Edition:" + Edition))
				{
					return false;
				}
				if (!InitComponent(InitSocket(IPAddress.Parse(_config.Ip), _config.Port), "InitSocket Port:" + _config.Port))
				{
					return false;
				}
				if (!InitComponent(CenterService.Start(), "Center Service"))
				{
					return false;
				}
				if (!InitComponent(ServerMgr.Start(), "Load serverlist"))
				{
					return false;
				}
				if (!InitComponent(MacroDropMgr.Init(), "Init MacroDropMgr"))
				{
					return false;
				}
				if (!InitComponent(LanguageMgr.Setup(""), "LanguageMgr Init"))
				{
					return false;
				}
				if (!InitComponent(WorldMgr.Start(), "WorldMgr Init"))
				{
					return false;
				}
				if (!InitComponent(InitGlobalTimers(), "Init Global Timers"))
				{
					return false;
				}
				if (!InitComponent(NewTitleMgr.Init(), "NewTitleMgr Init"))
				{
					return false;
				}
				if (!InitComponent(WorldEventMgr.Init(), "WorldEventMgr Init"))
					return false;
				GameEventMgr.Notify(ScriptEvent.Loaded);
				MacroDropMgr.Start();
				if (!InitComponent(base.Start(), "base.Start()"))
				{
					return false;
				}
				GameEventMgr.Notify(GameServerEvent.Started, this);
				GC.Collect(GC.MaxGeneration);
				log.Info("GameServer is now open for connections!");
				GameProperties.Save();
				return true;
			}
			catch (Exception exception)
			{
				log.Error("Failed to start the server", exception);
				return false;
			}
        }

        protected bool StartScriptComponents()
        {
			try
			{
				ScriptMgr.InsertAssembly(typeof(CenterServer).Assembly);
				ScriptMgr.InsertAssembly(typeof(BaseServer).Assembly);
				Assembly[] scripts = ScriptMgr.Scripts;
				Assembly[] array = scripts;
				foreach (Assembly assembly in array)
				{
					GameEventMgr.RegisterGlobalEvents(assembly, typeof(GameServerStartedEventAttribute), GameServerEvent.Started);
					GameEventMgr.RegisterGlobalEvents(assembly, typeof(GameServerStoppedEventAttribute), GameServerEvent.Stopped);
					GameEventMgr.RegisterGlobalEvents(assembly, typeof(ScriptLoadedEventAttribute), ScriptEvent.Loaded);
					GameEventMgr.RegisterGlobalEvents(assembly, typeof(ScriptUnloadedEventAttribute), ScriptEvent.Unloaded);
				}
				log.Info("Registering global event handlers: true");
				return true;
			}
			catch (Exception exception)
			{
				log.Error("StartScriptComponents", exception);
				return false;
			}
        }

        public override void Stop()
        {
			DisposeGlobalTimers();
			SaveTimerProc(null);
			SaveRecordProc(null);
			CenterService.Stop();
			base.Stop();
        }

        protected void SystemNoticeTimerProc(object state)
        {
			try
			{
				int tickCount = Environment.TickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("System Notice ...");
					log.Debug("Save ThreadId=" + Thread.CurrentThread.ManagedThreadId);
				}
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				List<string> notceList = WorldMgr.NotceList;
				if (notceList.Count > 0)
				{
					int num2 = rand.Next(notceList.Count);
					Instance.SendSystemNotice(notceList[num2]);
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("System Notice complete!");
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SystemNoticeTimerProc", exception);
				}
			}
        }
    }
}
