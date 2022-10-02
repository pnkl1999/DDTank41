using log4net;
using System;
using System.Configuration;
using System.Reflection;

namespace Game.Base.Config
{
    public abstract class BaseAppConfig
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected virtual void Load(Type type)
        {
			ConfigurationManager.RefreshSection("appSettings");
			FieldInfo[] fields = type.GetFields();
			FieldInfo[] array = fields;
			foreach (FieldInfo info in array)
			{
				object[] customAttributes = info.GetCustomAttributes(typeof(ConfigPropertyAttribute), inherit: false);
				if (customAttributes.Length != 0)
				{
					ConfigPropertyAttribute attrib = (ConfigPropertyAttribute)customAttributes[0];
					info.SetValue(this, LoadConfigProperty(attrib));
				}
			}
        }

        private object LoadConfigProperty(ConfigPropertyAttribute attrib)
        {
			string key = attrib.Key;
			string str2 = ConfigurationManager.AppSettings[key];
			if (str2 == null)
			{
				str2 = attrib.DefaultValue.ToString();
				log.Warn("Loading " + key + " value is null,using default vaule:" + str2);
			}
			else
			{
				log.Debug("Loading " + key + " Value is " + str2);
			}
			try
			{
				return Convert.ChangeType(str2, attrib.DefaultValue.GetType());
			}
			catch (Exception exception)
			{
				log.Error("Exception in ServerProperties Load: ", exception);
				return null;
			}
        }
    }
}
