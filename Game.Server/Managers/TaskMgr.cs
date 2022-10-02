using System;
using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using Game.Server.LittleGame;
using log4net;

namespace Game.Server.Task
{
    public static class TaskMgr
    {
        private static readonly ILog Log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        public static bool Init()
        {
            try
            {
                List<DayOfWeek> opendays = new List<DayOfWeek>
                    {
                        DayOfWeek.Tuesday,
                        DayOfWeek.Thursday,
                        DayOfWeek.Saturday,
                        DayOfWeek.Sunday
                    };
                //TaskScheduler.Instance.ScheduleTask(
                //    "LittleGame",
                //    (GameProperties.LittleGameStartHourse, GameProperties.LittleGameStartHourse + GameProperties.LittleGameTimeSpending),
                //    (0, 0),
                //    opendays,
                //    (LittleGameWorldMgr.OpenLittleGameSetup, LittleGameWorldMgr.CloseLittleGame));

                //TaskScheduler.Instance.ScheduleTask(
                //    "LittleGameNoticeOpen",
                //    (GameProperties.LittleGameStartHourse - 1, GameProperties.LittleGameStartHourse - 1),
                //    (55, 59),
                //    opendays,
                //    (LittleGameWorldMgr.OpenLittleGameNoticeStart, LittleGameWorldMgr.OpenLittleGameNoticeStop));

                //TaskScheduler.Instance.ScheduleTask(
                //    "LittleGameNoticeStop",
                //    (GameProperties.LittleGameStartHourse, GameProperties.LittleGameStartHourse),
                //    (55, 59),
                //    opendays,
                //    (LittleGameWorldMgr.StopLittleGameNoticeStart, LittleGameWorldMgr.StopLittleGameNoticeStop));
                //if (Log.IsInfoEnabled)
                //    Log.Info("LittleGame timer initialized!");

                return true;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return false;
            }
        }
    }
}