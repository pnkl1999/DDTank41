using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace Game.Server.Task
{
    public class TaskScheduler
    {
        private static TaskScheduler _instance;
        public Dictionary<string, (Timer, Timer)> Timers { get; } = new Dictionary<string, (Timer, Timer)>();

        private TaskScheduler() { }

        public static TaskScheduler Instance => _instance ??= new TaskScheduler();

        /// <summary>
        /// Creating a start and stop timer
        /// </summary>
        /// <param name="name">Name</param>
        /// <param name="hour">Start and stop hours</param>
        /// <param name="min">Start and stop minutes</param>
        /// <param name="days">Days on which it is active</param>
        /// <param name="task">Callbacks</param>
        public void ScheduleTask(string name, (int start, int stop) hour, (int start, int stop) min, List<DayOfWeek> days, (Action start, Action stop) task)
        {
            var now = DateTime.Now;

            #region StopTimer

            var stopRunTime = new DateTime(now.Year, now.Month, now.Day, hour.stop, min.stop, 0, 0);
            stopRunTime = GetNextWeekday(stopRunTime, days);

            var timeToStop = stopRunTime - now;
            if (timeToStop <= TimeSpan.Zero)
            {
                timeToStop = TimeSpan.Zero;
            }

            var stopTimer = new Timer(x => { task.stop.Invoke(); }, null, timeToStop, TimeSpan.FromMilliseconds(-1));

            #endregion

            #region StartTimer

            var startRunTime = new DateTime(now.Year, now.Month, now.Day, hour.start, min.start, 0, 0);
            startRunTime = GetNextWeekday(startRunTime, days);

            var timeToStart = startRunTime - now;
            if (timeToStart <= TimeSpan.Zero)
            {
                timeToStart = TimeSpan.Zero;
            }

            var startTimer = new Timer(x => { task.start.Invoke(); }, null, timeToStart, TimeSpan.FromMilliseconds(-1));

            #endregion

            Timers.Add(name, (startTimer, stopTimer));
        }

        public DateTime GetNextWeekday(DateTime start, List<DayOfWeek> days)
        {
            return start.AddDays(start.DayOfWeek.MinDistanceTo(days));
        }

    }

    static class Ext
    {
        public static int MinDistanceTo(this DayOfWeek from, DayOfWeek to)
        {
            var dist = to - from;
            if (dist < 0)
                return dist + 7;
            else
                return dist;
        }
        public static int MinDistanceTo(this DayOfWeek from, IEnumerable<DayOfWeek> to)
        {
            if (!to.Any()) return 0;
            return to.Select(x => from.MinDistanceTo(x)).Min();
        }
    }
}