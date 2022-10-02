namespace Game.Logic.Actions
{
    public class LivingUpdatePropertyAction : BaseAction
    {
        private Living living_0;

        private string string_0;

        private string string_1;

        public LivingUpdatePropertyAction(Living living, string type, string value, int delay)
			: base(delay)
        {
			living_0 = living;
			string_0 = type;
			string_1 = value;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			living_0.SetVisible(state: false);
			Finish(tick);
        }
    }
}
