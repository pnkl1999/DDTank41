using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.WorldBoss
{
    public class WorldBossProcessor
    {
        private static object _syncStop = new object();
        private IWorldBossProcessor _processor;

        public WorldBossProcessor(IWorldBossProcessor processor)
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