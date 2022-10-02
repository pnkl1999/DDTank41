using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.WorldBoss
{
    public abstract class AbstractWorldBossProcessor : IWorldBossProcessor
    {
        public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
        {
        }
    }
}