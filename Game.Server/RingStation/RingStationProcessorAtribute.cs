using System;

namespace Game.Server.RingStation
{
    public class RingStationProcessorAtribute : Attribute
    {
        private byte _code;

        private string _descript;

        public RingStationProcessorAtribute(byte code, string description)
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