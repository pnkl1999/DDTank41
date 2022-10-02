using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Bussiness.Managers
{
    public class SubActiveMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static Dictionary<int, SubActiveConditionInfo> m_SubActiveConditionInfo = new Dictionary<int, SubActiveConditionInfo>();

        public static Dictionary<int, List<SubActiveInfo>> m_SubActiveInfo = new Dictionary<int, List<SubActiveInfo>>();

        public static SubActiveConditionInfo GetSubActiveInfo(ItemInfo item)
        {
			foreach (List<SubActiveInfo> value in m_SubActiveInfo.Values)
			{
				foreach (SubActiveInfo info in value)
				{
					if (!IsValid(info))
					{
						continue;
					}
					foreach (SubActiveConditionInfo info2 in m_SubActiveConditionInfo.Values)
					{
						if (info.ActiveID != info2.ActiveID || info.SubID != info2.SubID || info2.ConditionID != item.TemplateID)
						{
							continue;
						}
						switch (item.Template.CategoryID)
						{
						case 1:
						case 5:
						case 7:
							if (item.StrengthenLevel == info2.Type)
							{
								return info2;
							}
							if (item.IsGold && item.StrengthenLevel + 100 == info2.Type)
							{
								return info2;
							}
							return null;
						case 6:
							return info2;
						default:
							return info2;
						}
					}
				}
			}
			return null;
        }

        public static bool Init()
        {
			return ReLoad();
        }

        public static bool IsValid(SubActiveInfo info)
        {
			_ = info.StartTime;
			_ = info.EndTime;
			if (info.StartTime.Ticks <= DateTime.Now.Ticks)
			{
				return info.EndTime.Ticks >= DateTime.Now.Ticks;
			}
			return false;
        }

        public static Dictionary<int, SubActiveConditionInfo> LoadSubActiveConditionDb(Dictionary<int, List<SubActiveInfo>> conditions)
        {
			Dictionary<int, SubActiveConditionInfo> dictionary = new Dictionary<int, SubActiveConditionInfo>();
			using ProduceBussiness bussiness = new ProduceBussiness();
			foreach (int num in conditions.Keys)
			{
				SubActiveConditionInfo[] allSubActiveCondition = bussiness.GetAllSubActiveCondition(num);
				SubActiveConditionInfo[] array = allSubActiveCondition;
				foreach (SubActiveConditionInfo info in array)
				{
					if (num == info.ActiveID && !dictionary.ContainsKey(info.ID))
					{
						dictionary.Add(info.ID, info);
					}
				}
			}
			return dictionary;
        }

        public static Dictionary<int, List<SubActiveInfo>> LoadSubActiveDb()
        {
			Dictionary<int, List<SubActiveInfo>> dictionary = new Dictionary<int, List<SubActiveInfo>>();
			using ProduceBussiness bussiness = new ProduceBussiness();
			SubActiveInfo[] allSubActive = bussiness.GetAllSubActive();
			SubActiveInfo[] array = allSubActive;
			foreach (SubActiveInfo info in array)
			{
				List<SubActiveInfo> list = new List<SubActiveInfo>();
				if (!dictionary.ContainsKey(info.ActiveID))
				{
					list.Add(info);
					dictionary.Add(info.ActiveID, list);
				}
				else
				{
					dictionary[info.ActiveID].Add(info);
				}
			}
			return dictionary;
        }

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, List<SubActiveInfo>> conditions = LoadSubActiveDb();
				Dictionary<int, SubActiveConditionInfo> dictionary2 = LoadSubActiveConditionDb(conditions);
				if (conditions.Count > 0)
				{
					Interlocked.Exchange(ref m_SubActiveInfo, conditions);
					Interlocked.Exchange(ref m_SubActiveConditionInfo, dictionary2);
				}
				return true;
			}
			catch (Exception exception)
			{
				log.Error("QuestMgr", exception);
			}
			return false;
        }
    }
}
