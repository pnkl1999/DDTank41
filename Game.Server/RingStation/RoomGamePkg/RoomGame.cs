using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg
{
    public class RoomGame
    {
        private IGameProcessor _processor;
        private static object _syncStop = new object();

        public RoomGame()
        {
            _processor = new RingStationRoomLogicProcessor();
        }

        protected void OnTick(object obj)
        {
            _processor.OnTick(this);
        }

        public void ProcessData(VirtualGamePlayer player, GSPacketIn data)
        {
            lock (_syncStop)
            {
                _processor.OnGameData(this, player, data);
            }
        }
    }
}