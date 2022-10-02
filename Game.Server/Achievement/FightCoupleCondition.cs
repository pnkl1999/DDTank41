using Game.Logic;

namespace Game.Server.Achievement
{
    public class FightCoupleCondition : BaseUserRecord
    {
        public FightCoupleCondition(GamePlayer player, int type)
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
			if ((game.GameType == eGameType.Free || game.GameType == eGameType.Guild) && isWin && isCouple)
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
