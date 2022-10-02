using Game.Base.Packets;

namespace Game.Server.Farm
{
    public interface IFarmProcessor
    {
        void OnGameData(GamePlayer player, GSPacketIn packet);
    }
}
