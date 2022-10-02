using System;
using System.Collections.Generic;

namespace Bussiness
{
    public class ThreadSafeRandom
    {
        private Random random = new Random();

        private static Random randomStatic = new Random();

        public int Next()
        {
			lock (random)
			{
				return random.Next();
			}
        }

        public int Next(int maxValue)
        {
			lock (random)
			{
				return random.Next(maxValue);
			}
        }

        public int Next(int minValue, int maxValue)
        {
			lock (random)
			{
				return random.Next(minValue, maxValue);
			}
        }

        public static int NextStatic()
        {
			lock (randomStatic)
			{
				return randomStatic.Next();
			}
        }

        public static int NextStatic(int maxValue)
        {
			lock (randomStatic)
			{
				return randomStatic.Next(maxValue);
			}
        }

        public static void NextStatic(byte[] keys)
        {
			lock (randomStatic)
			{
				randomStatic.NextBytes(keys);
			}
        }

        public static int NextStatic(int minValue, int maxValue)
        {
			lock (randomStatic)
			{
				return randomStatic.Next(minValue, maxValue);
			}
        }

        public void Shuffer<T>(T[] array)
        {
			for (int i = array.Length; i > 1; i--)
			{
				int index = random.Next(i);
				T local = array[index];
				array[index] = array[i - 1];
				array[i - 1] = local;
			}
        }

        public void ShufferList<T>(List<T> array)
        {
			for (int i = array.Count; i > 1; i--)
			{
				int num2 = random.Next(i);
				T local = array[num2];
				array[num2] = array[i - 1];
				array[i - 1] = local;
			}
        }

        public static void ShufferStatic<T>(T[] array)
        {
			for (int i = array.Length; i > 1; i--)
			{
				int index = randomStatic.Next(i);
				T local = array[index];
				array[index] = array[i - 1];
				array[i - 1] = local;
			}
        }
    }
}
