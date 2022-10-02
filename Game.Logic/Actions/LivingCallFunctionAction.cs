using Game.Logic.Phy.Object;

namespace Game.Logic.Actions
{
    public class LivingCallFunctionAction : BaseAction
    {
        private Living living_0;

        private LivingCallBack livingCallBack_0;

        public LivingCallFunctionAction(Living living, LivingCallBack func, int delay)
			: base(delay)
        {
			living_0 = living;
			livingCallBack_0 = func;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			try
			{
				livingCallBack_0();
			}
			finally
			{
				Finish(tick);
			}
        }
    }
}
