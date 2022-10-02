using Game.Base.Packets;

namespace Game.Server.GameRoom
{
    public abstract class AbstractGameRoomProcessor : IGameRoomProcessor
    {
        public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
        {
        }
    }
}
