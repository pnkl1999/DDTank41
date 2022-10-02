namespace Game.Logic.Actions
{
    public class LivingPlayeMovieAction : BaseAction
    {
        private Living living_0;

        private string string_0;

        public LivingPlayeMovieAction(Living living, string action, int delay, int movieTime)
			: base(delay, movieTime)
        {
			living_0 = living;
			string_0 = action;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			game.SendLivingPlayMovie(living_0, string_0);
			Finish(tick);
        }
    }
}
