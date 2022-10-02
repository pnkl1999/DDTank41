namespace Game.Logic.Actions
{
    public class LivingDieByBombAction : BaseAction
    {
        private Living living_0;

        private bool bool_0;

        public LivingDieByBombAction(Living living, int delay, bool sendClient)
			: base(delay, 1000)
        {
			living_0 = living;
			bool_0 = sendClient;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			living_0.OnDieByBomb();
			Finish(tick);
        }
    }
}
