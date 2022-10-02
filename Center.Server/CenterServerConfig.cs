using Game.Base.Config;
using log4net;
using System;
using System.IO;
using System.Reflection;

namespace Center.Server
{
    public class CenterServerConfig : BaseAppConfig
    {
        [ConfigProperty("IP", "中心服务器监听IP", "127.0.0.1")]
		public string Ip;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        [ConfigProperty("LogConfigFile", "日志配置文件", "logconfig.xml")]
		public string LogConfigFile;

        [ConfigProperty("LoginLapseInterval", "登陆超时时间,分钟为单位", 1)]
		public int LoginLapseInterval;

        [ConfigProperty("Port", "中心服务器监听端口", 9202)]
		public int Port;

        public string RootDirectory;

        [ConfigProperty("SaveInterval", "数据保存周期,分钟为单位", 1)]
		public int SaveIntervalInterval;

        [ConfigProperty("SaveRecordInterval", "日志保存周期,分钟为单位", 1)]
		public int SaveRecordInterval;

        [ConfigProperty("ScanAuctionInterval", "排名行扫描周期,分钟为单位", 60)]
		public int ScanAuctionInterval;

        [ConfigProperty("ScanConsortiaInterval", "工会扫描周期,以分钟为单位", 60)]
		public int ScanConsortiaInterval;

        [ConfigProperty("ScanMailInterval", "邮件扫描周期,分钟为单位", 60)]
		public int ScanMailInterval;

        [ConfigProperty("ScriptAssemblies", "脚本编译引用库", "")]
		public string ScriptAssemblies;

        [ConfigProperty("ScriptCompilationTarget", "脚本编译目标名称", "")]
		public string ScriptCompilationTarget;

        [ConfigProperty("SystemNoticeInterval", "登陆超时时间,分钟为单位", 2)]
		public int SystemNoticeInterval;

        public CenterServerConfig()
        {
			Load(typeof(CenterServerConfig));
        }

        protected override void Load(Type type)
        {
			if (Assembly.GetEntryAssembly() != null)
			{
				RootDirectory = new FileInfo(Assembly.GetEntryAssembly().Location).DirectoryName;
			}
			else
			{
				RootDirectory = new FileInfo(Assembly.GetAssembly(type).Location).DirectoryName;
			}
			base.Load(type);
        }

        public void Refresh()
        {
			Load(typeof(CenterServerConfig));
        }
    }
}
