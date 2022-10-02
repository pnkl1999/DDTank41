namespace Game.Logic.Actions
{
    public class LivingSayAction : BaseAction
    {
        private Living m_living;

        private string m_msg;

        private int m_type;

        public LivingSayAction(Living living, string msg, int type, int delay, int finishTime)
			: base(delay, finishTime)
        {
			m_living = living;
			m_msg = msg;
			m_type = type;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			game.SendLivingSay(m_living, m_msg, m_type);
			Finish(tick);
        }
    }
}
