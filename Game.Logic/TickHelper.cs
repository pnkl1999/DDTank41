using System.Diagnostics;

namespace Game.Logic
{
    public static class TickHelper
    {
        private static long StopwatchFrequencyMilliseconds = Stopwatch.Frequency / 1000;

        public static long GetTickCount()
        {
			return Stopwatch.GetTimestamp() / StopwatchFrequencyMilliseconds;
        }
    }
}
