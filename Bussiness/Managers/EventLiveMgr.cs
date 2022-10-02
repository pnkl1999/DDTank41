using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Bussiness.Managers
{
    public class EventLiveMgr
    {
        private static Dictionary<int, EventLiveInfo> m_EventLiveInfo = new Dictionary<int, EventLiveInfo>();

        private static Dictionary<int, List<EventLiveGoods>> m_EventLiveGoods = new Dictionary<int, List<EventLiveGoods>>();

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static bool Init()
        {
			return ReLoad();
        }

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, EventLiveInfo> tempEventLiveInfo = LoadEventLiveInfoDb();
				Dictionary<int, List<EventLiveGoods>> tempEventGoods = LoadEventGoods(tempEventLiveInfo);
				if (tempEventLiveInfo.Count > 0)
				{
					Interlocked.Exchange(ref m_EventLiveInfo, tempEventLiveInfo);
					Interlocked.Exchange(ref m_EventLiveGoods, tempEventGoods);
				}
				return true;
			}
			catch (Exception e)
			{
				log.Error("EventLiveMgr", e);
			}
			return false;
        }

        public static Dictionary<int, EventLiveInfo> LoadEventLiveInfoDb()
        {
			Dictionary<int, EventLiveInfo> list = new Dictionary<int, EventLiveInfo>();
			using ProduceBussiness db = new ProduceBussiness();
			EventLiveInfo[] array = db.GetAllEventLive();
			EventLiveInfo[] array2 = array;
			foreach (EventLiveInfo info in array2)
			{
				if (!list.ContainsKey(info.EventID))
				{
					list.Add(info.EventID, info);
				}
			}
			return list;
        }

        public static Dictionary<int, List<EventLiveGoods>> LoadEventGoods(Dictionary<int, EventLiveInfo> events)
        {
			Dictionary<int, List<EventLiveGoods>> list = new Dictionary<int, List<EventLiveGoods>>();
			using ProduceBussiness db = new ProduceBussiness();
			EventLiveGoods[] infos = db.GetAllEventLiveGoods();
			foreach (EventLiveInfo eventLive in events.Values)
			{
				IEnumerable<EventLiveGoods> temp = infos.Where((EventLiveGoods s) => s.EventID == eventLive.EventID);
				list.Add(eventLive.EventID, temp.ToList());
			}
			return list;
        }

        public static EventLiveInfo GetSingleEvent(int id)
        {
			if (m_EventLiveInfo.ContainsKey(id))
			{
				return m_EventLiveInfo[id];
			}
			return null;
        }

        public static List<EventLiveGoods> GetEventGoods(EventLiveInfo info)
        {
			if (m_EventLiveGoods.ContainsKey(info.EventID))
			{
				return m_EventLiveGoods[info.EventID];
			}
			return null;
        }

        public static List<EventLiveInfo> GetAllEventInfo()
        {
			return m_EventLiveInfo.Values.ToList();
        }
    }
}
