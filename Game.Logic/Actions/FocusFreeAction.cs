namespace Game.Logic.Actions
{
    public class FocusFreeAction : BaseAction
    {
        private int int_0;

        private int int_1;

        private int int_2;

        public FocusFreeAction(int x, int y, int type, int delay, int finishTime)
			: base(delay, finishTime)
        {
			int_0 = x;
			int_1 = y;
			int_2 = type;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			game.method_10(int_0, int_1, int_2);
			Finish(tick);
        }
    }
}
