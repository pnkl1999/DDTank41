namespace Game.Logic.Actions
{
    public class LivingAfterShootedFrozen : BaseAction
    {
        private Living living_0;

        public LivingAfterShootedFrozen(Living living, int delay)
			: base(delay, 0)
        {
			living_0 = living;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			living_0.OnAfterTakedFrozen();
			Finish(tick);
        }
    }
}
