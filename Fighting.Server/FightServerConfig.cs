using Game.Base.Config;
using System;
using System.Configuration;
using System.IO;
using System.Reflection;

namespace Fighting.Server
{
    public class FightServerConfig : BaseAppConfig
    {
        [ConfigProperty("IP", "频道的IP", "127.0.0.1")]
		public string LogConfigFile = "logconfig.xml";

        [ConfigProperty("Port", "频道开放端口", 9208)]
		public int Port;

        public string RootDirectory;

        public string ScriptAssemblies;

        public string ScriptCompilationTarget;

        public string ServerName;

        [ConfigProperty("ZoneId", "服务器编号", 4)]
		public int ZoneId;

        public string Ip;

        protected override void Load(Type type)
        {
			if (Assembly.GetEntryAssembly() != null)
			{
				RootDirectory = new FileInfo(Assembly.GetEntryAssembly().Location).DirectoryName;
			}
			else
			{
				RootDirectory = new FileInfo(Assembly.GetAssembly(typeof(FightServer)).Location).DirectoryName;
			}
			base.Load(type);
        }

        public void LoadConfiguration()
        {
			Load(typeof(FightServerConfig));
        }

        public void Load()
        {
			LogConfigFile = ConfigurationSettings.AppSettings["Logconfig"];
			Ip = ConfigurationSettings.AppSettings["Ip"];
			ServerName = ConfigurationSettings.AppSettings["ServerName"];
			Port = int.Parse(ConfigurationSettings.AppSettings["Port"]);
			ScriptAssemblies = ConfigurationSettings.AppSettings["ScriptAssemblies"];
			ScriptCompilationTarget = ConfigurationSettings.AppSettings["ScriptAssemblies"];
			ZoneId = int.Parse(ConfigurationSettings.AppSettings["ServerID"]);
			RootDirectory = new FileInfo(Assembly.GetEntryAssembly().Location).DirectoryName;
        }
    }
}
