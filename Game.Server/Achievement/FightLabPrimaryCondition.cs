using Game.Logic;

namespace Game.Server.Achievement
{
    public class FightLabPrimaryCondition : BaseUserRecord
    {
        public FightLabPrimaryCondition(GamePlayer player, int type)
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
			if (game.GameType == eGameType.FightLab && isWin && (missionId == 101 || missionId == 111 || missionId == 121))
			{
				m_player.AchievementInventory.UpdateUserAchievement(m_type, 5, 1);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.MissionOver -= player_MissionOver;
        }
    }
}
