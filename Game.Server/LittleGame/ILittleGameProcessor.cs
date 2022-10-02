using Game.Base.Packets;

namespace Game.Server.LittleGame
{
    public interface ILittleGameProcessor
    {
        void OnGameData(GamePlayer player, GSPacketIn packet);
    }
}
