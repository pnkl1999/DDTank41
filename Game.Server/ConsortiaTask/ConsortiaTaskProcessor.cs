using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ConsortiaTask
{
    public class ConsortiaTaskProcessor
    {
        private static object locker = new object();
        private IConsortiaTaskProcessor Processor;

        public ConsortiaTaskProcessor(IConsortiaTaskProcessor processor)
        {
            Processor = processor;
        }

        public void ProcessData(GamePlayer player, GSPacketIn data)
        {
            lock (locker)
            {
                this.Processor.OnGameData(player, data);
            }
        }
    }
}
