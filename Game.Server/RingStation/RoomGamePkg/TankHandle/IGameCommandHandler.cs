using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
    public interface IGameCommandHandler
    {
        bool HandleCommand(RingStationRoomLogicProcessor process, VirtualGamePlayer player, GSPacketIn packet);
    }
}