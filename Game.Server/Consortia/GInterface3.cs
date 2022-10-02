using Game.Base.Packets;

namespace Game.Server.Consortia
{
    public interface GInterface3
    {
        void OnGameData(GamePlayer player, GSPacketIn packet);
    }
}
