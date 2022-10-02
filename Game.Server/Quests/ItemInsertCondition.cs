using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class ItemInsertCondition : BaseCondition
    {
        public ItemInsertCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.ItemInsert += player_ItemInsert;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_ItemInsert()
        {
			if (base.Value > 0)
			{
				base.Value--;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.ItemInsert -= player_ItemInsert;
        }
    }
}
