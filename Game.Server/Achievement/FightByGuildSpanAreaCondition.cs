using Game.Logic;

namespace Game.Server.Achievement
{
    public class FightByGuildSpanAreaCondition : BaseUserRecord
    {
        public FightByGuildSpanAreaCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.GameOver += player_GameOver;
        }

        private void player_GameOver(AbstractGame game, bool isWin, int gainXp, bool isSpanArea, bool isCouple)
        {
			if (game.GameType == eGameType.Guild && isWin && isSpanArea)
			{
				m_player.AchievementInventory.UpdateUserAchievement(m_type, 1);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.GameOver -= player_GameOver;
        }
    }
}
