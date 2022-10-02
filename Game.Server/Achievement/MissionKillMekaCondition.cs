using Game.Logic;

namespace Game.Server.Achievement
{
    public class MissionKillMekaCondition : BaseUserRecord
    {
        public MissionKillMekaCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.AfterKillingLiving += player_AfterKillingLiving;
        }

        private void player_AfterKillingLiving(AbstractGame game, int type, int id, bool isLiving, int demage, bool isSpanArea)
        {
			if (game.GameType == eGameType.Dungeon && !isLiving && type == 2 && (id == 6132 || id == 6141 || id == 6232 || id == 6241 || id == 6332 || id == 6341))
			{
				m_player.AchievementInventory.UpdateUserAchievement(m_type, 1);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.AfterKillingLiving -= player_AfterKillingLiving;
        }
    }
}
