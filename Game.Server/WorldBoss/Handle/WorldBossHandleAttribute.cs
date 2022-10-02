using System;

namespace Game.Server.WorldBoss.Handle
{
    public class WorldBossHandleAttribute : Attribute
    {
        public byte Code { get; }

        public WorldBossHandleAttribute(byte code)
        {
            Code = code;
        }
    }
}