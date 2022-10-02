using Game.Logic.Phy.Maths;
using Game.Logic.Phy.Object;
using System.Drawing;

namespace Game.Logic.Actions
{
    public class PlayerMoveAction : BaseAction
    {
        private bool m_isSend;

        private Player m_player;

        private Point m_target;

        private Point m_v;

        public PlayerMoveAction(Player player, Point target, int delay)
			: base(0, delay)
        {
			m_player = player;
			m_target = target;
			m_v = new Point(target.X - m_player.X, target.Y - m_player.Y);
			m_v.Normalize(20);
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			if (!m_isSend)
			{
				m_isSend = true;
				m_player.SpeedMultX(20, "speedX");
				game.SendPlayerMove(m_player, 4, m_target.X, m_target.Y, (byte)((m_v.X > 0) ? 1u : 255u), m_player.IsLiving, "");
			}
			if (m_target.Distance(m_player.X, m_player.Y) > 20.0)
			{
				m_player.SetXY(m_player.X + m_v.X, m_player.Y + m_v.Y);
				return;
			}
			m_player.SetXY(m_target.X, m_target.Y);
			Finish(tick);
        }
    }
}
