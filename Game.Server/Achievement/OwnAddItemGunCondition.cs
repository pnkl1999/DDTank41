using Game.Logic;

namespace Game.Server.Achievement
{
    public class OwnAddItemGunCondition : BaseUserRecord
    {
        public OwnAddItemGunCondition(GamePlayer player, int type)
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
			int num = 0;
			num += m_player.GetItemCount(7015);
			num += m_player.GetItemCount(7016);
			num += m_player.GetItemCount(7017);
			num += m_player.GetItemCount(7018);
			num += m_player.GetItemCount(7019);
			num += m_player.GetItemCount(7020);
			num += m_player.GetItemCount(7021);
			num += m_player.GetItemCount(7022);
			num += m_player.GetItemCount(7023);
			m_player.AchievementInventory.UpdateUserAchievement(m_type, num);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.AfterKillingLiving -= player_AfterKillingLiving;
        }
    }
}
