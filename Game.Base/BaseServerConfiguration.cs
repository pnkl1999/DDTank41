using Game.Base.Config;
using System;
using System.IO;
using System.Net;

namespace Game.Base
{
    public class BaseServerConfiguration
    {
        protected IPAddress _ip = IPAddress.Any;

        protected ushort _port = 7000;

        public IPAddress Ip
        {
			get
			{
				return _ip;
			}
			set
			{
				_ip = value;
			}
        }

        public ushort Port
        {
			get
			{
				return _port;
			}
			set
			{
				_port = value;
			}
        }

        protected virtual void LoadFromConfig(ConfigElement root)
        {
			string ipString = root["Server"]["IP"].GetString("any");
			if (ipString == "any")
			{
				_ip = IPAddress.Any;
			}
			else
			{
				_ip = IPAddress.Parse(ipString);
			}
			_port = (ushort)root["Server"]["Port"].GetInt(_port);
        }

        public void LoadFromXMLFile(FileInfo configFile)
        {
			XMLConfigFile root = XMLConfigFile.ParseXMLFile(configFile);
			LoadFromConfig(root);
        }

        protected virtual void SaveToConfig(ConfigElement root)
        {
			root["Server"]["Port"].Set(_port);
			root["Server"]["IP"].Set(_ip);
        }

        public void SaveToXMLFile(FileInfo configFile)
        {
			if (configFile == null)
			{
				throw new ArgumentNullException("configFile");
			}
			XMLConfigFile root = new XMLConfigFile();
			SaveToConfig(root);
			root.Save(configFile);
        }
    }
}
