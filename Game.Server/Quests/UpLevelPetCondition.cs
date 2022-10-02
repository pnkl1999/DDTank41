using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class UpLevelPetCondition : BaseCondition
    {
        public UpLevelPetCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.UpLevelPetEvent += player_MissionOver;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value >= m_info.Para2;
        }

        private void player_MissionOver()
        {
			base.Value = m_info.Para2;
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.UpLevelPetEvent -= player_MissionOver;
        }
    }
}
