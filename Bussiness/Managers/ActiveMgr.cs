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
    public class ActiveMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private static Dictionary<int, ActiveInfo> m_activeinfo = new Dictionary<int, ActiveInfo>();
        private static Dictionary<int, List<ActiveConvertItemInfo>> m_activeConvertItem = new Dictionary<int, List<ActiveConvertItemInfo>>();
        private static Dictionary<int, List<ActiveAwardInfo>> m_activeAwards = new Dictionary<int, List<ActiveAwardInfo>>();
        private static Dictionary<int, List<ActivitySystemItemInfo>> m_ActivitySystemItems = new Dictionary<int, List<ActivitySystemItemInfo>>();
        public static bool Init()
        {
            return ReLoad();
        }
        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, ActiveInfo> tempActiveInfo = LoadActiveInfoDb();
                Dictionary<int, List<ActiveConvertItemInfo>> tempActiveCondiction = LoadActiveCondictionDb(tempActiveInfo);
                Dictionary<int, List<ActiveAwardInfo>> tempActiveGoods = LoadActiveGoodDb(tempActiveInfo);
                if (tempActiveInfo.Count > 0)
                {
                    Interlocked.Exchange(ref m_activeinfo, tempActiveInfo);
                    Interlocked.Exchange(ref m_activeConvertItem, tempActiveCondiction);
                    Interlocked.Exchange(ref m_activeAwards, tempActiveGoods);
                }
                ActivitySystemItemInfo[] tempActivitySystemItem = LoadActivitySystemItemDb();
                Dictionary<int, List<ActivitySystemItemInfo>> tempActivitySystemItems = LoadActivitySystemItems(tempActivitySystemItem);
                if (tempActivitySystemItem.Length > 0)
                {
                    Interlocked.Exchange(ref m_ActivitySystemItems, tempActivitySystemItems);
                }
                return true;
            }
            catch (Exception e)
            {
                log.Error("ActiveMgr", e);

            }

            return false;
        }
        public static void UpdateCurrentServerActive()
        {
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                pb.DeleteAllActive();
                foreach (ActiveInfo info in m_activeinfo.Values)
                {
                    pb.AddActive(info);
                    if (m_activeAwards.ContainsKey(info.ActiveID))
                    {
                        List<ActiveAwardInfo> awards = m_activeAwards[info.ActiveID];
                        foreach (ActiveAwardInfo award in awards)
                        {
                            pb.AddActiveAward(award);
                        }
                    }
                }
            }
        }
        public static ActiveConvertItemInfo GetActiveConvertItem(int id, int templateID, int index)
        {
            if (m_activeConvertItem.ContainsKey(id))
            {
                List<ActiveConvertItemInfo> lists = m_activeConvertItem[id];
                foreach (ActiveConvertItemInfo info in lists)
                {
                    if (info.TemplateID == templateID && info.ItemType == GetNeedGoodsAward(index))
                    {
                        return info;
                    }
                }
            }
            return null;
        }
        public static List<ActiveConvertItemInfo> GetActiveConvertItemAward(int id, int index)
        {
            List<ActiveConvertItemInfo> listAward = new List<ActiveConvertItemInfo>();
            if (m_activeConvertItem.ContainsKey(id))
            {
                List<ActiveConvertItemInfo> lists = m_activeConvertItem[id];
                foreach (ActiveConvertItemInfo info in lists)
                {
                    if (info.ItemType == GetGoodsAward(index))
                    {
                        listAward.Add(info);
                    }
                }
            }
            return listAward;
        }
        public static List<ActiveConvertItemInfo> FindActiveConvertItem(int id)
        {
            if (m_activeConvertItem.ContainsKey(id))
            {
                return m_activeConvertItem[id];
            }
            return null;
        }
        public static int GetGoodsAward(int index)
        {
            switch (index)
            {
                case 1:
                    return 3;
                case 2:
                    return 5;
                case 3:
                    return 7;
            }
            return 1;
        }
        public static int GetNeedGoodsAward(int index)
        {
            switch (index)
            {
                case 1:
                    return 2;
                case 2:
                    return 4;
                case 3:
                    return 6;
            }
            return 0;
        }
        public static ActivitySystemItemInfo[] LoadActivitySystemItemDb()
        {
            using (ProduceBussiness pb = new ProduceBussiness())
            {
                ActivitySystemItemInfo[] infos = pb.GetAllActivitySystemItem();
                return infos;
            }
        }
        public static Dictionary<int, List<ActivitySystemItemInfo>> LoadActivitySystemItems(ActivitySystemItemInfo[] ActivitySystemItem)
        {
            Dictionary<int, List<ActivitySystemItemInfo>> infos = new Dictionary<int, List<ActivitySystemItemInfo>>();
            foreach (ActivitySystemItemInfo info in ActivitySystemItem)
            {
                if (!infos.Keys.Contains(info.ActivityType))
                {
                    IEnumerable<ActivitySystemItemInfo> temp = ActivitySystemItem.Where(s => s.ActivityType == info.ActivityType);
                    infos.Add(info.ActivityType, temp.ToList());
                }
            }
            return infos;
        }
        public static List<ActivitySystemItemInfo> FindActivitySystemItem(int ActivityType)
        {
            if (m_ActivitySystemItems.ContainsKey(ActivityType))
            {
                List<ActivitySystemItemInfo> items = new List<ActivitySystemItemInfo>();
                foreach (ActivitySystemItemInfo sysItem in m_ActivitySystemItems[ActivityType])
                    items.Add(sysItem);

                return items;
            }
            return null;
        }
        public static List<ActivitySystemItemInfo> GetActivitySystemItemByLayer(int layer)
        {
            List<ActivitySystemItemInfo> lists = new List<ActivitySystemItemInfo>();
            List<ActivitySystemItemInfo> infos = FindActivitySystemItem(8);
            foreach (ActivitySystemItemInfo info in infos)
            {
                if (info.Quality == layer)
                {
                    lists.Add(info);
                }
            }
            return lists;
        }
        public static List<ActivitySystemItemInfo> GetGrowthPackage(int layer)
        {
            List<ActivitySystemItemInfo> lists = new List<ActivitySystemItemInfo>();
            List<ActivitySystemItemInfo> infos = FindActivitySystemItem(20);
            foreach (ActivitySystemItemInfo info in infos)
            {
                if (info.Quality == layer)
                {
                    lists.Add(info);
                }
            }
            return lists;
        }
        public static List<ActivitySystemItemInfo> FindChickActivePakage(int quality)
        {
            List<ActivitySystemItemInfo> lists = new List<ActivitySystemItemInfo>();
            List<ActivitySystemItemInfo> infos = FindActivitySystemItem(40);
            foreach (ActivitySystemItemInfo info in infos)
            {
                if (info.Quality == quality)
                {
                    lists.Add(info);
                }
            }
            return lists;
        }
        public static List<ActivitySystemItemInfo> FindSignBuffPackage(int quality)
        {
            List<ActivitySystemItemInfo> lists = new List<ActivitySystemItemInfo>();
            List<ActivitySystemItemInfo> infos = FindActivitySystemItem(112);
            foreach (ActivitySystemItemInfo info in infos)
            {
                if (info.Quality == quality)
                {
                    lists.Add(info);
                }
            }
            return lists;
        }
        public static List<ActivitySystemItemInfo> FindLoginDevicePackage(int quality)
        {
            List<ActivitySystemItemInfo> lists = new List<ActivitySystemItemInfo>();
            List<ActivitySystemItemInfo> infos = FindActivitySystemItem(110);
            foreach (ActivitySystemItemInfo info in infos)
            {
                if (info.Quality == quality)
                {
                    lists.Add(info);
                }
            }
            return lists;
        }
        public static List<ActivitySystemItemInfo> FindMinesRandomExchange(int total)
        {
            List<ActivitySystemItemInfo> lists = new List<ActivitySystemItemInfo>();
            List<ActivitySystemItemInfo> infos = FindActivitySystemItem(156);

            for (int i = 0; i < total; i++)
            {
                int place = ThreadSafeRandom.NextStatic(infos.Count);

                if (place < infos.Count)
                {
                    lists.Add(infos[place]);
                    infos.RemoveAt(place);
                }
            }
            return lists;
        }
        public static List<ActivitySystemItemInfo> FindLotteryTicketPackage(int quality)
        {
            List<ActivitySystemItemInfo> lists = new List<ActivitySystemItemInfo>();
            List<ActivitySystemItemInfo> infos = FindActivitySystemItem(114);
            foreach (ActivitySystemItemInfo info in infos)
            {
                if (info.Quality == quality)
                {
                    lists.Add(info);
                }
            }
            return lists;
        }
        public static Dictionary<int, ActiveInfo> LoadActiveInfoDb()
        {
            Dictionary<int, ActiveInfo> list = new Dictionary<int, ActiveInfo>();
            using (ActiveBussiness ab = new ActiveBussiness())
            {
                ActiveInfo[] infos = ab.GetAllActives();
                foreach (ActiveInfo info in infos)
                {
                    if (info.ActiveID < 0)
                        continue;

                    if (!list.ContainsKey(info.ActiveID))
                    {
                        list.Add(info.ActiveID, info);
                    }
                }
            }
            return list;
        }
        public static Dictionary<int, List<ActiveConvertItemInfo>> LoadActiveCondictionDb(Dictionary<int, ActiveInfo> Actives)
        {
            Dictionary<int, List<ActiveConvertItemInfo>> list = new Dictionary<int, List<ActiveConvertItemInfo>>();

            using (ActiveBussiness ab = new ActiveBussiness())
            {
                ActiveConvertItemInfo[] infos = ab.GetAllActiveConvertItem();
                foreach (ActiveInfo active in Actives.Values)
                {
                    IEnumerable<ActiveConvertItemInfo> temp = infos.Where(s => s.ActiveID == active.ActiveID);
                    list.Add(active.ActiveID, temp.ToList());
                }
            }
            return list;
        }
        public static Dictionary<int, List<ActiveAwardInfo>> LoadActiveGoodDb(Dictionary<int, ActiveInfo> Actives)
        {
            Dictionary<int, List<ActiveAwardInfo>> list = new Dictionary<int, List<ActiveAwardInfo>>();
            using (ActiveBussiness ab = new ActiveBussiness())
            {
                ActiveAwardInfo[] infos = ab.GetAllActiveAwardInfo();
                foreach (ActiveInfo Active in Actives.Values)
                {
                    IEnumerable<ActiveAwardInfo> temp = infos.Where(s => s.ActiveID == Active.ActiveID);
                    list.Add(Active.ActiveID, temp.ToList());
                }
            }
            return list;
        }
        public static ActiveInfo GetSingleActive(int id)
        {
            if (m_activeinfo.Count == 0)
                Init();
            if (m_activeinfo.ContainsKey(id))
            {
                return m_activeinfo[id];
            }
            return null;
        }
        public static List<ActiveAwardInfo> GetActiveAward(int id)
        {
            if (m_activeinfo.Count == 0)
                Init();
            if (m_activeAwards.ContainsKey(id))
            {
                return m_activeAwards[id];
            }
            return null;
        }
    }
}

