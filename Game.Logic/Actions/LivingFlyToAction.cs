using Game.Logic.Phy.Object;
using System.Collections.Generic;
using System.Drawing;

namespace Game.Logic.Actions
{
    public class LivingFlyToAction : BaseAction
    {
        private string m_action;

        private LivingCallBack m_callback;

        private int m_fromX;

        private int m_fromY;

        private bool m_isSent;

        private Living m_living;

        private List<Point> m_path;

        private int m_speed;

        private int m_toX;

        private int m_toY;

        public LivingFlyToAction(Living living, int fromX, int fromY, int toX, int toY, string action, int delay, int speed, LivingCallBack callback)
			: base(delay, 0)
        {
			m_living = living;
			m_action = action;
			m_speed = speed;
			m_toX = toX;
			m_toY = toY;
			m_fromX = fromX;
			m_fromY = fromY;
			m_isSent = false;
			m_callback = callback;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			if (!m_isSent)
			{
				m_isSent = true;
				game.SendLivingMoveTo(m_living, m_fromX, m_fromY, m_toX, m_toY, m_action, m_speed);
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
