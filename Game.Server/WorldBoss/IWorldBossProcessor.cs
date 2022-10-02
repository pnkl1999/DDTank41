using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.WorldBoss
{
    public interface IWorldBossProcessor
    {
        void OnGameData(GamePlayer player, GSPacketIn packet);
    }
}