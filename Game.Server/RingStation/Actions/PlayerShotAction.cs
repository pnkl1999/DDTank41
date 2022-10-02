namespace Game.Server.RingStation.Action
{
    public class PlayerShotAction : BaseAction
    {
        private int m_angle;

        private int m_force;

        private int m_x;

        private int m_y;

        public PlayerShotAction(int x, int y, int force, int angle, int delay) : base(delay, 0)
        {
            m_x = x;
            m_y = y;
            m_force = force;
            m_angle = angle;
        }

        protected override void ExecuteImp(VirtualGamePlayer player, long tick)
        {
            player.SendShootTag(true, 0);
            player.SendGameCMDShoot(m_x, m_y, m_force, m_angle);
            Finish(tick);
        }
    }
}