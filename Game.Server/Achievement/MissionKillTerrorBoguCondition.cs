using Game.Logic;

namespace Game.Server.Achievement
{
    public class MissionKillTerrorBoguCondition : BaseUserRecord
    {
        public MissionKillTerrorBoguCondition(GamePlayer player, int type)
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
			if (game.GameType == eGameType.Dungeon && !isLiving && type == 2 && id == 1303)
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
