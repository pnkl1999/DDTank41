using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.RingStation
{
    public abstract class AbstractRingStationProcessor : IRingStationProcessor
    {
        public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
        {
        }
    }
}