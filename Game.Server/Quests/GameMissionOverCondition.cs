using Game.Logic;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class GameMissionOverCondition : BaseCondition
    {
        public GameMissionOverCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.MissionTurnOver += player_MissionOver;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_MissionOver(AbstractGame game, int missionId, int turnCount)
        {
			if ((missionId == m_info.Para1 || m_info.Para1 == -1) && turnCount <= m_info.Para2 && base.Value > 0)
			{
				base.Value = 0;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.MissionTurnOver -= player_MissionOver;
        }
    }
}
