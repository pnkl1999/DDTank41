namespace Game.Logic.Actions
{
    public class LivingCreateChildAction : BaseAction
    {
        private Living m_living;

        private int m_type;

        public LivingCreateChildAction(Living living, int type, int delay)
			: base(delay)
        {
			m_living = living;
			m_type = type;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			Finish(tick);
        }
    }
}
