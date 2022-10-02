using System;
using System.Runtime.CompilerServices;

namespace Game.Server.HotSpringRooms.TankHandle
{
    public class HotSpringCommandAttbute : Attribute
    {
        public byte Code { get; private set; }

        public HotSpringCommandAttbute(byte code) => this.Code = code;
    }
}
