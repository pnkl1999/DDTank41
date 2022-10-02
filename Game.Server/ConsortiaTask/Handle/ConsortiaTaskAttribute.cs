using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Game.Server.ConsortiaTask.Handle
{
    public class ConsortiaTaskAttribute : Attribute
    {
        private byte byteCode;

        public ConsortiaTaskAttribute(byte byteCode)
        {
            this.byteCode = byteCode;
        }

        public byte GetByteCode()
        {
            return this.byteCode;
        }
    }
}
