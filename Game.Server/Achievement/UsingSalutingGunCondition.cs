namespace Game.Server.Achievement
{
    public class UsingSalutingGunCondition : BaseUserRecord
    {
        public UsingSalutingGunCondition(GamePlayer player, int type)
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
			if (templateID == 21002 || templateID == 21006 || templateID == 11463 || templateID == 11528 || templateID == 11539 || templateID == 11540 || templateID == 11542 || templateID == 11549 || templateID == 200337 || templateID == 170145)
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
