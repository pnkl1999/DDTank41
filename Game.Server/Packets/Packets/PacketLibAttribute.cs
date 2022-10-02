using System;

namespace Game.Base.Packets
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true, Inherited = false)]
	public class PacketLibAttribute : Attribute
    {
        private int m_rawVersion;

        public int RawVersion=> m_rawVersion;

        public PacketLibAttribute(int rawVersion)
        {
			m_rawVersion = rawVersion;
        }
    }
}
