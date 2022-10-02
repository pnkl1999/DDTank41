using System.Collections.Generic;
using System.Linq;

namespace Bussiness.Helpers
{
    public static class Functions
    {
        public static IEnumerable<IEnumerable<T>> Split<T>(this T[] array, int size)
        {
			for (int i = 0; (float)i < (float)array.Length / (float)size; i++)
			{
				yield return array.Skip(i * size).Take(size);
			}
        }

        public static IEnumerable<IEnumerable<T>> Split<T>(this T[] array, int size, int startIndex)
        {
			for (int i = 1; (float)i < (float)array.Length / (float)size; i++)
			{
				yield return array.Skip(i * size).Take(size);
			}
        }
    }
}
