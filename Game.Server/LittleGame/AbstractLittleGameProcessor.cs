using Game.Base.Packets;

namespace Game.Server.LittleGame
{
    public abstract class AbstractLittleGameProcessor : ILittleGameProcessor
    {
        public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
        {
        }
    }
}
