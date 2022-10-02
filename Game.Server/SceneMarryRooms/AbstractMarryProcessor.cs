using Game.Base.Packets;

namespace Game.Server.SceneMarryRooms
{
    public abstract class AbstractMarryProcessor : IMarryProcessor
    {
        public virtual void OnGameData(MarryRoom game, GamePlayer player, GSPacketIn packet)
        {
        }

        public virtual void OnTick(MarryRoom room)
        {
        }
    }
}
