using Game.Base.Packets;

namespace Game.Server.Farm
{
    public class FarmProcessor
    {
        private static object _syncStop = new object();

        private IFarmProcessor _processor;

        public FarmProcessor(IFarmProcessor processor)
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
