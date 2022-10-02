using Game.Base.Packets;

namespace Game.Server.HotSpringRooms
{
    public abstract class AbstractHotSpringProcessor : IHotSpringRoomsProcessor
    {
        public virtual void OnGameData(HotSpringRoom game, GamePlayer player, GSPacketIn packet)
        {
        }

        public virtual void OnTick(HotSpringRoom room)
        {
        }
    }
}
