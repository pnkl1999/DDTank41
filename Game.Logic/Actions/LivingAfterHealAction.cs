namespace Game.Logic.Actions
{
    public class LivingAfterHealAction : BaseAction
    {
        private Living m_owner;

        private Living m_target;

        private int m_blood;
        public LivingAfterHealAction(Living owner, Living target, int blood, int delay)
			: base(delay, 0)
        {
            m_owner = owner;
            m_target = target;
            m_blood = blood;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			m_target.OnHeal(m_blood);
			Finish(tick);
        }
    }
}
