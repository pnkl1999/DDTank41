using System;

namespace Game.Server.SceneMarryRooms.TankHandle
{
    public class MarryCommandAttbute : Attribute
    {
        public byte Code { get; private set; }

        public MarryCommandAttbute(byte code)
        {
			Code = code;
        }
    }
}
