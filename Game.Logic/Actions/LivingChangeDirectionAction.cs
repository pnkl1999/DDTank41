namespace Game.Logic.Actions
{
    public class LivingChangeDirectionAction : BaseAction
    {
        private Living m_Living;

        private int m_direction;

        public LivingChangeDirectionAction(Living living, int direction, int delay)
			: base(delay)
        {
			m_Living = living;
			m_direction = direction;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			m_Living.Direction = m_direction;
			Finish(tick);
        }
    }
}
