using System;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
    public class GameCommandAttbute : Attribute
    {
        public GameCommandAttbute(byte code)
        {
            Code = code;
        }

        public byte Code { get; private set; }
    }
}