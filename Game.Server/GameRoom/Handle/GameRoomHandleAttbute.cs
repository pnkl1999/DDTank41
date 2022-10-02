using System;

namespace Game.Server.GameRoom.Handle
{
    internal class GameRoomHandleAttbute : Attribute
    {
        public byte Code { get; private set; }

        public GameRoomHandleAttbute(byte code)
        {
			Code = code;
        }
    }
}
