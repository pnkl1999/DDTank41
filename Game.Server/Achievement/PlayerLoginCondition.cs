namespace Game.Server.Achievement
{
    public class PlayerLoginCondition : BaseUserRecord
    {
        public PlayerLoginCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.PlayerLogin += player_Login;
        }

        private void player_Login()
        {
			m_player.AchievementInventory.UpdateUserAchievement(m_type, 1);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.PlayerLogin -= player_Login;
        }
    }
}
