using log4net;
using System.Reflection;

namespace Game.Base.Packets
{
    public class GSPacketIn : PacketIn
    {
        public const ushort HDR_SIZE = 20;

        public const short HEADER = 29099;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected int m_cliendId;

        protected short m_code;

        protected int m_parameter1;

        protected int m_parameter2;

        public int ClientID
        {
			get
			{
				return m_cliendId;
			}
			set
			{
				m_cliendId = value;
			}
        }

        public short Code
        {
			get
			{
				return m_code;
			}
			set
			{
				m_code = value;
			}
        }

        public int Parameter1
        {
			get
			{
				return m_parameter1;
			}
			set
			{
				m_parameter1 = value;
			}
        }

        public int Parameter2
        {
			get
			{
				return m_parameter2;
			}
			set
			{
				m_parameter2 = value;
			}
        }

        public GSPacketIn(short code)
			: this(code, 0, 8192)
        {
        }

        public GSPacketIn(byte[] buf, int size)
			: base(buf, size)
        {
        }

        public GSPacketIn(short code, int clientId)
			: this(code, clientId, 8192)
        {
        }

        public GSPacketIn(short code, int clientId, int size)
			: base(new byte[size], 20)
        {
			m_code = code;
			m_cliendId = clientId;
			m_offset = 20;
        }

        public void ClearContext()
        {
			m_offset = 20;
			m_length = 20;
        }

        public void ClearOffset()
        {
			m_offset = 20;
        }

        public GSPacketIn Clone()
        {
			GSPacketIn gSPacketIn = new GSPacketIn(m_buffer, m_length);
			gSPacketIn.ReadHeader();
			gSPacketIn.Offset = m_length;
			return gSPacketIn;
        }

        public void Compress()
        {
			byte[] src = Marshal.Compress(m_buffer, 20, base.Length - 20);
			m_offset = 20;
			Write(src);
			m_length = src.Length + 20;
        }

        public short checkSum()
        {
			short num = 119;
			int num2 = 6;
			while (num2 < m_length)
			{
				try
				{
					num = (short)(num + m_buffer[num2++]);
				}
				catch
				{
				}
			}
			return (short)(num & 0x7F7F);
        }

        public void ReadHeader()
        {
			ReadShort();
			m_length = ReadShort();
			ReadShort();
			m_code = ReadShort();
			m_cliendId = ReadInt();
			m_parameter1 = ReadInt();
			m_parameter2 = ReadInt();
        }

        public GSPacketIn ReadPacket()
        {
			byte[] array = ReadBytes();
			GSPacketIn gSPacketIn = new GSPacketIn(array, array.Length);
			gSPacketIn.ReadHeader();
			return gSPacketIn;
        }

        public void UnCompress()
        {
        }

        public void WriteHeader()
        {
			lock (this)
			{
				int offset = m_offset;
				m_offset = 0;
				base.WriteShort(29099);
				base.WriteShort((short)m_length);
				base.WriteShort(checkSum());
				base.WriteShort(m_code);
				base.WriteInt(m_cliendId);
				base.WriteInt(m_parameter1);
				base.WriteInt(m_parameter2);
				m_offset = offset;
			}
			lock (this)
			{
				int num2 = m_offset;
				m_offset = 0;
				base.WriteShort(29099);
				base.WriteShort((short)m_length);
				base.WriteShort(checkSum());
				base.WriteShort(m_code);
				base.WriteInt(m_cliendId);
				base.WriteInt(m_parameter1);
				base.WriteInt(m_parameter2);
				m_offset = num2;
			}
        }

        public void WriteHeader3()
        {
			lock (this)
			{
				int offset = m_offset;
				m_offset = 0;
				WriteShort(29099);
				WriteShort((short)m_length);
				m_offset = 6;
				WriteShort(m_code);
				WriteInt(m_cliendId);
				WriteInt(m_parameter1);
				WriteInt(m_parameter2);
				m_offset = 4;
				WriteShort(checkSum());
				m_offset = offset;
			}
        }

        public void WritePacket(GSPacketIn pkg)
        {
			pkg.WriteHeader();
			Write(pkg.Buffer, 0, pkg.Length);
        }
    }
}
