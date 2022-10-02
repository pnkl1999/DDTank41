using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace Bussiness.Managers
{
    public static class AchievementMgr
    {
        private static Dictionary<int, AchievementInfo> m_achievement = new Dictionary<int, AchievementInfo>();

        private static Dictionary<int, List<AchievementConditionInfo>> m_achievementCondition = new Dictionary<int, List<AchievementConditionInfo>>();

        private static Dictionary<int, List<AchievementRewardInfo>> m_achievementReward = new Dictionary<int, List<AchievementRewardInfo>>();

        private static Dictionary<int, List<ItemRecordTypeInfo>> m_itemRecordType = new Dictionary<int, List<ItemRecordTypeInfo>>();

        private static Hashtable m_distinctCondition = new Hashtable();

        private static Hashtable m_ItemRecordTypeInfo = new Hashtable();

        public static Hashtable ItemRecordType=> m_ItemRecordTypeInfo;

        public static Dictionary<int, AchievementInfo> Achievement=> m_achievement;

        public static bool Init()
        {
			return Reload();
        }

        public static bool Reload()
        {
			try
			{
				LoadItemRecordTypeInfoDB();
				Dictionary<int, AchievementInfo> tempAchievementInfo = LoadAchievementInfoDB();
				Dictionary<int, List<AchievementConditionInfo>> tempAchievementConditionInfo = LoadAchievementConditionInfoDB(tempAchievementInfo);
				Dictionary<int, List<AchievementRewardInfo>> tempAchievementRewardInfo = LoadAchievementRewardInfoDB(tempAchievementInfo);
				if (tempAchievementInfo.Count > 0)
				{
					Interlocked.Exchange(ref m_achievement, tempAchievementInfo);
					Interlocked.Exchange(ref m_achievementCondition, tempAchievementConditionInfo);
					Interlocked.Exchange(ref m_achievementReward, tempAchievementRewardInfo);
				}
				return true;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"AchievementMgr {ex}");
			}
			return false;
        }

        public static void LoadItemRecordTypeInfoDB()
        {
			using ProduceBussiness db = new ProduceBussiness();
			AchievementConditionInfo[] array = db.GetALlAchievementCondition();
			AchievementConditionInfo[] array2 = array;
			foreach (AchievementConditionInfo info in array2)
			{
				if (!m_ItemRecordTypeInfo.Contains(info.CondictionType))
				{
					m_ItemRecordTypeInfo.Add(info.CondictionType, info.CondictionType);
				}
			}
        }

        public static Dictionary<int, AchievementInfo> LoadAchievementInfoDB()
        {
			Dictionary<int, AchievementInfo> list = new Dictionary<int, AchievementInfo>();
			using ProduceBussiness db = new ProduceBussiness();
			AchievementInfo[] array = db.GetALlAchievement();
			AchievementInfo[] array2 = array;
			foreach (AchievementInfo info in array2)
			{
				if (!list.ContainsKey(info.ID))
				{
					list.Add(info.ID, info);
				}
			}
			return list;
        }

        public static Dictionary<int, List<AchievementConditionInfo>> LoadAchievementConditionInfoDB(Dictionary<int, AchievementInfo> achievementInfos)
        {
			Dictionary<int, List<AchievementConditionInfo>> list = new Dictionary<int, List<AchievementConditionInfo>>();
			using ProduceBussiness db = new ProduceBussiness();
			AchievementConditionInfo[] infos = db.GetALlAchievementCondition();
			foreach (AchievementInfo achievementInfo in achievementInfos.Values)
			{
				IEnumerable<AchievementConditionInfo> temp = infos.Where((AchievementConditionInfo s) => s.AchievementID == achievementInfo.ID);
				list.Add(achievementInfo.ID, temp.ToList());
				if (temp == null)
				{
					continue;
				}
				foreach (AchievementConditionInfo info in temp)
				{
					if (!m_distinctCondition.Contains(info.CondictionType))
					{
						m_distinctCondition.Add(info.CondictionType, info.CondictionType);
					}
				}
			}
			return list;
        }

        public static Dictionary<int, List<AchievementRewardInfo>> LoadAchievementRewardInfoDB(Dictionary<int, AchievementInfo> achievementInfos)
        {
			Dictionary<int, List<AchievementRewardInfo>> list = new Dictionary<int, List<AchievementRewardInfo>>();
			using ProduceBussiness db = new ProduceBussiness();
			AchievementRewardInfo[] infos = db.GetALlAchievementReward();
			foreach (AchievementInfo achievementInfo in achievementInfos.Values)
			{
				IEnumerable<AchievementRewardInfo> temp = infos.Where((AchievementRewardInfo s) => s.AchievementID == achievementInfo.ID);
				list.Add(achievementInfo.ID, temp.ToList());
			}
			return list;
        }

        public static AchievementInfo GetSingleAchievement(int id)
        {
			if (m_achievement.ContainsKey(id))
			{
				return m_achievement[id];
			}
			return null;
        }

        public static List<AchievementConditionInfo> GetAchievementCondition(AchievementInfo info)
        {
			if (m_achievementCondition.ContainsKey(info.ID))
			{
				return m_achievementCondition[info.ID];
			}
			return null;
        }

        public static List<AchievementRewardInfo> GetAchievementReward(AchievementInfo info)
        {
			if (m_achievementReward.ContainsKey(info.ID))
			{
				return m_achievementReward[info.ID];
			}
			return null;
        }
    }
}
