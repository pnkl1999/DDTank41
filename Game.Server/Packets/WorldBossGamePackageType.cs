using System;

namespace Game.Server.Packets
{
    [Flags]
    public enum WorldBossGamePackageType : byte
    {
        ENTER_WORLDBOSSROOM = 32,
        MOVE = 35,
        LEAVE_ROOM = 33,
        STAUTS = 36,
        ADDPLAYERS = 34,
        REQUEST_REVIVE = 37,
        BUFF_BUY = 38,
    }
}