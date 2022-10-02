using Game.Logic;

namespace Game.Server.Achievement
{
    public class StartMissionCondition : BaseUserRecord
    {
        public StartMissionCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.MissionTurnOver += player_MissionTurnOver;
        }

        private void player_MissionTurnOver(AbstractGame game, int missionId, int turnNum)
        {
			if (game.RoomType != eRoomType.Freshman && game.RoomType != eRoomType.FightLab)
			{
				m_player.missionPlayed++;
				if (m_player.missionPlayed == 2)
				{
					m_player.AchievementInventory.UpdateUserAchievement(m_type, 1);
				}
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.MissionTurnOver -= player_MissionTurnOver;
        }
    }
}
