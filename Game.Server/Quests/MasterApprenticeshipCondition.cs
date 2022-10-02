using Game.Logic;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class MasterApprenticeshipCondition : BaseCondition
    {
        public MasterApprenticeshipCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_MissionOver(AbstractGame game, int missionId, int turnCount)
        {
        }

        public override void RemoveTrigger(GamePlayer player)
        {
        }
    }
}
