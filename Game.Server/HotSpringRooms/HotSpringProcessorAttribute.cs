using System;

namespace Game.Server.HotSpringRooms
{
    public class HotSpringProcessorAttribute : Attribute
    {
        private byte _code;

        private string _descript;

        public byte Code=> _code;

        public string Description=> _descript;

        public HotSpringProcessorAttribute(byte code, string description)
        {
			_code = code;
			_descript = description;
        }
    }
}
