namespace Game.Server.Achievement
{
    public class HotSpringCondition : BaseUserRecord
    {
        public HotSpringCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.PlayerSpa += player_PlayerSpa;
        }

        private void player_PlayerSpa(int onlineTimeSpa)
        {
			m_player.AchievementInventory.UpdateUserAchievement(m_type, onlineTimeSpa);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.PlayerSpa -= player_PlayerSpa;
        }
    }
}
