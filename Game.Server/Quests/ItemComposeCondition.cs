using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class ItemComposeCondition : BaseCondition
    {
        public ItemComposeCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.ItemCompose += player_ItemCompose;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_ItemCompose(int templateID)
        {
			if (templateID == m_info.Para1 && base.Value > 0)
			{
				base.Value--;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.ItemCompose -= player_ItemCompose;
        }
    }
}
