using Game.Base.Packets;

namespace Game.Server.GameRoom
{
    public class GameRoomProcessor
    {
        private static object _syncStop = new object();

        private IGameRoomProcessor _processor;

        public GameRoomProcessor(IGameRoomProcessor processor)
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
