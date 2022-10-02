using System;

namespace Game.Server.Consortia
{
    public class ConsortiaProcessorAtribute : Attribute
    {
        private byte byte_0;

        private string string_0;

        public byte Code=> byte_0;

        public string Description=> string_0;

        public ConsortiaProcessorAtribute(byte code, string description)
        {
			byte_0 = code;
			string_0 = description;
        }
    }
}
