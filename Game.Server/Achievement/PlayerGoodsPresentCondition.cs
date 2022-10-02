namespace Game.Server.Achievement
{
    internal class PlayerGoodsPresentCondition : BaseUserRecord
    {
        public PlayerGoodsPresentCondition(GamePlayer player, int type)
			: base(player, type)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
        }

        private void player_PlayerGoodsPresent(int count)
        {
        }

        public override void RemoveTrigger(GamePlayer player)
        {
        }
    }
}
