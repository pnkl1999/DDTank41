using System;
using System.Collections.Generic;
using System.Threading;

namespace Game.Server.LittleGame.Data
{
    public class TaskScheduler
    {
        private static TaskScheduler _instance;

        public Dictionary<string, (Timer, Timer)> Timers { get; } = new Dictionary<string, (Timer, Timer)>();

        public static TaskScheduler Instance=> _instance ?? (_instance = new TaskScheduler());

        private TaskScheduler()
        {
        }

        public void ScheduleTask(string name, (int start, int stop) hour, (int start, int stop) min, List<DayOfWeek> days, (Action start, Action stop) task)
        {
			DateTime now = DateTime.Now;
			DateTime start = new DateTime(now.Year, now.Month, now.Day, hour.stop, min.stop, 0, 0);
			start = GetNextWeekday(start, days);
			TimeSpan timeSpan = start - now;
			if (timeSpan <= TimeSpan.Zero)
			{
				timeSpan = TimeSpan.Zero;
			}
			Timer item = new Timer(delegate
			{
				task.stop();
			}, null, timeSpan, TimeSpan.FromMilliseconds(-1.0));
			DateTime start2 = new DateTime(now.Year, now.Month, now.Day, hour.start, min.start, 0, 0);
			start2 = GetNextWeekday(start2, days);
			TimeSpan timeSpan2 = start2 - now;
			if (timeSpan2 <= TimeSpan.Zero)
			{
				timeSpan2 = TimeSpan.Zero;
			}
			Timer item2 = new Timer(delegate
			{
				task.start();
			}, null, timeSpan2, TimeSpan.FromMilliseconds(-1.0));
			Timers.Add(name, (item2, item));
        }

        public DateTime GetNextWeekday(DateTime start, List<DayOfWeek> days)
        {
			return start.AddDays(start.DayOfWeek.MinDistanceTo(days));
        }
    }
}
