using System;
using System.Collections.Generic;
using System.Linq;

namespace Game.Server.LittleGame.Data
{
    internal static class Ext
    {
        public static int MinDistanceTo(this DayOfWeek from, DayOfWeek to)
        {
			int num = to - from;
			if (num < 0)
			{
				return num + 7;
			}
			return num;
        }

        public static int MinDistanceTo(this DayOfWeek from, IEnumerable<DayOfWeek> to)
        {
			if (!to.Any())
			{
				return 0;
			}
			return to.Select((DayOfWeek x) => from.MinDistanceTo(x)).Min();
        }
    }
}
