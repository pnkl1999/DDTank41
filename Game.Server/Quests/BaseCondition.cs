using log4net;
using SqlDataProvider.Data;
using System.Reflection;

namespace Game.Server.Quests
{
	public class BaseCondition
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		protected QuestConditionInfo m_info;

		private BaseQuest m_quest;

		private int m_value;

		public QuestConditionInfo Info => m_info;

		public int Value
		{
			get
			{
				return m_value;
			}
			set
			{
				if (m_value != value)
				{
					m_value = value;
					m_quest.Update();
				}
			}
		}

		public BaseCondition(BaseQuest quest, QuestConditionInfo info, int value)
		{
			m_quest = quest;
			m_info = info;
			m_value = value;
		}

		public virtual void AddTrigger(GamePlayer player)
		{
		}

		public virtual bool CancelFinish(GamePlayer player)
		{
			return true;
		}

		public static BaseCondition CreateCondition(BaseQuest quest, QuestConditionInfo info, int value)
		{
			switch (info.CondictionType)
			{
				case 1:
					return new OwnGradeCondition(quest, info, value);
				case 2:
					return new ItemMountingCondition(quest, info, value);
				case 3:
					return new UsingItemCondition(quest, info, value);
				case 4:
					return new GameKillByRoomCondition(quest, info, value);
				case 5:
					return new GameFightByRoomCondition(quest, info, value);
				case 6:
					return new GameOverByRoomCondition(quest, info, value);
				case 7:
					return new GameCopyOverCondition(quest, info, value);
				case 8:
					return new GameCopyPassCondition(quest, info, value);
				case 9:
					return new ItemStrengthenCondition(quest, info, value);
				case 10:
					return new ShopCondition(quest, info, value);
				case 11:
					return new ItemFusionCondition(quest, info, value);
				case 12:
					return new ItemMeltCondition(quest, info, value);
				case 13:
					return new GameMonsterCondition(quest, info, value);
				case 14:
					return new OwnPropertyCondition(quest, info, value);
				case 15:
					return new TurnPropertyCondition(quest, info, value);
				case 16:
					return new DirectFinishCondition(quest, info, value);
				case 17:
					return new OwnMarryCondition(quest, info, value);
				case 18:
					return new OwnConsortiaCondition(quest, info, value);
				case 19:
					return new ItemComposeCondition(quest, info, value);
				case 20:
					return new ClientModifyCondition(quest, info, value);
				case 21:
					return new GameMissionOverCondition(quest, info, value);
				case 22:
					return new GameKillByGameCondition(quest, info, value);
				case 23:
					return new GameFightByGameCondition(quest, info, value);
				case 24:
					return new GameOverByGameCondition(quest, info, value);
				case 25:
					return new ItemInsertCondition(quest, info, value);
				case 26:
					return new MarryCondition(quest, info, value);
				case 27:
					return new EnterSpaCondition(quest, info, value);
				case 28:
					return new FightWifeHusbandCondition(quest, info, value);
				case 29:
					return new AchievementCondition(quest, info, value);
				case 30:
					return new GameFight2v2Condition(quest, info, value);
				case 31:
					return new GameFightByGameCondition(quest, info, value);
				case 32:
					return new SharePersonalStatusCondition(quest, info, value);
				case 33:
					return new SendGiftForFriendCondition(quest, info, value);
				case 34:
					return new GameFight2v2Condition(quest, info, value);
				case 35:
					return new AcademyEventCondition(quest, info, 1, value);
				case 36:
					return new GameFightApprenticeshipCondition(quest, info, value);
				case 37:
					return new GameFightMasterApprenticeshipCondition(quest, info, value);
				case 38:
					return new CashCondition(quest, info, value);
				case 39:
					return new NewGearCondition(quest, info, value);
				case 40:
					return new AcademyEventCondition(quest, info, 0, value);
				case 42:
					return new AccuontInfoCondition(quest, info, value);
				case 43:
					return new LoginMissionPurpleCondition(quest, info, value);
				case 44:
					return new SetPasswordTwoCondition(quest, info, value);
				case 45:
					return new FightWithPetCondition(quest, info, value);
				case 46:
					return new CombiePetFeedCondition(quest, info, value);
				case 47:
					return new FriendFarmCondition(quest, info, value);
				case 48:
					return new AdoptPetCondition(quest, info, value);
				case 49:
					return new CropPrimaryCondition(quest, info, value);
				case 50:
					return new UpLevelPetCondition(quest, info, value);
				case 51:
					return new SeedFoodPetCondition(quest, info, value);
				case 52:
					return new UserSkillPetCondition(quest, info, value);
				case 54:
					return new UserToemGemstoneCondition(quest, info, value);
				//case 100:
				//	return new PlayerOnlineTimeCondiction(quest, info, value);
				//case 102:
				//	return new PlayerOnlineSpaCondiction(quest, info, value);
				default:
					if (log.IsErrorEnabled)
					{
						log.Error($"Can't find quest condition : {info.CondictionType}");
					}
					return new UnknowQuestCondition(quest, info, value);
			}
		}

		public virtual bool Finish(GamePlayer player)
		{
			return true;
		}

		public virtual bool IsCompleted(GamePlayer player)
		{
			return false;
		}

		public virtual void RemoveTrigger(GamePlayer player)
		{
		}

		public virtual void Reset(GamePlayer player)
		{
			m_value = m_info.Para2;
		}
	}
}
