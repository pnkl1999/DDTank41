namespace Game.Logic.Actions
{
    public class LivingBeforeShootedAction : BaseAction
    {
        private Living VrtQboWger;

        private Living living_1;

        public LivingBeforeShootedAction(Living owner, Living living, int delay)
			: base(delay, 0)
        {
			VrtQboWger = living;
			living_1 = owner;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			VrtQboWger.OnBeforeTakedBomb();
			Finish(tick);
        }
    }
}
