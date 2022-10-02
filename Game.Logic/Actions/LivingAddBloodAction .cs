namespace Game.Logic.Actions
{
    public class LivingAddBloodAction : BaseAction
    {
        private Living m_owner;

        private int m_blood;

        private int m_type;
        public LivingAddBloodAction(Living owner, int blood, int type, int delay)
			: base(delay, 0)
        {
            m_owner = owner;
            m_blood = blood;
            m_type = type;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			m_owner.AddBlood(m_blood, m_type);
			Finish(tick);
        }
    }
}
