using System;

namespace Game.Base.Config
{
    [AttributeUsage(AttributeTargets.Field, AllowMultiple = false)]
	public class ConfigPropertyAttribute : Attribute
    {
        private object m_defaultValue;

        private string m_description;

        private string m_key;

        public object DefaultValue=> m_defaultValue;

        public string Description=> m_description;

        public string Key=> m_key;

        public ConfigPropertyAttribute(string key, string description, object defaultValue)
        {
			m_key = key;
			m_description = description;
			m_defaultValue = defaultValue;
        }
    }
}
