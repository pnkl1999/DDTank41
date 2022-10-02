using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Threading;
using log4net;
using SqlDataProvider.Data;

namespace Bussiness.Managers
{
	public class QuestMgr
	{

		private static Dictionary<int, AchievementInfo> _achievement = new Dictionary<int, AchievementInfo>();//

		private static Dictionary<int, List<AchievementConditionInfo>> _achievementCondition = new Dictionary<int, List<AchievementConditionInfo>>();//

		private static Dictionary<int, List<AchievementGoodsInfo>> _achievementGoods = new Dictionary<int, List<AchievementGoodsInfo>>();//

		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private static Dictionary<int, List<QuestConditionInfo>> m_questcondiction = new Dictionary<int, List<QuestConditionInfo>>();

		private static Dictionary<int, List<QuestAwardInfo>> m_questgoods = new Dictionary<int, List<QuestAwardInfo>>();

		private static Dictionary<int, QuestInfo> m_questinfo = new Dictionary<int, QuestInfo>();

		public static List<AchievementConditionInfo> GetAchievementCondiction(AchievementInfo info)
		{
			List<AchievementConditionInfo> result;
			if (!QuestMgr._achievementCondition.ContainsKey(info.ID))
			{
				result = null;
			}
			else
			{
				result = QuestMgr._achievementCondition[info.ID];
			}
			return result;
		}

		public static List<AchievementGoodsInfo> GetAchievementGoods(AchievementInfo info)
		{
			List<AchievementGoodsInfo> result;
			if (QuestMgr._achievementGoods.ContainsKey(info.ID))
			{
				result = QuestMgr._achievementGoods[info.ID];
			}
			else
			{
				result = null;
			}
			return result;
		}

		public static List<AchievementInfo> GetAllAchievements()
		{
			return QuestMgr._achievement.Values.ToList<AchievementInfo>();
		}

		public static int[] GetAllBuriedQuest()
		{
			List<int> list = new List<int>();
			foreach (QuestInfo questInfo in QuestMgr.m_questinfo.Values)
			{
				if (questInfo.QuestID == 10)
				{
					list.Add(questInfo.ID);
				}
			}
			return list.ToArray();
		}

		public static List<QuestConditionInfo> GetQuestCondiction(QuestInfo info)
		{
			List<QuestConditionInfo> result;
			if (QuestMgr.m_questcondiction.ContainsKey(info.ID))
			{
				result = QuestMgr.m_questcondiction[info.ID];
			}
			else
			{
				result = null;
			}
			return result;
		}

		public static List<QuestAwardInfo> GetQuestGoods(QuestInfo info)
		{
			List<QuestAwardInfo> result;
			if (QuestMgr.m_questgoods.ContainsKey(info.ID))
			{
				result = QuestMgr.m_questgoods[info.ID];
			}
			else
			{
				result = null;
			}
			return result;
		}

		public static AchievementInfo GetSingleAchievement(int id)
		{
			AchievementInfo result;
			if (QuestMgr._achievement.ContainsKey(id))
			{
				result = QuestMgr._achievement[id];
			}
			else
			{
				result = null;
			}
			return result;
		}

		public static QuestInfo GetSingleQuest(int id)
		{
			QuestInfo result;
			if (!QuestMgr.m_questinfo.ContainsKey(id))
			{
				result = null;
			}
			else
			{
				result = QuestMgr.m_questinfo[id];
			}
			return result;
		}

		public static bool Init()
		{
			return QuestMgr.ReLoad();
		}
		public static Dictionary<int, List<AchievementConditionInfo>> LoadAchievementCondictionDb(Dictionary<int, AchievementInfo> achs)
		{
			Dictionary<int, List<AchievementConditionInfo>> dictionary = new Dictionary<int, List<AchievementConditionInfo>>();
			Dictionary<int, List<AchievementConditionInfo>> result;
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				AchievementConditionInfo[] allAchievementCondition = produceBussiness.GetALlAchievementCondition();
				foreach (AchievementInfo ach in achs.Values)
				{
					IEnumerable<AchievementConditionInfo> source = allAchievementCondition.Where((AchievementConditionInfo s) => s.AchievementID == ach.ID);
					dictionary.Add(ach.ID, source.ToList());
				}
				result = dictionary;
			}
			return result;
		}

		public static Dictionary<int, List<AchievementGoodsInfo>> LoadAchievementGoodDb(Dictionary<int, AchievementInfo> achs)
		{
			Dictionary<int, List<AchievementGoodsInfo>> dictionary = new Dictionary<int, List<AchievementGoodsInfo>>();
			Dictionary<int, List<AchievementGoodsInfo>> result;
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				AchievementGoodsInfo[] allAchievementGoods = produceBussiness.GetAllAchievementGoods();
				foreach (AchievementInfo ach in achs.Values)
				{
					IEnumerable<AchievementGoodsInfo> source = allAchievementGoods.Where((AchievementGoodsInfo s) => s.AchievementID == ach.ID);
					dictionary.Add(ach.ID, source.ToList());
				}
				result = dictionary;
			}
			return result;
		}

		public static Dictionary<int, AchievementInfo> LoadAchievementInfoDb()
		{
			Dictionary<int, AchievementInfo> dictionary = new Dictionary<int, AchievementInfo>();
			Dictionary<int, AchievementInfo> result;
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				AchievementInfo[] allAchievement = produceBussiness.GetAllAchievement();
				foreach (AchievementInfo achievementInfo in allAchievement)
				{
					if (!dictionary.ContainsKey(achievementInfo.ID))
					{
						dictionary.Add(achievementInfo.ID, achievementInfo);
					}
				}
				result = dictionary;
			}
			return result;
		}

		public static Dictionary<int, List<QuestConditionInfo>> LoadQuestCondictionDb(Dictionary<int, QuestInfo> quests)
		{
			Dictionary<int, List<QuestConditionInfo>> dictionary = new Dictionary<int, List<QuestConditionInfo>>();
			Dictionary<int, List<QuestConditionInfo>> result;
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				QuestConditionInfo[] allQuestCondiction = produceBussiness.GetAllQuestCondiction();
				foreach (QuestInfo quest in quests.Values)
				{
					IEnumerable<QuestConditionInfo> source = allQuestCondiction.Where((QuestConditionInfo s) => s.QuestID == quest.ID);
					dictionary.Add(quest.ID, source.ToList());
				}
				result = dictionary;
			}
			return result;
		}
		public static Dictionary<int, List<QuestAwardInfo>> LoadQuestGoodDb(Dictionary<int, QuestInfo> quests)
		{
			Dictionary<int, List<QuestAwardInfo>> dictionary = new Dictionary<int, List<QuestAwardInfo>>();
			Dictionary<int, List<QuestAwardInfo>> result;
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				QuestAwardInfo[] allQuestGoods = produceBussiness.GetAllQuestGoods();
				foreach (QuestInfo quest in quests.Values)
				{
					IEnumerable<QuestAwardInfo> source = allQuestGoods.Where((QuestAwardInfo s) => s.QuestID == quest.ID);
					dictionary.Add(quest.ID, source.ToList());
				}
				result = dictionary;
			}
			return result;
		}

		public static Dictionary<int, QuestInfo> LoadQuestInfoDb()
		{
			Dictionary<int, QuestInfo> dictionary = new Dictionary<int, QuestInfo>();
			Dictionary<int, QuestInfo> result;
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				QuestInfo[] allQuest = produceBussiness.GetALlQuest();
				foreach (QuestInfo questInfo in allQuest)
				{
					if (!dictionary.ContainsKey(questInfo.ID))
					{
						dictionary.Add(questInfo.ID, questInfo);
					}
				}
				result = dictionary;
			}
			return result;
		}

		public static bool ReLoad()
		{
			try
			{
				Dictionary<int, QuestInfo> quests = QuestMgr.LoadQuestInfoDb();
				Dictionary<int, List<QuestConditionInfo>> questscon = QuestMgr.LoadQuestCondictionDb(quests);
				Dictionary<int, List<QuestAwardInfo>> questsgood = QuestMgr.LoadQuestGoodDb(quests);
				Dictionary<int, AchievementInfo> achs = QuestMgr.LoadAchievementInfoDb();
				Dictionary<int, List<AchievementConditionInfo>> achscon = QuestMgr.LoadAchievementCondictionDb(achs);
				Dictionary<int, List<AchievementGoodsInfo>> achsgood = QuestMgr.LoadAchievementGoodDb(achs);
				if (quests.Count > 0)
				{
					Interlocked.Exchange<Dictionary<int, QuestInfo>>(ref QuestMgr.m_questinfo, quests);
					Interlocked.Exchange<Dictionary<int, List<QuestConditionInfo>>>(ref QuestMgr.m_questcondiction, questscon);
					Interlocked.Exchange<Dictionary<int, List<QuestAwardInfo>>>(ref QuestMgr.m_questgoods, questsgood);
				}
				if (achs.Count > 0)
				{
					Interlocked.Exchange<Dictionary<int, List<AchievementConditionInfo>>>(ref QuestMgr._achievementCondition, achscon);
					Interlocked.Exchange<Dictionary<int, AchievementInfo>>(ref QuestMgr._achievement, achs);
					Interlocked.Exchange<Dictionary<int, List<AchievementGoodsInfo>>>(ref QuestMgr._achievementGoods, achsgood);
				}
				return true;
			}
			catch (Exception ex)
			{
				QuestMgr.log.Error("QuestMgr", ex);
			}
			return false;
		}
	}
}
