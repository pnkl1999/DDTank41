namespace Game.Server.Achievement
{
    internal class FightAddOfferCondition : BaseUserRecord
    {
        public FightAddOfferCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.FightAddOfferEvent += player_FightAddOfferEvent;
        }

        private void player_FightAddOfferEvent(int offer)
        {
			m_player.AchievementInventory.UpdateUserAchievement(m_type, offer);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.FightAddOfferEvent -= player_FightAddOfferEvent;
        }
    }
}
