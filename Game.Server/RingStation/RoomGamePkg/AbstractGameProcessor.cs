using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg
{
    public abstract class AbstractGameProcessor : IGameProcessor
    {
        protected AbstractGameProcessor()
        {
        }

        public virtual void OnGameData(RoomGame game, VirtualGamePlayer player, GSPacketIn packet)
        {
        }

        public virtual void OnTick(RoomGame room)
        {
        }
    }
}