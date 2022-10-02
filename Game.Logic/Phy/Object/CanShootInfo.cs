namespace Game.Logic.Phy.Object
{
    public class CanShootInfo
    {
        private int m_angle;

        private bool m_canShoot;

        private int m_force;

        public int Angle=> m_angle;

        public bool CanShoot=> m_canShoot;

        public int Force=> m_force;

        public CanShootInfo(bool canShoot, int force, int angle)
        {
			m_canShoot = canShoot;
			m_force = force;
			m_angle = angle;
        }
    }
}
