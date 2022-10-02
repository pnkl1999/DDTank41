namespace Game.Server.Achievement
{
    public class MarryApplyReplyCondition : BaseUserRecord
    {
        public MarryApplyReplyCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.PlayerMarry += player_PlayerMarry;
        }

        private void player_PlayerMarry()
        {
			m_player.AchievementInventory.UpdateUserAchievement(m_type, 1);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.PlayerMarry -= player_PlayerMarry;
        }
    }
}
