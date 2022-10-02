using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class AchievementCondition : BaseCondition
    {
        public AchievementCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.AchievementQuest += player_AchievementQuest;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_AchievementQuest()
        {
			base.Value--;
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.AchievementQuest -= player_AchievementQuest;
        }
    }
}
