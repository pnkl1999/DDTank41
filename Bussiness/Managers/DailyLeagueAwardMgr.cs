using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System.Linq;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Reflection;

namespace Bussiness.Managers
{
    public class DailyLeagueAwardMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private static Dictionary<int, List<DailyLeagueAwardInfo>> m_DailyLeagueAwards;
        private static Random random = new Random();
        public static bool ReLoad()
        {
            try
            {
                DailyLeagueAwardInfo[] tempDailyLeagueAward = LoadDailyLeagueAwardDb();
                Dictionary<int, List<DailyLeagueAwardInfo>> tempDailyLeagueAwards = LoadDailyLeagueAwards(tempDailyLeagueAward);
                if (tempDailyLeagueAward.Length > 0)
                {
                    Interlocked.Exchange(ref m_DailyLeagueAwards, tempDailyLeagueAwards);
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("ReLoad DailyLeagueAward", e);
                return false;
            }
            return true;
        }
        public static bool Init()
        {
            return ReLoad();
        }
        public static DailyLeagueAwardInfo[] LoadDailyLeagueAwardDb()
        {
            using (ProduceBussiness pb = new ProduceBussiness())
            {
                DailyLeagueAwardInfo[] infos = pb.GetAllDailyLeagueAward();
                return infos;
            }
        }
        public static Dictionary<int, List<DailyLeagueAwardInfo>> LoadDailyLeagueAwards(DailyLeagueAwardInfo[] DailyLeagueAward)
        {
            Dictionary<int, List<DailyLeagueAwardInfo>> infos = new Dictionary<int, List<DailyLeagueAwardInfo>>();
            foreach (DailyLeagueAwardInfo info in DailyLeagueAward)
            {
                if (!infos.Keys.Contains(info.Class))
                {
                    IEnumerable<DailyLeagueAwardInfo> temp = DailyLeagueAward.Where(s => s.Class == info.Class);
                    infos.Add(info.Class, temp.ToList());
                }
            }
            return infos;
        }
        public static List<DailyLeagueAwardInfo> FindDailyLeagueAward(int Class)
        {
            if (m_DailyLeagueAwards.ContainsKey(Class))
            {
                List<DailyLeagueAwardInfo> items = m_DailyLeagueAwards[Class];
                return items;
            }
            return null;
        }
    }

}
