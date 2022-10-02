using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.RingStation
{
    public class RingStationProcessor
    {
        private static object _syncStop = new object();
        private IRingStationProcessor _processor;

        public RingStationProcessor(IRingStationProcessor processor)
        {
            _processor = processor;
        }

        public void ProcessData(GamePlayer player, GSPacketIn data)
        {
            lock (_syncStop)
            {
                _processor.OnGameData(player, data);
            }
        }
    }
}