using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class ShopCondition : BaseCondition
	{
		public ShopCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.Paid += player_Shop;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value <= 0;
		}

		private void player_Shop(int money, int gold, int offer, int gifttoken, int petScore, int medal, int damageScores, string payGoods)
		{
			if (m_info.Para1 == -1 && money > 0)
			{
				base.Value -= money;
			}
			if (m_info.Para1 == -2 && gold > 0)
			{
				base.Value -= gold;
			}
			if (m_info.Para1 == -3 && offer > 0)
			{
				base.Value -= offer;
			}
			if (m_info.Para1 == -4 && gifttoken > 0)
			{
				base.Value -= gifttoken;
			}
			if (m_info.Para1 == -8 && petScore > 0)
			{
				base.Value -= petScore;
			}
			string[] array = payGoods.Split(',');
			for (int i = 0; i < array.Length; i++)
			{
				if (array[i] == m_info.Para1.ToString())
				{
					base.Value--;
				}
			}
			if (base.Value < 0)
			{
				base.Value = 0;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.Paid -= player_Shop;
		}
	}
}
