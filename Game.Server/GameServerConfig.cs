using Bussiness;
using Game.Base.Config;
using log4net;
using SqlDataProvider.Data;
using System;
using System.IO;
using System.Reflection;

namespace Game.Server
{
    public class GameServerConfig : BaseAppConfig
    {
        [ConfigProperty("AppID", "代理商编号", 1)]
		public int AppID;

        [ConfigProperty("AreaID", "分区编号", 4)]
		public int AreaID;

        [ConfigProperty("CountRecord", "是否记录日志", true)]
		public bool CountRecord;

        [ConfigProperty("DBAutosaveInterval", "数据库自动保存的时间间隔,分钟为单位", 5)]
		public int DBSaveInterval;

        [ConfigProperty("GameType", "游戏类型", 0)]
		public int GAME_TYPE;

        [ConfigProperty("InterName", "接口类型", "sevenroad")]
		public string INTERFACE_NAME;

        [ConfigProperty("IP", "频道的IP", "68.183.198.57")]
		public string Ip;

        private static readonly ILog log;

        [ConfigProperty("LogConfigFile", "日志配置文件", "logconfig.xml")]
		public string LogConfigFile;

        [ConfigProperty("LogPath", "日志路径", 1)]
		public string LogPath;

        [ConfigProperty("LoginServerIp", "中心服务器的IP", "68.183.198.57")]
		public string LoginServerIp;

		[ConfigProperty("OtherLoginServer", "中心服务器的IP", "")]
		public string OtherLoginServer;

		[ConfigProperty("LoginServerPort", "中心服务器的端口", 9202)]
		public int LoginServerPort;

        [ConfigProperty("MaxClientCount", "最大连接数", 8000)]
		public int MaxClientCount = 2000;

        public int MaxPlayerCount = 2000;

        public int MaxRoomCount = 1000;

        [ConfigProperty("PingCheckInterval", "PING检查时间间隔,分钟为单位", 5)]
		public int PingCheckInterval;

        [ConfigProperty("Port", "频道开放端口", 9500)]
		public int Port;

        [ConfigProperty("PrivateKey", "RSA的私钥", "")]
		public string PrivateKey;

        public string RootDirectory;

        [ConfigProperty("SaveRecordInterval", "统计信息保存的时间间隔,分钟为单位", 5)]
		public int SaveRecordInterval;

        [ConfigProperty("ScriptAssemblies", "脚本编译引用库", "")]
		public string ScriptAssemblies;

        [ConfigProperty("ScriptCompilationTarget", "脚本编译目标名称", "")]
		public string ScriptCompilationTarget;

        [ConfigProperty("ServerID", "服务器编号", 4)]
		public int ServerID;

        [ConfigProperty("ServerName", "频道的名称", "7Road")]
		public string ServerName;

        [ConfigProperty("TxtRecord", "是否记录统计信息", true)]
		public bool TxtRecord;

        [ConfigProperty("Xu_Rate", "最大连接数", 1)]
		public int Xu_Rate = 2000;

        [ConfigProperty("ZoneId", "服务器编号", 4)]
		public int ZoneId;

        [ConfigProperty("ZoneName", "频道的名称", "7Road")]
		public string ZoneName;

        [ConfigProperty("DoubleEvent", "Evento duplicado", true)]
		public bool DoubleEvent;

		public GameServerConfig()
        {
			Load(typeof(GameServerConfig));
        }

        protected override void Load(Type type)
        {
			if (Assembly.GetEntryAssembly() != null)
			{
				RootDirectory = new FileInfo(Assembly.GetEntryAssembly().Location).DirectoryName;
			}
			else
			{
				RootDirectory = new FileInfo(Assembly.GetAssembly(typeof(GameServer)).Location).DirectoryName;
			}
			base.Load(type);
			using ServiceBussiness serviceBussiness = new ServiceBussiness();
			ServerInfo serviceSingle = serviceBussiness.GetServiceSingle(ServerID);
			if (serviceSingle == null)
			{
				log.ErrorFormat("Can't find server config,server id {0}", ServerID);
				return;
			}
			ServerName = serviceSingle.Name;
			MaxRoomCount = serviceSingle.Room;
			MaxPlayerCount = serviceSingle.Total;
			ZoneId = serviceSingle.ZoneId;
			ZoneName = serviceSingle.ZoneName;
        }

        public void Refresh()
        {
			Load(typeof(GameServerConfig));
			GameServer.Instance.InitGlobalTimer();
        }

        static GameServerConfig()
        {
			log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }
    }
}
