namespace Game.Logic.Actions
{
    public class LivingBoltMoveAction : BaseAction
    {
        private Living living_0;

        private int int_0;

        private int int_1;

        public LivingBoltMoveAction(Living living, int x, int y, int delay)
			: base(delay)
        {
			living_0 = living;
			int_0 = x;
			int_1 = y;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			living_0.SetXY(int_0, int_1);
			game.SendLivingBoltMove(living_0);
			Finish(tick);
        }
    }
}
