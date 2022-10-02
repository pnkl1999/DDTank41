using System;

namespace Game.Server.Consortia.Handle
{
    class ConsortiaHandleAttbute : Attribute
    {
        public byte Code { get; private set; }

        public ConsortiaHandleAttbute(byte code)
        {
            Code = code;
        }
    }
}