using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class UserToemGemstoneCondition : BaseCondition
    {
        public UserToemGemstoneCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.UserToemGemstonetEvent += player_UserToemGemstonet;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_UserToemGemstonet()
        {
			if (base.Value > 0)
			{
				base.Value--;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.UserToemGemstonetEvent -= player_UserToemGemstonet;
        }
    }
}
