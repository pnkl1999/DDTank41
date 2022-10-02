namespace Game.Logic.Actions
{
    public class LivingAfterShootedAction : BaseAction
    {
        private Living VrtQboWger;

        private Living living_1;

        public LivingAfterShootedAction(Living owner, Living living, int delay)
			: base(delay, 0)
        {
			VrtQboWger = living;
			living_1 = owner;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			VrtQboWger.OnAfterTakedBomb();
			VrtQboWger.OnAfterTakeDamage(living_1);
			Finish(tick);
        }
    }
}
