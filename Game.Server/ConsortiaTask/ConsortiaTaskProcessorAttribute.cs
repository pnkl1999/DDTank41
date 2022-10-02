using System;

namespace Game.Server.ConsortiaTask
{
    public class ConsortiaTaskProcessorAttribute : Attribute
    {
        public byte Code { get; }

        public string Description { get; }

        public ConsortiaTaskProcessorAttribute(byte code, string description)
        {
            Code = code;
            Description = description;
        }
    }
}
