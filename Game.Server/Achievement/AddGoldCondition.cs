namespace Game.Server.Achievement
{
    internal class AddGoldCondition : BaseUserRecord
    {
        public AddGoldCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.PlayerAddItem += player_PlayerAddItem;
        }

        private void player_PlayerAddItem(string type, int value)
        {
			if (type == "Gold")
			{
				m_player.AchievementInventory.UpdateUserAchievement(m_type, value);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.PlayerAddItem -= player_PlayerAddItem;
        }
    }
}
