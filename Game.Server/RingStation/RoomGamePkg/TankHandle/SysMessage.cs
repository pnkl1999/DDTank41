using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
    [GameCommandAttbute((int) GameCmdType.SYS_MESSAGE)]
    public class SysMessage : IGameCommandHandler
    {
        public bool HandleCommand(RingStationRoomLogicProcessor process, VirtualGamePlayer player, GSPacketIn packet)
        {
            return true;
        }
    }
}