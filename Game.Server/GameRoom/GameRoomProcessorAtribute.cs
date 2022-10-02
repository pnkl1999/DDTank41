using System;

namespace Game.Server.GameRoom
{
    public class GameRoomProcessorAtribute : Attribute
    {
        private byte _code;

        private string _descript;

        public byte Code=> _code;

        public string Description=> _descript;

        public GameRoomProcessorAtribute(byte code, string description)
        {
			_code = code;
			_descript = description;
        }
    }
}
