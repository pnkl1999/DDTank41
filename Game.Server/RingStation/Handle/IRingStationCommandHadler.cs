using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.RingStation.Handle
{
    public interface IRingStationCommandHadler
    {
        bool CommandHandler(GamePlayer Player, GSPacketIn packet);
    }
}