namespace Game.Logic.Actions
{
    public class LivingRotateTurnAction : BaseAction
    {
        private Living m_living;

        private int m_speed;

        private int m_angle;

        private string m_endPlay;

        public LivingRotateTurnAction(Living living, int angle, int speed, string endPlay, int delay)
			: base(0, delay)
        {
			m_living = living;
			m_speed = speed;
			m_angle = angle;
			m_endPlay = endPlay;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			game.LivingChangeAngle(m_living, m_speed, m_angle, m_endPlay);
			Finish(tick);
        }
    }
}
