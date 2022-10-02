using System;

namespace Game.Server.Farm.Handle
{
    internal class FarmHandleAttbute : Attribute
    {
        public byte Code { get; private set; }

        public FarmHandleAttbute(byte code)
        {
			Code = code;
        }
    }
}
