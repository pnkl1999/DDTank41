using System;
using System.Collections.Generic;
using System.Linq;

namespace Bussiness.Helpers
{
    public static class DictionaryHelper
    {
        public static IEnumerable<TValue> RandomValues<TKey, TValue>(this IDictionary<TKey, TValue> dict)
        {
			Random rand = new Random();
			List<TValue> values = dict.Values.ToList();
			int size = dict.Count;
			while (true)
			{
				yield return values[rand.Next(size)];
			}
        }
    }
}
