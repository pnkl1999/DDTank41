using Bussiness;
using Bussiness.Managers;
using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Game.Server.Achievement
{
    public class AchievementInventory
    {
        private object m_lock;

        protected List<AchievementDataInfo> m_data;

        protected List<UsersRecordInfo> m_userRecord;

        private GamePlayer m_player;

        public AchievementInventory(GamePlayer player)
        {
			m_player = player;
			m_lock = new object();
			m_userRecord = new List<UsersRecordInfo>();
			m_data = new List<AchievementDataInfo>();
        }

        public void LoadFromDatabase(int playerId)
        {
			lock (m_lock)
			{
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					m_userRecord = playerBussiness.GetUserRecord(m_player.PlayerId);
					m_data = playerBussiness.GetUserAchievementData(m_player.PlayerId);
					InitUserRecord();
					if (m_userRecord != null && m_userRecord.Count > 0)
					{
						m_player.Out.SendInitAchievements(m_userRecord);
					}
					if (m_data != null && m_data.Count > 0)
					{
						m_player.Out.SendUpdateAchievementData(m_data);
					}
				}
				BaseUserRecord.CreateCondition(AchievementMgr.ItemRecordType, m_player);
			}
        }

        public List<AchievementDataInfo> GetSuccessAchievement()
        {
			lock (m_data)
			{
				return m_data.ToList();
			}
        }

        public List<UsersRecordInfo> GetProccessAchievement()
        {
			lock (m_userRecord)
			{
				return m_userRecord.ToList();
			}
        }

        public void InitUserRecord()
        {
			Hashtable itemRecordType = AchievementMgr.ItemRecordType;
			lock (m_userRecord)
			{
				if (m_userRecord.Count >= itemRecordType.Count)
				{
					return;
				}
				DictionaryEntry de;
				foreach (DictionaryEntry item in itemRecordType)
				{
					de = item;
					UsersRecordInfo usersRecordInfo = new UsersRecordInfo();
					usersRecordInfo.UserID = m_player.PlayerId;
					DictionaryEntry dictionaryEntry = de;
					usersRecordInfo.RecordID = int.Parse(dictionaryEntry.Key.ToString());
					usersRecordInfo.Total = 0;
					usersRecordInfo.IsDirty = true;
					if (m_userRecord.Where(delegate(UsersRecordInfo s)
					{
						int recordID = s.RecordID;
						DictionaryEntry dictionaryEntry2 = de;
						return recordID == int.Parse(dictionaryEntry2.Key.ToString());
					}).ToList().Count <= 0)
					{
						m_userRecord.Add(usersRecordInfo);
					}
				}
			}
        }

        public int UpdateUserAchievement(int type, int value)
        {
			lock (m_userRecord)
			{
				foreach (UsersRecordInfo item in m_userRecord)
				{
					if (item.RecordID == type)
					{
						item.Total += value;
						item.IsDirty = true;
						m_player.Out.SendUpdateAchievements(item);
					}
				}
			}
			return 0;
        }

        public int UpdateUserAchievement(int type, int value, int mode)
        {
			lock (m_userRecord)
			{
				foreach (UsersRecordInfo item in m_userRecord)
				{
					if (item.RecordID == type && item.Total < value)
					{
						item.Total = value;
						item.IsDirty = true;
						m_player.Out.SendUpdateAchievements(item);
					}
				}
			}
			return 0;
        }

        public bool Finish(AchievementInfo achievementInfo)
        {
			if (!CanCompleted(achievementInfo))
			{
				return false;
			}
			AddAchievementData(achievementInfo);
			SendReward(achievementInfo);
			return true;
        }

        private bool CheckAchievementData(AchievementInfo info)
        {
			if (info.EndDate < DateTime.Now)
			{
				return false;
			}
			if (info.NeedMaxLevel < m_player.Level)
			{
				return false;
			}
			if (info.IsOther == 1 && m_player.PlayerCharacter.ConsortiaID <= 0)
			{
				return false;
			}
			if (info.IsOther == 2 && m_player.PlayerCharacter.SpouseID <= 0)
			{
				return false;
			}
			if (info.PreAchievementID != "0,")
			{
				string[] array = info.PreAchievementID.Split(',');
				for (int i = 0; i < array.Length; i++)
				{
					if (!IsAchievementFinish(AchievementMgr.GetSingleAchievement(Convert.ToInt32(array[i]))))
					{
						return false;
					}
				}
				return true;
			}
			return true;
        }

        public bool CanCompleted(AchievementInfo achievementInfo)
        {
			int num = 0;
			List<AchievementConditionInfo> achievementCondition = AchievementMgr.GetAchievementCondition(achievementInfo);
			if (achievementCondition != null && achievementCondition.Count > 0)
			{
				foreach (AchievementConditionInfo item in achievementCondition)
				{
					foreach (UsersRecordInfo item2 in m_userRecord)
					{
						if (item.CondictionType == item2.RecordID && item.Condiction_Para2 <= item2.Total)
						{
							num++;
						}
					}
				}
			}
			return num == achievementCondition.Count;
        }

        public bool SendReward(AchievementInfo achievementInfo)
        {
			string str = "";
			List<AchievementRewardInfo> achievementReward = AchievementMgr.GetAchievementReward(achievementInfo);
			new List<ItemInfo>();
			new List<ItemInfo>();
			foreach (AchievementRewardInfo item in achievementReward)
			{
				if (item.RewardType == 1)
				{
					m_player.Rank.AddAchievementRank(item.RewardPara);
				}
			}
			if (achievementInfo.AchievementPoint != 0)
			{
				m_player.AddAchievementPoint(achievementInfo.AchievementPoint);
				str = str + LanguageMgr.GetTranslation("Game.Server.Achievement.FinishAchievement.AchievementPoint", achievementInfo.AchievementPoint) + " ";
			}
			return true;
        }

        public AchievementInfo FindAchievement(int id)
        {
			foreach (KeyValuePair<int, AchievementInfo> item in AchievementMgr.Achievement)
			{
				if (item.Value.ID == id)
				{
					return item.Value;
				}
			}
			return null;
        }

        public bool AddAchievementData(AchievementInfo achievementInfo)
        {
			if (!IsAchievementFinish(achievementInfo))
			{
				AchievementDataInfo achievementDataInfo = new AchievementDataInfo();
				achievementDataInfo.UserID = m_player.PlayerId;
				achievementDataInfo.AchievementID = achievementInfo.ID;
				achievementDataInfo.IsComplete = true;
				achievementDataInfo.CompletedDate = DateTime.Now;
				achievementDataInfo.IsDirty = true;
				lock (m_data)
				{
					m_data.Add(achievementDataInfo);
				}
				return true;
			}
			return false;
        }

        private bool IsAchievementFinish(AchievementInfo achievementInfo)
        {
			IEnumerable<AchievementDataInfo> enumerable = m_data.Where((AchievementDataInfo s) => s.AchievementID == achievementInfo.ID);
			if (enumerable != null)
			{
				return enumerable.ToList().Count > 0;
			}
			return false;
        }

        public void SaveToDatabase()
        {
			if (m_userRecord != null && m_userRecord.Count > 0)
			{
				lock (m_userRecord)
				{
					using PlayerBussiness playerBussiness = new PlayerBussiness();
					foreach (UsersRecordInfo item in m_userRecord)
					{
						if (item.IsDirty)
						{
							playerBussiness.UpdateDbUserRecord(item);
						}
					}
				}
			}
			if (m_data == null || m_data.Count <= 0)
			{
				return;
			}
			lock (m_data)
			{
				using PlayerBussiness playerBussiness2 = new PlayerBussiness();
				foreach (AchievementDataInfo datum in m_data)
				{
					if (datum.IsDirty)
					{
						playerBussiness2.UpdateDbAchievementDataInfo(datum);
					}
				}
			}
        }
    }
}
