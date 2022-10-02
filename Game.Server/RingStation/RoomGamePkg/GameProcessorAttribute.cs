using System;

namespace Game.Server.RingStation.RoomGamePkg
{
    public class GameProcessorAttribute : Attribute
    {
        private byte _code;
        private string _descript;

        public GameProcessorAttribute(byte code, string description)
        {
            _code = code;
            _descript = description;
        }

        public byte Code
        {
            get { return _code; }
        }

        public string Description
        {
            get { return _descript; }
        }
    }
}