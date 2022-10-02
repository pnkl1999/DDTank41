using Game.Logic;

namespace Game.Server.Achievement
{
    public class FightOneBloodIsWinCondition : BaseUserRecord
    {
        public FightOneBloodIsWinCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.FightOneBloodIsWin += player_OneBloodIsWin;
        }

        private void player_OneBloodIsWin(eRoomType roomType, bool isWin)
        {
			if (roomType == eRoomType.Match && isWin)
			{
				m_player.AchievementInventory.UpdateUserAchievement(m_type, 1);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.FightOneBloodIsWin -= player_OneBloodIsWin;
        }
    }
}
