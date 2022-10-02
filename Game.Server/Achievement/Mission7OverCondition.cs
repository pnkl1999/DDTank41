using Game.Logic;

namespace Game.Server.Achievement
{
    public class Mission7OverCondition : BaseUserRecord
    {
        public Mission7OverCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.MissionOver += player_MissionOver;
        }

        private void player_MissionOver(AbstractGame game, int missionId, bool isWin)
        {
			if (game.GameType == eGameType.FightLab && isWin && (missionId == 105 || missionId == 115 || missionId == 125))
			{
				m_player.AchievementInventory.UpdateUserAchievement(m_type, 1);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.MissionOver -= player_MissionOver;
        }
    }
}
