using System;

namespace Game.Server.RingStation.Handle
{
    class RingStationHandleAttbute : Attribute
    {
        public byte Code { get; private set; }

        public RingStationHandleAttbute(byte code)
        {
            Code = code;
        }
    }
}