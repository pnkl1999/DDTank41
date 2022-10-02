namespace Game.Logic.Actions
{
    public class LivingDirectSetXYAction : BaseAction
    {
        private Living m_living;

        private int m_x;

        private int m_y;

        public LivingDirectSetXYAction(Living living, int x, int y, int delay)
			: base(delay)
        {
			m_living = living;
			m_x = x;
			m_y = y;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			m_living.SetXY(m_x, m_y);
			Finish(tick);
        }
    }
}
