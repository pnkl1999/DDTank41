using System;
using System.Security.Cryptography;

namespace Bussiness
{
    public class RandomSafe : Random
    {
        public override int Next(int max)
        {
			return Next(0, max);
        }

        public override int Next(int min, int max)
        {
			int num1 = base.Next(1, 50);
			int num2 = max - 1;
			for (int index = 0; index < num1; index++)
			{
				num2 = base.Next(min, max);
			}
			return num2;
        }

        public int NextSmallValue(int min, int max)
        {
			int num = Math.Abs(Next(min, max) - max);
			if (num > max)
			{
				num = max;
			}
			else if (num < min)
			{
				num = min;
			}
			return num;
        }

        private static int smethod_0()
        {
			byte[] data = new byte[4];
			new RNGCryptoServiceProvider().GetBytes(data);
			return BitConverter.ToInt32(data, 0);
        }
    }
}
