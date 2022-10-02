using Game.Logic;

namespace Game.Server.Achievement
{
    public class MissionKillThirdTerrorKingCondition : BaseUserRecord
    {
        public MissionKillThirdTerrorKingCondition(GamePlayer player, int type)
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
            if (game.GameType == eGameType.Dungeon && !isLiving && type == 2 && id == 3308 && id == 3309 && id != 3301 && id != 3302 && id != 3303 && id != 3304 && id != 3305 && id != 3306)
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
