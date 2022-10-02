using System;
using System.Text;
using System.Threading;

namespace Game.Base
{
    public class PacketIn
    {
        public volatile bool isSended = true;

        private byte lastbits;

        protected byte[] m_buffer;

        protected byte[] m_buffer2;

        protected int m_length;

        public volatile int m_loop;

        protected int m_offset;

        public volatile int m_sended;

        public volatile int packetNum;

        public byte[] Buffer=> m_buffer;

        public int DataLeft=> m_length - m_offset;

        public int Length=> m_length;

        public int Offset
        {
			get
			{
				return m_offset;
			}
			set
			{
				m_offset = value;
			}
        }

        public PacketIn(byte[] buf, int len)
        {
			m_buffer = buf;
			m_length = len;
			m_offset = 0;
        }

        public virtual int CopyFrom(byte[] src, int srcOffset, int offset, int count)
        {
			if (count < m_buffer.Length && count - srcOffset < src.Length)
			{
				System.Buffer.BlockCopy(src, srcOffset, m_buffer, offset, count);
				return count;
			}
			return -1;
        }

        public virtual int CopyFrom(byte[] src, int srcOffset, int offset, int count, int key)
        {
			if (count >= m_buffer.Length || count - srcOffset >= src.Length)
			{
				return -1;
			}
			key = (key & 0xFF0000) >> 16;
			for (int i = 0; i < count; i++)
			{
				m_buffer[offset + i] = (byte)(src[srcOffset + i] ^ key);
			}
			return count;
        }

        public virtual int[] CopyFrom3(byte[] src, int srcOffset, int offset, int count, byte[] key)
        {
			int[] numArray = new int[count];
			for (int i = 0; i < count; i++)
			{
				m_buffer[i] = src[i];
			}
			if (count < m_buffer.Length && count - srcOffset < src.Length)
			{
				m_buffer[0] = (byte)(src[srcOffset] ^ key[0]);
				for (int j = 1; j < count; j++)
				{
					key[j % 8] = (byte)((key[j % 8] + src[srcOffset + j - 1]) ^ j);
					m_buffer[j] = (byte)((src[srcOffset + j] - src[srcOffset + j - 1]) ^ key[j % 8]);
				}
			}
			return numArray;
        }

        public virtual int CopyTo(byte[] dst, int dstOffset, int offset)
        {
			int count = ((m_length - offset < dst.Length - dstOffset) ? (m_length - offset) : (dst.Length - dstOffset));
			if (count > 0)
			{
				System.Buffer.BlockCopy(m_buffer, offset, dst, dstOffset, count);
			}
			return count;
        }

        public virtual int CopyTo(byte[] dst, int dstOffset, int offset, byte[] key)
        {
			int num = ((m_length - offset < dst.Length - dstOffset) ? (m_length - offset) : (dst.Length - dstOffset));
			if (num > 0)
			{
				for (int i = 0; i < num; i++)
				{
					if (offset + i == 0)
					{
						dst[dstOffset] = (byte)(m_buffer[offset + i] ^ key[(offset + i) % 8]);
						continue;
					}
					if (i == 0 && dstOffset == 0)
					{
						key[(offset + i) % 8] = (byte)((key[(offset + i) % 8] + lastbits) ^ (offset + i));
						dst[dstOffset + i] = (byte)((m_buffer[offset + i] ^ key[(offset + i) % 8]) + lastbits);
						continue;
					}
					key[(offset + i) % 8] = (byte)((key[(offset + i) % 8] + dst[dstOffset + i - 1]) ^ (offset + i));
					dst[dstOffset + i] = (byte)((m_buffer[offset + i] ^ key[(offset + i) % 8]) + dst[dstOffset + i - 1]);
					if (i == num - 1)
					{
						lastbits = dst[dstOffset + i];
					}
				}
			}
			return num;
        }

        public virtual int CopyTo3(byte[] dst, int dstOffset, int offset, byte[] key, ref int packetArrangeSend)
        {
			int num = ((m_length - offset < dst.Length - dstOffset) ? (m_length - offset) : (dst.Length - dstOffset));
			lock (this)
			{
				if (num > 0)
				{
					int num2;
					if (isSended)
					{
						packetNum = Interlocked.Increment(ref packetArrangeSend);
						packetArrangeSend = packetNum;
						m_sended = 0;
						isSended = false;
						num2 = m_sended + dstOffset;
					}
					else
					{
						num2 = 8192;
					}
					if (packetNum != packetArrangeSend)
					{
						return 0;
					}
					for (int i = 0; i < num; i++)
					{
						int index = offset + i;
						while (num2 > 8192)
						{
							num2 -= 8192;
						}
						if (m_sended == 0)
						{
							dst[dstOffset] = (byte)(m_buffer[index] ^ key[m_sended % 8]);
						}
						else
						{
							if (num2 == 0)
							{
								return 0;
							}
							key[m_sended % 8] = (byte)((key[m_sended % 8] + dst[num2 - 1]) ^ m_sended);
							dst[dstOffset + i] = (byte)((m_buffer[index] ^ key[m_sended % 8]) + dst[num2 - 1]);
						}
						m_sended++;
						num2++;
					}
				}
				return num;
			}
        }

        public virtual void Fill(byte val, int num)
        {
			for (int i = 0; i < num; i++)
			{
				WriteByte(val);
			}
        }

        public virtual bool ReadBoolean()
        {
			return m_buffer[m_offset++] != 0;
        }

        public virtual byte ReadByte()
        {
			return m_buffer[m_offset++];
        }

        public virtual byte[] ReadBytes()
        {
			return ReadBytes(m_length - m_offset);
        }

        public virtual byte[] ReadBytes(int maxLen)
        {
			byte[] destinationArray = new byte[maxLen];
			Array.Copy(m_buffer, m_offset, destinationArray, 0, maxLen);
			m_offset += maxLen;
			return destinationArray;
        }

        public DateTime ReadDateTime()
        {
			return new DateTime(ReadShort(), ReadByte(), ReadByte(), ReadByte(), ReadByte(), ReadByte());
        }

        public virtual double ReadDouble()
        {
			byte[] buffer = new byte[8];
			for (int i = 0; i < buffer.Length; i++)
			{
				buffer[i] = ReadByte();
			}
			return BitConverter.ToDouble(buffer, 0);
        }

        public virtual float ReadFloat()
        {
			byte[] buffer = new byte[4];
			for (int i = 0; i < buffer.Length; i++)
			{
				buffer[i] = ReadByte();
			}
			return BitConverter.ToSingle(buffer, 0);
        }

        public virtual int ReadInt()
        {
			byte v = ReadByte();
			byte num2 = ReadByte();
			byte num3 = ReadByte();
			byte num4 = ReadByte();
			return Marshal.ConvertToInt32(v, num2, num3, num4);
        }

        public virtual long ReadLong()
        {
			int num = ReadInt();
			long num2 = readUnsignedInt();
			int num3 = 1;
			if (num < 0)
			{
				num3 = -1;
			}
			return (long)((double)num3 * (Math.Abs((double)num * Math.Pow(2.0, 32.0)) + (double)num2));
        }

        public virtual short ReadShort()
        {
			byte v = ReadByte();
			byte num2 = ReadByte();
			return Marshal.ConvertToInt16(v, num2);
        }

        public virtual short ReadShortLowEndian()
        {
			byte num = ReadByte();
			return Marshal.ConvertToInt16(ReadByte(), num);
        }

        public virtual string ReadString()
        {
			short count = ReadShort();
			string @string = Encoding.UTF8.GetString(m_buffer, m_offset, count);
			m_offset += count;
			return @string.Replace("\0", "");
        }

        public virtual uint ReadUInt()
        {
			byte v = ReadByte();
			byte num2 = ReadByte();
			byte num3 = ReadByte();
			byte num4 = ReadByte();
			return Marshal.ConvertToUInt32(v, num2, num3, num4);
        }

        public virtual long readUnsignedInt()
        {
			return ReadInt() & 0xFFFFFFFFu;
        }

        public void Skip(int num)
        {
			m_offset += num;
        }

        public virtual void vmethod_0(uint val)
        {
			WriteByte((byte)(val >> 24));
			WriteByte((byte)((val >> 16) & 0xFFu));
			WriteByte((byte)((val & 0xFFFF) >> 8));
			WriteByte((byte)(val & 0xFFFFu & 0xFFu));
        }

        public virtual void Write(byte[] src)
        {
			Write(src, 0, src.Length);
        }

        public virtual void Write(byte[] src, int offset, int len)
        {
			if (m_offset + len >= m_buffer.Length)
			{
				byte[] sourceArray = m_buffer;
				m_buffer = new byte[m_buffer.Length * 2];
				Array.Copy(sourceArray, m_buffer, sourceArray.Length);
				Write(src, offset, len);
			}
			else
			{
				Array.Copy(src, offset, m_buffer, m_offset, len);
				m_offset += len;
				m_length = ((m_offset > m_length) ? m_offset : m_length);
			}
        }

        public virtual void Write3(byte[] src, int offset, int len)
        {
			Array.Copy(src, offset, m_buffer, m_offset, len);
			m_offset += len;
			m_length = ((m_offset > m_length) ? m_offset : m_length);
        }

        public virtual void WriteBoolean(bool val)
        {
			if (m_offset == m_buffer.Length)
			{
				byte[] sourceArray = m_buffer;
				m_buffer = new byte[m_buffer.Length * 2];
				Array.Copy(sourceArray, m_buffer, sourceArray.Length);
			}
			m_buffer[m_offset++] = (byte)(val ? 1u : 0u);
			m_length = ((m_offset > m_length) ? m_offset : m_length);
        }

        public virtual void WriteByte(byte val)
        {
			if (m_offset == m_buffer.Length)
			{
				byte[] sourceArray = m_buffer;
				m_buffer = new byte[m_buffer.Length * 2];
				Array.Copy(sourceArray, m_buffer, sourceArray.Length);
			}
			m_buffer[m_offset++] = val;
			m_length = ((m_offset > m_length) ? m_offset : m_length);
        }

        public void WriteDateTime(DateTime date)
        {
			WriteShort((short)date.Year);
			WriteByte((byte)date.Month);
			WriteByte((byte)date.Day);
			WriteByte((byte)date.Hour);
			WriteByte((byte)date.Minute);
			WriteByte((byte)date.Second);
        }

        public virtual void WriteDouble(double val)
        {
			byte[] bytes = BitConverter.GetBytes(val);
			Write(bytes);
        }

        public virtual void WriteFloat(float val)
        {
			byte[] bytes = BitConverter.GetBytes(val);
			Write(bytes);
        }

        public virtual void WriteInt(int val)
        {
			WriteByte((byte)(val >> 24));
			WriteByte((byte)((uint)(val >> 16) & 0xFFu));
			WriteByte((byte)((val & 0xFFFF) >> 8));
			WriteByte((byte)((uint)val & 0xFFFFu & 0xFFu));
        }

        public virtual void WriteLong(long val)
        {
			int num2 = (int)val;
			string str = Convert.ToString(val, 2);
			string str2 = ((str.Length <= 32) ? "" : str.Substring(0, str.Length - 32));
			int num3 = 0;
			for (int i = 0; i < str2.Length; i++)
			{
				string str3 = str2.Substring(str2.Length - (i + 1));
				if (str3 != "0")
				{
					if (!(str3 == "1"))
					{
						break;
					}
					num3 += 1 << i;
				}
			}
			WriteInt(num3);
			WriteInt(num2);
        }

        public virtual void WriteShort(short val)
        {
			WriteByte((byte)(val >> 8));
			WriteByte((byte)((uint)val & 0xFFu));
        }

        public virtual void WriteShortLowEndian(short val)
        {
			WriteByte((byte)((uint)val & 0xFFu));
			WriteByte((byte)(val >> 8));
        }

        public virtual void WriteString(string str)
        {
			if (!string.IsNullOrEmpty(str))
			{
				byte[] bytes = Encoding.UTF8.GetBytes(str);
				WriteShort((short)(bytes.Length + 1));
				Write(bytes, 0, bytes.Length);
				WriteByte(0);
			}
			else
			{
				WriteShort(1);
				WriteByte(0);
			}
        }

        public virtual void WriteString(string str, int maxlen)
        {
			byte[] bytes = Encoding.UTF8.GetBytes(str);
			int len = ((bytes.Length < maxlen) ? bytes.Length : maxlen);
			WriteShort((short)len);
			Write(bytes, 0, len);
        }
    }
}
