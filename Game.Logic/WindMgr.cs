using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Reflection;
using System.Threading;

namespace Game.Logic
{
    public class WindMgr
    {
        private static Dictionary<int, WindInfo> _winds;

        private static readonly Color[] c = new Color[8]
		{
			Color.Yellow,
			Color.Red,
			Color.Blue,
			Color.Green,
			Color.Orange,
			Color.Aqua,
			Color.DarkCyan,
			Color.Purple
		};

        private static readonly int[] CategoryID = new int[9]
		{
			1001,
			1002,
			1003,
			1004,
			1005,
			1005,
			1007,
			1008,
			1009
		};

        private static readonly string[] font = new string[1]
		{
			"Arial"
		};

        private static readonly string[] fontWind = new string[11]
		{
			"•",
			"1",
			"2",
			"3",
			"4",
			"5",
			"6",
			"7",
			"8",
			"9",
			"0"
		};

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock;

        private static ThreadSafeRandom rand;

        private static readonly int[] WindID = new int[11]
		{
			0,
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10
		};

        public static byte[] CreateVane(string wind)
        {
			int maxValue = 1;
			int width = 18;
			if (isSmall(wind))
			{
				width = 10;
			}
			Bitmap image = new Bitmap(width, 32);
			Graphics graphics = Graphics.FromImage(image);
			graphics.SmoothingMode = SmoothingMode.HighQuality;
			try
			{
				graphics.Clear(Color.Transparent);
				rand.Next(7);
				Brush brush = new SolidBrush(Color.Red);
				StringFormat format = new StringFormat(StringFormatFlags.NoClip)
				{
					Alignment = StringAlignment.Center,
					LineAlignment = StringAlignment.Center
				};
				int index = rand.Next(WindMgr.font.Length);
				Font font = new Font(WindMgr.font[index], 17f, FontStyle.Italic);
				Point point = new Point(8, 12);
				if (isSmall(wind))
				{
					if (wind == fontWind[0])
					{
						font = new Font(WindMgr.font[index], 10f, FontStyle.Regular);
					}
					point = new Point(4, 16);
				}
				float angle = ThreadSafeRandom.NextStatic(-maxValue, maxValue);
				graphics.TranslateTransform(point.X, point.Y);
				graphics.RotateTransform(angle);
				graphics.DrawString(wind.ToString(), font, brush, 1f, 1f, format);
				graphics.RotateTransform(0f - angle);
				graphics.TranslateTransform(2f, 0f - (float)point.Y);
				MemoryStream stream = new MemoryStream();
				image.Save(stream, ImageFormat.Png);
				return stream.ToArray();
			}
			finally
			{
				graphics.Dispose();
				image.Dispose();
			}
        }

        public static WindInfo FindWind(int ID)
        {
			m_lock.AcquireReaderLock(10000);
			try
			{
				if (_winds.ContainsKey(ID))
				{
					return _winds[ID];
				}
			}
			catch
			{
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static List<WindInfo> GetWind()
        {
			m_lock.AcquireReaderLock(10000);
			try
			{
				List<WindInfo> list = new List<WindInfo>();
				for (int i = 0; i < _winds.Values.Count; i++)
				{
					list.Add(_winds[i]);
				}
				if (list.Count > 0)
				{
					return list;
				}
			}
			catch
			{
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static byte GetWindID(int wind, int pos)
        {
			if (wind < 10)
			{
				switch (pos)
				{
				case 1:
					return 10;
				case 3:
					if (wind != 0)
					{
						return (byte)wind;
					}
					return 10;
				}
			}
			if (wind >= 10 && wind < 20)
			{
				switch (pos)
				{
				case 1:
					return 1;
				case 3:
					if (wind - 10 != 0)
					{
						return (byte)(wind - 10);
					}
					return 10;
				}
			}
			if (wind >= 20 && wind < 30)
			{
				switch (pos)
				{
				case 1:
					return 2;
				case 3:
					if (wind - 20 != 0)
					{
						return (byte)(wind - 20);
					}
					return 10;
				}
			}
			if (wind >= 30 && wind < 40)
			{
				switch (pos)
				{
				case 1:
					return 3;
				case 3:
					if (wind - 30 != 0)
					{
						return (byte)(wind - 30);
					}
					return 10;
				}
			}
			if (wind >= 40 && wind < 50)
			{
				switch (pos)
				{
				case 1:
					return 4;
				case 3:
					if (wind - 40 != 0)
					{
						return (byte)(wind - 40);
					}
					return 10;
				}
			}
			return 0;
        }

        public static bool Init()
        {
			try
			{
				m_lock = new ReaderWriterLock();
				_winds = new Dictionary<int, WindInfo>();
				rand = new ThreadSafeRandom();
				return LoadWinds(_winds);
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("WindInfoMgr", exception);
				}
				return false;
			}
        }

        public static bool isSmall(string wind)
        {
			if (!(wind == fontWind[0]))
			{
				return wind == fontWind[1];
			}
			return true;
        }

        private static bool LoadWinds(Dictionary<int, WindInfo> Winds)
        {
			int[] windID = WindID;
			int[] array = windID;
			foreach (int num2 in array)
			{
				WindInfo info = new WindInfo();
				byte[] buffer = CreateVane(fontWind[num2]);
				if (buffer == null || buffer.Length == 0)
				{
					if (log.IsErrorEnabled)
					{
						log.Error("Load Wind Error!");
					}
					return false;
				}
				info.WindID = num2;
				info.WindPic = buffer;
				if (!Winds.ContainsKey(num2))
				{
					Winds.Add(num2, info);
				}
			}
			return true;
        }

        public static byte[] ReadImageFile(string imageLocation)
        {
			long length = new FileInfo(imageLocation).Length;
			return new BinaryReader(new FileStream(imageLocation, FileMode.Open, FileAccess.Read)).ReadBytes((int)length);
        }

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, WindInfo> winds = new Dictionary<int, WindInfo>();
				if (LoadWinds(winds))
				{
					m_lock.AcquireWriterLock(-1);
					try
					{
						_winds = winds;
						return true;
					}
					catch
					{
					}
					finally
					{
						m_lock.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("WindMgr", exception);
				}
			}
			return false;
        }
    }
}
