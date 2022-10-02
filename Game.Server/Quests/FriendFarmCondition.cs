using Game.Logic;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class FriendFarmCondition : BaseCondition
    {
        public FriendFarmCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			base.Value = m_info.Para2;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value >= m_info.Para2;
        }

        private void player_MissionOver(AbstractGame game, int missionId, int turnCount)
        {
        }

        public override void RemoveTrigger(GamePlayer player)
        {
        }
    }
}
