using ProtoBuf;
using System;
using System.IO;
using System.Text;
using zlib;

namespace Game.Base
{
    public class Marshal
    {
        public static byte[] Compress(byte[] src)
        {
			return Compress(src, 0, src.Length);
        }

        public static byte[] Compress(byte[] src, int offset, int length)
        {
			MemoryStream memoryStream = new MemoryStream();
			ZOutputStream zOutputStream = new ZOutputStream(memoryStream, 9);
			zOutputStream.Write(src, offset, length);
			zOutputStream.Close();
			return memoryStream.ToArray();
        }

        public static short ConvertToInt16(byte[] val)
        {
			return ConvertToInt16(val, 0);
        }

        public static short ConvertToInt16(byte v1, byte v2)
        {
			return (short)((v1 << 8) | v2);
        }

        public static short ConvertToInt16(byte[] val, int startIndex)
        {
			return ConvertToInt16(val[startIndex], val[startIndex + 1]);
        }

        public static int ConvertToInt32(byte[] val)
        {
			return ConvertToInt32(val, 0);
        }

        public static int ConvertToInt32(byte[] val, int startIndex)
        {
			return ConvertToInt32(val[startIndex], val[startIndex + 1], val[startIndex + 2], val[startIndex + 3]);
        }

        public static int ConvertToInt32(byte v1, byte v2, byte v3, byte v4)
        {
			return (v1 << 24) | (v2 << 16) | (v3 << 8) | v4;
        }

        public static long ConvertToInt64(int v1, uint v2)
        {
			int num = 1;
			if (v1 < 0)
			{
				num = -1;
			}
			return (long)((double)num * (Math.Abs((double)v1 * Math.Pow(2.0, 32.0)) + (double)v2));
        }

        public static string ConvertToString(byte[] cstyle)
        {
			if (cstyle == null)
			{
				return null;
			}
			for (int i = 0; i < cstyle.Length; i++)
			{
				if (cstyle[i] == 0)
				{
					return Encoding.Default.GetString(cstyle, 0, i);
				}
			}
			return Encoding.Default.GetString(cstyle);
        }

        public static ushort ConvertToUInt16(byte[] val)
        {
			return ConvertToUInt16(val, 0);
        }

        public static ushort ConvertToUInt16(byte v1, byte v2)
        {
			return (ushort)(v2 | (v1 << 8));
        }

        public static ushort ConvertToUInt16(byte[] val, int startIndex)
        {
			return ConvertToUInt16(val[startIndex], val[startIndex + 1]);
        }

        public static uint ConvertToUInt32(byte[] val)
        {
			return ConvertToUInt32(val, 0);
        }

        public static uint ConvertToUInt32(byte[] val, int startIndex)
        {
			return ConvertToUInt32(val[startIndex], val[startIndex + 1], val[startIndex + 2], val[startIndex + 3]);
        }

        public static uint ConvertToUInt32(byte v1, byte v2, byte v3, byte v4)
        {
			return (uint)((v1 << 24) | (v2 << 16) | (v3 << 8) | v4);
        }

        public static string ToHexDump(string description, byte[] dump)
        {
			return ToHexDump(description, dump, 0, dump.Length);
        }

        public static string ToHexDump(string description, byte[] dump, int start, int count)
        {
			StringBuilder builder = new StringBuilder();
			if (description != null)
			{
				builder.Append(description).Append("\n");
			}
			int num = start + count;
			for (int i = start; i < num; i += 16)
			{
				StringBuilder builder2 = new StringBuilder();
				StringBuilder builder3 = new StringBuilder();
				builder3.Append(i.ToString("X4"));
				builder3.Append(": ");
				for (int j = 0; j < 16; j++)
				{
					if (j + i < num)
					{
						byte num2 = dump[j + i];
						builder3.Append(dump[j + i].ToString("X2"));
						builder3.Append(" ");
						if (num2 >= 32 && num2 <= 127)
						{
							builder2.Append((char)num2);
						}
						else
						{
							builder2.Append(".");
						}
					}
					else
					{
						builder3.Append("   ");
						builder2.Append(" ");
					}
				}
				builder3.Append("  ");
				builder3.Append(builder2.ToString());
				builder3.Append('\n');
				builder.Append(builder3.ToString());
			}
			return builder.ToString();
        }

        public static byte[] Uncompress(byte[] src)
        {
			MemoryStream memoryStream = new MemoryStream();
			ZOutputStream zOutputStream = new ZOutputStream(memoryStream);
			zOutputStream.Write(src, 0, src.Length);
			zOutputStream.Close();
			return memoryStream.ToArray();
        }

        public static T LoadDataFile<T>(string filename, bool isEncrypt)
        {
			if (!File.Exists("datas/" + filename + ".data"))
			{
				return default(T);
			}
			try
			{
				byte[] numArray = File.ReadAllBytes("datas/" + filename + ".data");
				if (isEncrypt)
				{
					numArray = Uncompress(numArray);
				}
				MemoryStream obj2 = new MemoryStream(numArray)
				{
					Position = 0L
				};
				T obj = Serializer.Deserialize<T>(obj2);
				obj2.Dispose();
				return obj;
			}
			catch (Exception ex)
			{
				Console.WriteLine("Data " + filename + " is error!" + ex);
			}
			return default(T);
        }

        public static bool SaveDataFile<T>(T instance, string filename, bool isEncrypt)
        {
			try
			{
				byte[] numArray;
				if (instance == null)
				{
					numArray = new byte[0];
				}
				else
				{
					MemoryStream memoryStream = new MemoryStream();
					Serializer.Serialize(memoryStream, instance);
					numArray = new byte[memoryStream.Length];
					memoryStream.Position = 0L;
					memoryStream.Read(numArray, 0, numArray.Length);
					memoryStream.Dispose();
				}
				if (isEncrypt)
				{
					numArray = Compress(numArray);
				}
				File.WriteAllBytes("datas/" + filename + ".data", numArray);
				return true;
			}
			catch (Exception value)
			{
				Console.WriteLine(value);
			}
			return false;
        }
    }
}
