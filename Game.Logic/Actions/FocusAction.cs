using Game.Logic.Phy.Object;

namespace Game.Logic.Actions
{
    public class FocusAction : BaseAction
    {
        private Physics Obj;

        private int Type;

        public FocusAction(Physics obj, int type, int delay, int finishTime)
			: base(delay, finishTime)
        {
			Obj = obj;
			Type = type;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			game.SendPhysicalObjFocus(Obj, Type);
			Finish(tick);
        }
    }
}
