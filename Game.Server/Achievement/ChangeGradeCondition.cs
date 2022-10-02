namespace Game.Server.Achievement
{
    public class ChangeGradeCondition : BaseUserRecord
    {
        public ChangeGradeCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.LevelUp += player_LevelUp;
        }

        private void player_LevelUp(GamePlayer player)
        {
			m_player.AchievementInventory.UpdateUserAchievement(m_type, player.Level, 1);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.LevelUp -= player_LevelUp;
        }
    }
}
