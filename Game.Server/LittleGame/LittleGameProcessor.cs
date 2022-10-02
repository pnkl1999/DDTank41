using Game.Base.Packets;

namespace Game.Server.LittleGame
{
    public class LittleGameProcessor
    {
        private static object locker = new object();

        private ILittleGameProcessor iLittleGameProccesor;

        public LittleGameProcessor(ILittleGameProcessor processor)
        {
			iLittleGameProccesor = processor;
        }

        public void ProcessData(GamePlayer player, GSPacketIn data)
        {
			lock (locker)
			{
				iLittleGameProccesor.OnGameData(player, data);
			}
        }
    }
}
