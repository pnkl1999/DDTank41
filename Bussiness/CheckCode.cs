using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

namespace Bussiness
{
    public class CheckCode
    {
        private enum RandomStringMode
		{
			LowerLetter,
            UpperLetter,
            Letter,
            Digital,
            Mix
		}

        private static Color[] c = new Color[2]
		{
			Color.Gray,
			Color.DimGray
		};

        private static char[] digitals = new char[]
		{
			'1',
			'2',
			'3',
			'4',
			'5',
			'6',
			'7',
			'8',
			'9',
			'0'
		};

        private static string[] font = new string[5]
		{
			"Verdana",
			"Terminal",
			"Comic Sans MS",
			"Arial",
			"Tekton Pro"
		};

        private static char[] letters = new char[50]
		{
			'a',
			'b',
			'c',
			'd',
			'e',
			'f',
			'g',
			'h',
			'i',
			'j',
			'k',
			'l',
			'm',
			'n',
			'p',
			'q',
			'r',
			's',
			't',
			'u',
			'v',
			'w',
			'x',
			'y',
			'z',
			'A',
			'B',
			'C',
			'D',
			'E',
			'F',
			'G',
			'H',
			'I',
			'J',
			'K',
			'L',
			'M',
			'N',
			'P',
			'Q',
			'R',
			'S',
			'T',
			'U',
			'V',
			'W',
			'X',
			'Y',
			'Z'
		};

        private static char[] lowerLetters = new char[21]
		{
			'a',
			'b',
			'c',
			'd',
			'e',
			'f',
			'h',
			'k',
			'm',
			'n',
			'p',
			'q',
			'r',
			's',
			't',
			'u',
			'v',
			'w',
			'x',
			'y',
			'z'
		};

        private static char[] mix = new char[51]
		{
			'2',
			'3',
			'4',
			'5',
			'6',
			'7',
			'8',
			'9',
			'a',
			'b',
			'c',
			'd',
			'e',
			'f',
			'h',
			'k',
			'm',
			'n',
			'p',
			'q',
			'r',
			's',
			't',
			'u',
			'v',
			'w',
			'x',
			'y',
			'z',
			'A',
			'B',
			'C',
			'D',
			'E',
			'F',
			'G',
			'H',
			'K',
			'M',
			'N',
			'P',
			'Q',
			'R',
			'S',
			'T',
			'U',
			'V',
			'W',
			'X',
			'Y',
			'Z'
		};

        public static ThreadSafeRandom rand = new ThreadSafeRandom();

        private static char[] upperLetters = new char[22]
		{
			'A',
			'B',
			'C',
			'D',
			'E',
			'F',
			'G',
			'H',
			'K',
			'M',
			'N',
			'P',
			'Q',
			'R',
			'S',
			'T',
			'U',
			'V',
			'W',
			'X',
			'Y',
			'Z'
		};

        public static byte[] CreateImage(string randomcode)
        {
			int maxValue = 30;
			Bitmap image = new Bitmap(randomcode.Length * 30, 32);
			Graphics graphics = Graphics.FromImage(image);
			graphics.SmoothingMode = SmoothingMode.HighQuality;
			try
			{
				graphics.Clear(Color.Transparent);
				int index = rand.Next(2);
				Brush brush = new SolidBrush(c[index]);
				for (int i = 0; i < 1; i++)
				{
					int num11 = rand.Next(image.Width / 2);
					int num12 = rand.Next(image.Width * 3 / 4, image.Width);
					int num13 = rand.Next(image.Height);
					int num14 = rand.Next(image.Height);
					graphics.DrawBezier(new Pen(c[index], 2f), num11, num13, (num11 + num12) / 4, 0f, (num11 + num12) * 3 / 4, image.Height, num12, num14);
				}
				char[] chArray = randomcode.ToCharArray();
				StringFormat format = new StringFormat(StringFormatFlags.NoClip)
				{
					Alignment = StringAlignment.Center,
					LineAlignment = StringAlignment.Center
				};
				for (int j = 0; j < chArray.Length; j++)
				{
					int num10 = rand.Next(5);
					Font font = new Font(CheckCode.font[num10], 22f, FontStyle.Bold);
					Point point = new Point(16, 16);
					float angle = ThreadSafeRandom.NextStatic(-maxValue, maxValue);
					graphics.TranslateTransform(point.X, point.Y);
					graphics.RotateTransform(angle);
					graphics.DrawString(chArray[j].ToString(), font, brush, 1f, 1f, format);
					graphics.RotateTransform(0f - angle);
					graphics.TranslateTransform(2f, 0f - (float)point.Y);
				}
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

        public static string GenerateCheckCode()
        {
			return GenerateRandomString(4, RandomStringMode.Digital);
        }

        private static string GenerateRandomString(int length, RandomStringMode mode)
        {
			string str = string.Empty;
			if (length != 0)
			{
				switch (mode)
				{
				case RandomStringMode.LowerLetter:
				{
					for (int j = 0; j < length; j++)
					{
						str += lowerLetters[rand.Next(0, lowerLetters.Length)];
					}
					return str;
				}
				case RandomStringMode.UpperLetter:
				{
					for (int k = 0; k < length; k++)
					{
						str += upperLetters[rand.Next(0, upperLetters.Length)];
					}
					return str;
				}
				case RandomStringMode.Letter:
				{
					for (int l = 0; l < length; l++)
					{
						str += letters[rand.Next(0, letters.Length)];
					}
					return str;
				}
				case RandomStringMode.Digital:
				{
					for (int m = 0; m < length; m++)
					{
						str += digitals[rand.Next(0, digitals.Length)];
					}
					return str;
				}
				}
				for (int i = 0; i < length; i++)
				{
					str += mix[rand.Next(0, mix.Length)];
				}
			}
			return str;
        }
    }
}
