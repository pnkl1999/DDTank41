using Game.Logic;

namespace Game.Server.RingStation.Action
{
    public class BaseAction : IAction
    {
        private long m_finishDelay;

        private long m_finishTick;

        private long m_tick;

        public BaseAction(int delay) : this(delay, 0)
        {
        }

        public BaseAction(int delay, int finishDelay)
        {
            m_tick = TickHelper.GetTickCount() + delay;
            m_finishDelay = finishDelay;
            m_finishTick = 9223372036854775807L;
        }

        public void Execute(VirtualGamePlayer player, long tick)
        {
            if (m_tick <= tick && m_finishTick == 9223372036854775807L)
            {
                ExecuteImp(player, tick);
            }
        }

        protected virtual void ExecuteImp(VirtualGamePlayer player, long tick)
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