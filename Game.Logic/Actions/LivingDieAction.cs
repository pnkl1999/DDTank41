namespace Game.Logic.Actions
{
    public class LivingDieAction : BaseAction
    {
        private Living living_0;

        private bool bool_0;

        public LivingDieAction(Living living, int delay, bool sendClient)
			: base(delay, 1000)
        {
			living_0 = living;
			bool_0 = sendClient;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			living_0.Die(bool_0);
            //living_0.OnDie();
			Finish(tick);
        }
    }
}
