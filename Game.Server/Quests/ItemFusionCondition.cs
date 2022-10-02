using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class ItemFusionCondition : BaseCondition
    {
        public ItemFusionCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.ItemFusion += player_ItemFusion;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_ItemFusion(int fusionType)
        {
			if (fusionType == m_info.Para1 && base.Value > 0)
			{
				base.Value--;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.ItemFusion -= player_ItemFusion;
        }
    }
}
