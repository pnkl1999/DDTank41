using Game.Base.Packets;

namespace Game.Server.HotSpringRooms.TankHandle
{
    public interface IHotSpringCommandHandler
    {
        bool HandleCommand(TankHotSpringLogicProcessor process, GamePlayer player, GSPacketIn packet);
    }
}
