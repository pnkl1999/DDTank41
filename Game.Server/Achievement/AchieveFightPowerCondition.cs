namespace Game.Server.Achievement
{
    public class AchieveFightPowerCondition : BaseUserRecord
    {
        public AchieveFightPowerCondition(GamePlayer player, int type)
			: base(player, type)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.ItemStrengthen += player_ItemStrengthen;
        }

        private void player_ItemStrengthen(int categoryID, int level)
        {
			m_player.AchievementInventory.UpdateUserAchievement(m_type, 1);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.ItemStrengthen -= player_ItemStrengthen;
        }
    }
}
