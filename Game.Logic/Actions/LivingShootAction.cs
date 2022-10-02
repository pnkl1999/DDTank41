using Game.Logic.Phy.Object;

namespace Game.Logic.Actions
{
    public class LivingShootAction : BaseAction
    {
        private LivingCallBack m_callBack;

        private int m_angle;

        private int m_bombCount;

        private int m_bombId;

        private int m_force;

        private Living m_living;

        private int m_maxTime;

        private int m_minTime;

        private float m_Time;

        private int m_tx;

        private int m_ty;

        public LivingShootAction(Living living, int bombId, int x, int y, int force, int angle, int bombCount, int minTime, int maxTime, float time, int delay)
			: base(delay, 1000)
        {
			m_living = living;
			m_bombId = bombId;
			m_tx = x;
			m_ty = y;
			m_force = force;
			m_angle = angle;
			m_bombCount = bombCount;
			m_bombId = bombId;
			m_minTime = minTime;
			m_maxTime = maxTime;
			m_Time = time;
        }

        public LivingShootAction(Living living, int bombId, int x, int y, int force, int angle, int bombCount, int minTime, int maxTime, float time, int delay, LivingCallBack callBack)
			: base(delay, 1000)
        {
			m_living = living;
			m_bombId = bombId;
			m_tx = x;
			m_ty = y;
			m_force = force;
			m_angle = angle;
			m_bombCount = bombCount;
			m_bombId = bombId;
			m_minTime = minTime;
			m_maxTime = maxTime;
			m_Time = time;
			m_callBack = callBack;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			if (m_living is SimpleBoss || m_living is SimpleNpc)
			{
				m_living.GetShootForceAndAngle(ref m_tx, ref m_ty, m_bombId, m_minTime, m_maxTime, m_bombCount, m_Time, ref m_force, ref m_angle);
			}
			if (m_living is Player && m_minTime == 1001 && m_maxTime == 10001)
			{
				m_living.GetShootForceAndAngle(ref m_tx, ref m_ty, m_bombId, m_minTime, m_maxTime, m_bombCount, m_Time, ref m_force, ref m_angle);
			}
			if (m_living.ShootImp(m_bombId, m_tx, m_ty, m_force, m_angle, m_bombCount, 0) && m_callBack != null)
			{
				m_living.CallFuction(m_callBack, m_living.LastLifeTimeShoot);
			}
			Finish(tick);
        }
    }
}
