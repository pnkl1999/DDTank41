namespace Game.Server.Achievement
{
    public class ItemStrengthenCondition : BaseUserRecord
    {
        public ItemStrengthenCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.ItemStrengthen += player_ItemStrengthen;
        }

        private void player_ItemStrengthen(int categoryID, int level)
        {
			m_player.AchievementInventory.UpdateUserAchievement(m_type, level, 1);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.ItemStrengthen -= player_ItemStrengthen;
        }
    }
}
