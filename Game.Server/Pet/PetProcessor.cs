using Game.Base.Packets;

namespace Game.Server.Pet
{
    public class PetProcessor
    {
        private static object object_0;

        private IPetProcessor ipetProcessor_0;

        public PetProcessor(IPetProcessor processor)
        {
			ipetProcessor_0 = processor;
        }

        public void ProcessData(GamePlayer player, GSPacketIn data)
        {
			lock (object_0)
			{
				ipetProcessor_0.OnGameData(player, data);
			}
        }

        static PetProcessor()
        {
			object_0 = new object();
        }
    }
}
