using System;
using System.Collections.Generic;
using System.Linq;

namespace Bussiness
{
    public static class EnumerableExtensions
    {
        public static T Random<T>(this IEnumerable<T> enumerable)
        {
            ThreadSafeRandom r = new ThreadSafeRandom();
            IList<T> list = enumerable as IList<T> ?? enumerable.ToList();
            return list.ElementAt(r.Next(0, list.Count()));
        }
    }
}