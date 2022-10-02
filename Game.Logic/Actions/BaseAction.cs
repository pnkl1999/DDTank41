namespace Game.Logic.Actions
{
    public class BaseAction : IAction
    {
        private long m_finishDelay;

        private long m_finishTick;

        private long m_tick;

        public BaseAction(int delay)
			: this(delay, 0)
        {
        }

        public BaseAction(int delay, int finishDelay)
        {
			m_tick = TickHelper.GetTickCount() + delay;
			m_finishDelay = finishDelay;
			m_finishTick = long.MaxValue;
        }

        public void Execute(BaseGame game, long tick)
        {
			if (m_tick <= tick && m_finishTick == long.MaxValue)
			{
				ExecuteImp(game, tick);
			}
        }

        protected virtual void ExecuteImp(BaseGame game, long tick)
        {
			Finish(tick);
        }

        public void Finish(long tick)
        {
			m_finishTick = tick + m_finishDelay;
        }

        public bool IsFinished(long tick)
        {
			return m_finishTick <= tick;
        }
    }
}
