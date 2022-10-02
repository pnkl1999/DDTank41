using Game.Base.Packets;

namespace Game.Server.SceneMarryRooms.TankHandle
{
    public interface IMarryCommandHandler
    {
        bool HandleCommand(TankMarryLogicProcessor process, GamePlayer player, GSPacketIn packet);
    }
}
