using Game.Logic;

namespace Game.Server.Achievement
{
    public class Mission9OverCondition : BaseUserRecord
    {
        public Mission9OverCondition(GamePlayer player, int type)
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
			if (game.GameType == eGameType.Dungeon && isWin && (missionId == 4103 || missionId == 4203 || missionId == 4303))
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
