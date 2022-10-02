using Game.Base.Packets;

namespace Game.Server.GameRoom
{
    public interface IGameRoomProcessor
    {
        void OnGameData(GamePlayer player, GSPacketIn packet);
    }
}
