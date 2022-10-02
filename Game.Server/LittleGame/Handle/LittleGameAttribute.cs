using System;

namespace Game.Server.LittleGame.Handle
{
    internal class LittleGameAttribute : Attribute
    {
        private byte byteCode;

        public LittleGameAttribute(byte byteCode)
        {
			this.byteCode = byteCode;
        }

        public byte GetByteCode()
        {
			return byteCode;
        }
    }
}
