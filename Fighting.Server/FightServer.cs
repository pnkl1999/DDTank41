using Bussiness;
using Bussiness.Managers;
using Fighting.Server.Games;
using Fighting.Server.Rooms;
using Game.Base;
using Game.Base.Events;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Managers;
using log4net;
using log4net.Config;
using System;
using System.IO;
using System.Net;
using System.Reflection;
using System.Threading;

namespace Fighting.Server
{
    public class FightServer : BaseServer
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static bool m_compiled = false;

        private FightServerConfig m_config;

        private static FightServer m_instance;

        private bool m_running;

        public FightServerConfig Configuration=> m_config;

        public static FightServer Instance=> m_instance;

        private FightServer(FightServerConfig config)
        {
			m_config = config;
        }

        public static void CreateInstance(FightServerConfig config)
        {
			if (m_instance == null)
			{
				FileInfo configFile = new FileInfo(config.LogConfigFile);
				if (!configFile.Exists)
				{
					ResourceUtil.ExtractResource(configFile.Name, configFile.FullName, Assembly.GetAssembly(typeof(FightServer)));
				}
				XmlConfigurator.ConfigureAndWatch(configFile);
				m_instance = new FightServer(config);
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

        public new ServerClient[] GetAllClients()
        {
			ServerClient[] array = null;
			lock (_clients.SyncRoot)
			{
				array = new ServerClient[_clients.Count];
				_clients.Keys.CopyTo(array, 0);
				return array;
			}
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

        public bool RecompileScripts()
        {
			string ScriptAssemblies = "Game.Base.dll,Game.Logic.dll,SqlDataProvider.dll,Bussiness.dll,System.Drawing.dll";
			if (!m_compiled)
			{
				string path = Configuration.RootDirectory + Path.DirectorySeparatorChar + "scripts";
				if (!Directory.Exists(path))
				{
					Directory.CreateDirectory(path);
				}
				string[] strArray = ScriptAssemblies.Split(',');
				m_compiled = ScriptMgr.CompileScripts(compileVB: false, path, Configuration.ScriptCompilationTarget, strArray);
			}
			return m_compiled;
        }

        public void SendToALL(GSPacketIn pkg)
        {
			SendToALL(pkg, null);
        }

        public void SendToALL(GSPacketIn pkg, ServerClient except)
        {
			ServerClient[] list = GetAllClients();
			if (list == null)
			{
				return;
			}
			ServerClient[] array = list;
			foreach (ServerClient client in array)
			{
				if (client != except)
				{
					client.SendTCP(pkg);
				}
			}
        }

        public override bool Start()
        {
			if (m_running)
			{
				return false;
			}
			try
			{
				m_running = true;
				Thread.CurrentThread.Priority = ThreadPriority.Normal;
				AppDomain.CurrentDomain.UnhandledException += CurrentDomain_UnhandledException;
				if (!InitComponent(InitSocket(IPAddress.Parse(m_config.Ip), m_config.Port), "InitSocket Port:" + m_config.Port))
				{
					return false;
				}
				if (!InitComponent(RecompileScripts(), "Recompile Scripts"))
				{
					return false;
				}
				if (!InitComponent(StartScriptComponents(), "Script components"))
				{
					return false;
				}
				if (!InitComponent(ProxyRoomMgr.Setup(), "RoomMgr.Setup"))
				{
					return false;
				}
				if (!InitComponent(GameMgr.Setup(0, 4), "GameMgr.Setup"))
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
				if (!InitComponent(PropItemMgr.Init(), "PropItemMgr Init"))
				{
					return false;
				}
				if (!InitComponent(BallMgr.Init(), "BallMgr Init"))
				{
					return false;
				}
				if (!InitComponent(BallConfigMgr.Init(), "BallConfigMgr Init"))
				{
					return false;
				}
				if (!InitComponent(DropMgr.Init(), "DropMgr Init"))
				{
					return false;
				}
				if (!InitComponent(NPCInfoMgr.Init(), "NPCInfoMgr Init"))
				{
					return false;
				}
				if (!InitComponent(WindMgr.Init(), "WindMgr Init"))
				{
					return false;
				}
				if (!InitComponent(LanguageMgr.Setup(""), "LanguageMgr Init"))
				{
					return false;
				}
				GameEventMgr.Notify(ScriptEvent.Loaded);
				if (!InitComponent(base.Start(), "base.Start()"))
				{
					return false;
				}
				ProxyRoomMgr.Start();
				GameMgr.Start();
				GameEventMgr.Notify(GameServerEvent.Started, this);
				GC.Collect(GC.MaxGeneration);
				log.Info("GameServer is now open for connections!");
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
				ScriptMgr.InsertAssembly(typeof(FightServer).Assembly);
				ScriptMgr.InsertAssembly(typeof(BaseGame).Assembly);
				Assembly[] scripts = ScriptMgr.Scripts;
				Assembly[] array = scripts;
				Assembly[] array2 = array;
				foreach (Assembly asm in array2)
				{
					GameEventMgr.RegisterGlobalEvents(asm, typeof(GameServerStartedEventAttribute), GameServerEvent.Started);
					GameEventMgr.RegisterGlobalEvents(asm, typeof(GameServerStoppedEventAttribute), GameServerEvent.Stopped);
					GameEventMgr.RegisterGlobalEvents(asm, typeof(ScriptLoadedEventAttribute), ScriptEvent.Loaded);
					GameEventMgr.RegisterGlobalEvents(asm, typeof(ScriptUnloadedEventAttribute), ScriptEvent.Unloaded);
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
			if (!m_running)
			{
				return;
			}
			try
			{
				m_running = false;
				GameMgr.Stop();
				ProxyRoomMgr.Stop();
			}
			catch (Exception exception)
			{
				log.Error("Server stopp error:", exception);
			}
			finally
			{
				base.Stop();
			}
        }
    }
}
