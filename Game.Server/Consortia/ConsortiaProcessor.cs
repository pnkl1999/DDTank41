using Game.Base.Packets;

namespace Game.Server.Consortia
{
    public class ConsortiaProcessor
    {
        private static object object_0;

        private GInterface3 ginterface3_0;

        public ConsortiaProcessor(GInterface3 processor)
        {
			ginterface3_0 = processor;
        }

        public void ProcessData(GamePlayer player, GSPacketIn data)
        {
			lock (object_0)
			{
				ginterface3_0.OnGameData(player, data);
			}
        }

        static ConsortiaProcessor()
        {
			object_0 = new object();
        }
    }
}
