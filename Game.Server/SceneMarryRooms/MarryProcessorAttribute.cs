using System;

namespace Game.Server.SceneMarryRooms
{
    public class MarryProcessorAttribute : Attribute
    {
        private byte _code;

        private string _descript;

        public byte Code=> _code;

        public string Description=> _descript;

        public MarryProcessorAttribute(byte code, string description)
        {
			_code = code;
			_descript = description;
        }
    }
}
