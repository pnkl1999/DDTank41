using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class CropPrimaryCondition : BaseCondition
    {
        public CropPrimaryCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.CropPrimaryEvent += player_CropPrimary;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value >= m_info.Para2;
        }

        private void player_CropPrimary()
        {
			if (base.Value < m_info.Para2)
			{
				base.Value++;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.CropPrimaryEvent -= player_CropPrimary;
        }
    }
}
