using Game.Logic.Phy.Object;

namespace Game.Logic.Actions
{
    public class WaitLivingAttackingAction : BaseAction
    {
        private TurnedLiving m_living;

        private int m_turnIndex;

        public WaitLivingAttackingAction(TurnedLiving living, int turnIndex, int delay)
			: base(delay)
        {
			m_living = living;
			m_turnIndex = turnIndex;
			living.EndAttacking += player_EndAttacking;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			Finish(tick);
			if (game.TurnIndex == m_turnIndex && m_living.IsAttacking)
			{
				m_living.StopAttacking();
				game.CheckState(0);
			}
        }

        private void player_EndAttacking(Living player)
        {
			player.EndAttacking -= player_EndAttacking;
			Finish(TickHelper.GetTickCount());
        }
    }
}
