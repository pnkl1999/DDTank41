using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.RingStation
{
    public interface IRingStationProcessor
    {
        void OnGameData(GamePlayer player, GSPacketIn packet);
    }
}