namespace Game.Server.Achievement
{
    public class FightDispatchesCondition : BaseUserRecord
    {
        public FightDispatchesCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.PlayerDispatches += player_PlayerDispatches;
        }

        private void player_PlayerDispatches()
        {
			m_player.AchievementInventory.UpdateUserAchievement(m_type, 1);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.PlayerDispatches -= player_PlayerDispatches;
        }
    }
}
