namespace Game.Logic.Actions
{
    public class LivingBeatAction : BaseAction
    {
        private string m_action;

        private int m_attackEffect;

        private int m_criticalAmount;

        private int m_demageAmount;

        private Living m_living;

        private int m_livingCount;

        private Living m_target;

        public LivingBeatAction(Living living, Living target, int demageAmount, int criticalAmount, string action, int delay, int livingCount, int attackEffect)
			: base(delay)
        {
			m_living = living;
			m_target = target;
			m_demageAmount = demageAmount;
			m_criticalAmount = criticalAmount;
			m_action = action;
			m_livingCount = livingCount;
			m_attackEffect = attackEffect;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			m_target.SyncAtTime = false;
			try
			{
				if (m_target.TakeDamage(m_living, ref m_demageAmount, ref m_criticalAmount, "LivingFire"))
				{
					int totalDemageAmount = m_demageAmount + m_criticalAmount;
					game.SendLivingBeat(m_living, m_target, totalDemageAmount, m_action, m_livingCount, m_attackEffect);
				}
				m_target.IsFrost = false;
				Finish(tick);
			}
			finally
			{
				m_target.SyncAtTime = true;
			}
        }
    }
}
