using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.WorldBoss.Handle
{
    public interface IWorldBossCommandHandler
    {
        int CommandHandler(GamePlayer Player, GSPacketIn packet);
    }
}