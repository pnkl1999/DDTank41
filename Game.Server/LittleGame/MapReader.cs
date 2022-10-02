using System.IO;

namespace Game.Server.LittleGame
{
    public class MapReader
    {
        private MemoryStream ms;

        private BinaryReader br;

        public MapReader(byte[] data)
        {
			ms = new MemoryStream(data);
			br = new BinaryReader(ms);
        }

        public int ReadInt()
        {
			return br.ReadInt32();
        }

        public byte ReadByte()
        {
			return br.ReadByte();
        }
    }
}
