namespace Game.Server.Achievement
{
    public class OwnAddBloodGunCondition : BaseUserRecord
    {
        public OwnAddBloodGunCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			m_player.AchievementInventory.UpdateUserAchievement(m_type, player.GetItemCount(17002));
        }
    }
}
