using System;

namespace Game.Server.Packets.Client
{
    [AttributeUsage(AttributeTargets.Class)]
	public class PacketHandlerAttribute : Attribute
    {
        protected int m_code;

        protected string m_desc;

        public int Code=> m_code;

        public string Description=> m_desc;

        public PacketHandlerAttribute(int code, string desc)
        {
			m_code = code;
			m_desc = desc;
        }
    }
}
