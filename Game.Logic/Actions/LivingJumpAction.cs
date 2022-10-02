using Game.Logic.Phy.Object;

namespace Game.Logic.Actions
{
    public class LivingJumpAction : BaseAction
    {
        private string m_action;

        private LivingCallBack m_callback;

        private bool m_isSent;

        private Living m_living;

        private int m_speed;

        private int m_toX;

        private int m_toY;

        private int m_type;

        public LivingJumpAction(Living living, int toX, int toY, int speed, string action, int delay, int type, LivingCallBack callback)
			: base(delay, 2000)
        {
			m_living = living;
			m_toX = toX;
			m_toY = toY;
			m_speed = speed;
			m_action = action;
			m_isSent = false;
			m_type = type;
			m_callback = callback;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			if (!m_isSent)
			{
				m_isSent = true;
				game.SendLivingJump(m_living, m_toX, m_toY, m_speed, m_action, m_type);
			}
			if (m_toY < m_living.Y - m_speed)
			{
				m_living.SetXY(m_toX, m_living.Y - m_speed);
				return;
			}
			m_living.SetXY(m_toX, m_toY);
			if (m_callback != null)
			{
				m_living.CallFuction(m_callback, 0);
			}
			Finish(tick);
        }
    }
}
