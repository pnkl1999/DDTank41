using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class ItemMeltCondition : BaseCondition
    {
        public ItemMeltCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.ItemMelt += player_ItemMelt;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_ItemMelt(int categoryID)
        {
			if (categoryID == m_info.Para1)
			{
				base.Value = 0;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.ItemMelt -= player_ItemMelt;
        }
    }
}
