using Game.Base.Packets;

namespace Game.Server.Pet
{
    public interface IPetProcessor
    {
        void OnGameData(GamePlayer player, GSPacketIn packet);
    }
}
