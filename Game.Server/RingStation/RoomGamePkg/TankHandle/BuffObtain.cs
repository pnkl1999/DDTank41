using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
    [GameCommandAttbute((int) GameCmdType.BUFF_OBTAIN)]
    public class BuffObtain : IGameCommandHandler
    {
        public bool HandleCommand(RingStationRoomLogicProcessor process, VirtualGamePlayer player, GSPacketIn packet)
        {
            return true;
        }
    }
}