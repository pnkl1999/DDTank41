using System;

namespace Game.Server.LittleGame
{
    public class LittleGameProcessorAttribute : Attribute
    {
        public byte Code { get; }

        public string Description { get; }

        public LittleGameProcessorAttribute(byte code, string description)
        {
			Code = code;
			Description = description;
        }
    }
}
