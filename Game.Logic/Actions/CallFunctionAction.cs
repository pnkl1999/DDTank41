using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.Actions
{
    public class CallFunctionAction : BaseAction
    {
        private LivingCallBackHandle m_func;

		private Living m_target;
        public CallFunctionAction(LivingCallBackHandle func, Living target, int delay)
			: base(delay)
        {
			m_func = func;
			m_target = target;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			try
			{
				m_func(m_target);
				//Console.WriteLine("func = {0}", m_func);
			}
			finally
			{
				Finish(tick);
			}
        }
    }
}
