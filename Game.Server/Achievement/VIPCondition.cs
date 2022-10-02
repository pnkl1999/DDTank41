namespace Game.Server.Achievement
{
    internal class VIPCondition : BaseUserRecord
    {
        public VIPCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.Event_0 += player_PlayerVIPUpgrade;
        }

        private void player_PlayerVIPUpgrade(int level, int exp)
        {
			m_player.AchievementInventory.UpdateUserAchievement(m_type, level, 1);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.Event_0 -= player_PlayerVIPUpgrade;
        }
    }
}
