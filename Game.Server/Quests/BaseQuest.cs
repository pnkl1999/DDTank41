using System;
using System.Collections.Generic;
using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class BaseQuest
	{

		private QuestDataInfo m_data;

		private QuestInfo m_info;

		private List<BaseCondition> m_list;

		private DateTime m_oldFinishDate;

		private GamePlayer m_player;

		public QuestDataInfo Data
		{
			get
			{
				return this.m_data;
			}
		}

		public QuestInfo Info
		{
			get
			{
				return this.m_info;
			}
		}

		public BaseQuest(QuestInfo info, QuestDataInfo data)
		{
			this.m_info = info;
			this.m_data = data;
			this.m_data.QuestID = this.m_info.ID;
			this.m_list = new List<BaseCondition>();
			List<QuestConditionInfo> questCondiction = QuestMgr.GetQuestCondiction(info);
			int num = 0;
			foreach (QuestConditionInfo current in questCondiction)
			{
				BaseCondition baseCondition = BaseCondition.CreateCondition(this, current, data.GetConditionValue(num++));
				if (baseCondition != null)
				{
					this.m_list.Add(baseCondition);
				}
			}
		}

		public void AddToPlayer(GamePlayer player)
		{
			this.m_player = player;
			if (!this.m_data.IsComplete)
			{
				this.AddTrigger(player);
			}
		}

		private void AddTrigger(GamePlayer gamePlayer_1)
		{
			foreach (BaseCondition baseCondition in this.m_list)
			{
				baseCondition.AddTrigger(gamePlayer_1);
			}
		}

		public bool CancelFinish(GamePlayer player)
		{
			this.m_data.IsComplete = false;
			this.m_data.CompletedDate = this.m_oldFinishDate;
			foreach (BaseCondition baseCondition in this.m_list)
			{
				baseCondition.CancelFinish(player);
			}
			return true;
		}

		public bool CanCompleted(GamePlayer player)
		{
			bool result;
			if (!this.m_data.IsComplete)
			{
				int num = this.m_info.NotMustCount;
				foreach (BaseCondition baseCondition in this.m_list)
				{
					if (!baseCondition.IsCompleted(player) && this.m_data.QuestID != 70)
					{
						if (!baseCondition.Info.isOpitional)
						{
							return false;
						}
					}
					else
					{
						num--;
					}
				}
				result = (num <= 0);
			}
			else
			{
				result = false;
			}
			return result;
		}

		public bool Finish(GamePlayer player)
		{
			bool result = false;
			if (this.CanCompleted(player))
			{
				int num = this.m_info.NotMustCount;
				foreach (BaseCondition baseCondition in this.m_list)
				{
					if(this.m_info.NotMustCount > 0)
                    {
						
						if (!baseCondition.Finish(player))
						{
							if (!baseCondition.Info.isOpitional)
								return false;
						}
						else
						{
							num--;
						}

						result = (num <= 0);
					} else
                    {
						result = true;
						if (!baseCondition.Finish(player))
						{
							return false;
						}
					}
					
				}

				if (!result)
				{
					return false;
				}

				if (!this.Info.CanRepeat)
				{
					this.m_data.IsComplete = true;
					this.RemveTrigger(player);
				}
				this.m_oldFinishDate = this.m_data.CompletedDate;
				this.m_data.CompletedDate = DateTime.Now;
				result = true;
			}
			else
			{
				result = false;
			}
			return result;
		}

		public BaseCondition GetConditionById(int id)
		{
			foreach (BaseCondition baseCondition in this.m_list)
			{
				if (baseCondition.Info.CondictionID == id)
				{
					return baseCondition;
				}
			}
			return null;
		}

		public void RemoveFromPlayer(GamePlayer player)
		{
			if (!this.m_data.IsComplete)
			{
				this.RemveTrigger(player);
			}
			this.m_player = null;
		}

		private void RemveTrigger(GamePlayer gamePlayer_1)
		{
			foreach (BaseCondition baseCondition in this.m_list)
			{
				baseCondition.RemoveTrigger(gamePlayer_1);
			}
		}

		public void Reset(GamePlayer player)
		{
			foreach (BaseCondition baseCondition in this.m_list)
			{
				baseCondition.Reset(player);
			}
		}

		public void CheckRepeat()
		{
			if ((DateTime.Now.Date - this.m_data.CompletedDate.Date).TotalDays >= (double)this.m_info.RepeatInterval && this.m_info.CanRepeat && this.m_info.RepeatInterval > 0)
			{
				this.m_data.RepeatFinish = this.m_info.RepeatMax;
			}
		}

		public void Reset(GamePlayer player, int rand)
		{
			this.m_data.QuestID = this.m_info.ID;
			this.m_data.UserID = player.PlayerId;
			this.m_data.IsComplete = false;
			this.m_data.IsExist = true;
			if (this.m_data.CompletedDate == DateTime.MinValue)
			{
				this.m_data.CompletedDate = DateTime.Now;
			}
			this.CheckRepeat();
			this.m_data.RandDobule = rand;
			if (!this.m_info.CanRepeat || player.QuestInventory.FindQuest(this.m_info.ID).Data != null)
			{
				foreach (BaseCondition baseCondition in this.m_list)
				{
					baseCondition.Reset(player);
				}
			}
			this.SaveData();
		}

		public void SaveData()
		{
			int index = 0;
			foreach (BaseCondition baseCondition in this.m_list)
			{
				this.m_data.SaveConditionValue(index++, baseCondition.Value);
			}
		}

		public void Update()
		{
			this.SaveData();
			if (this.m_data.IsDirty && this.m_player != null)
			{
				this.m_player.QuestInventory.Update(this);
			}
		}
	}
}
