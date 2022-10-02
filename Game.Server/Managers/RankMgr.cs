using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
    public class RankMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock = new ReaderWriterLock();

        private static Dictionary<int, UserMatchInfo> _matchs;

        private static Dictionary<int, UserRankDateInfo> _newRanks;

        protected static Timer _timer;

        public static bool Init()
        {
            try
            {
                m_lock = new ReaderWriterLock();
                _matchs = new Dictionary<int, UserMatchInfo>();
                _newRanks = new Dictionary<int, UserRankDateInfo>();
                BeginTimer();
                return ReLoad();
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("RankMgr", exception);
                }
                return false;
            }
        }

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, UserMatchInfo> dictionary = new Dictionary<int, UserMatchInfo>();
                Dictionary<int, UserRankDateInfo> newRanks = new Dictionary<int, UserRankDateInfo>();
                if (LoadData(dictionary, newRanks))
                {
                    m_lock.AcquireWriterLock(-1);
                    try
                    {
                        _matchs = dictionary;
                        _newRanks = newRanks;
                        return true;
                    }
                    catch
                    {
                    }
                    finally
                    {
                        m_lock.ReleaseWriterLock();
                    }
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("RankMgr", exception);
                }
            }
            return false;
        }

        public static UserMatchInfo FindRank(int UserID)
        {
            if (_matchs.ContainsKey(UserID))
            {
                return _matchs[UserID];
            }
            return null;
        }

        public static UserRankDateInfo FindRankDate(int UserID)
        {
            if (_newRanks.ContainsKey(UserID))
            {
                return _newRanks[UserID];
            }
            return null;
        }

        public static bool IsTopLeague(int UserID)
        {
            bool result = false;
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                UserMatchInfo[] userMatches = pb.GetTopUserMatchInfo();
                foreach (UserMatchInfo info in userMatches)
                {
                    if (UserID > 0 && info != null)
                    {
                        if (UserID == info.UserID)
                        {
                            result = true;
                        }
                        else
                        {
                            result = false;
                        }
                    }
                }
            }
            return result;
        }


        private static bool LoadData(Dictionary<int, UserMatchInfo> Match, Dictionary<int, UserRankDateInfo> NewRanks)
        {
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                pb.UpdateRank();
                UserMatchInfo[] userMatches = pb.GetAllUserMatchInfo();
                foreach (UserMatchInfo info in userMatches)
                {
                    if (!Match.ContainsKey(info.UserID))
                    {
                        Match.Add(info.UserID, info);
                    }
                }
                UserRankDateInfo[] userRankDates = pb.GetAllUserRankDate();
                foreach (UserRankDateInfo info in userRankDates)
                {
                    if (!NewRanks.ContainsKey(info.UserID))
                    {
                        NewRanks.Add(info.UserID, info);
                    }
                }
            }
            return true;
        }

        public static void BeginTimer()
        {
            int num = 3600000;
            if (_timer == null)
            {
                _timer = new Timer(TimeCheck, null, num, num);
            }
            else
            {
                _timer.Change(num, num);
            }
        }

        protected static void TimeCheck(object sender)
        {
            try
            {
                int tickCount = Environment.TickCount;
                ThreadPriority priority = Thread.CurrentThread.Priority;
                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                ReLoad();
                Thread.CurrentThread.Priority = priority;
                tickCount = Environment.TickCount - tickCount;
            }
            catch (Exception ex)
            {
                Console.WriteLine("TimeCheck Rank: " + ex);
            }
        }

        public void StopTimer()
        {
            if (_timer != null)
            {
                _timer.Dispose();
                _timer = null;
            }
        }
    }
}
