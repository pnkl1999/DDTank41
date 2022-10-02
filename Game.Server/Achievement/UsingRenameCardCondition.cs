namespace Game.Server.Achievement
{
    public class UsingRenameCardCondition : BaseUserRecord
    {
        public UsingRenameCardCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.AfterUsingItem += player_AfterUsingItem;
        }

        private void player_AfterUsingItem(int templateID, int count)
        {
			if (templateID == 11994)
			{
				m_player.AchievementInventory.UpdateUserAchievement(m_type, 1);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.AfterUsingItem -= player_AfterUsingItem;
        }
    }
}
