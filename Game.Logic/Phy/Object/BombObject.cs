using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Maths;
using System;
using System.Drawing;

namespace Game.Logic.Phy.Object
{
    public class BombObject : Physics
    {
        private float m_airResitFactor;

        private float m_arf;

        private float m_gf;

        private float m_gravityFactor;

        private float m_mass;

        private EulerVector m_vx;

        private EulerVector m_vy;

        private float m_wf;

        private float m_windFactor;

        public float Arf=> m_arf;

        public float Gf=> m_gf;

        public float vX=> m_vx.x1;

        public float vY=> m_vy.x1;

        public float Wf=> m_wf;

        public BombObject(int id, float mass, float gravityFactor, float windFactor, float airResitFactor)
			: base(id)
        {
			m_mass = mass;
			m_gravityFactor = gravityFactor;
			m_windFactor = windFactor;
			m_airResitFactor = airResitFactor;
			m_vx = new EulerVector(0, 0, 0f);
			m_vy = new EulerVector(0, 0, 0f);
			m_rect = new Rectangle(-3, -3, 6, 6);
        }

        protected virtual void CollideGround()
        {
			StopMoving();
        }

        protected virtual void CollideObjects(Physics[] list)
        {
        }

        protected Point CompleteNextMovePoint(float dt)
        {
			m_vx.ComputeOneEulerStep(m_mass, m_arf, m_wf, dt);
			m_vy.ComputeOneEulerStep(m_mass, m_arf, m_gf, dt);
			return new Point((int)m_vx.x0, (int)m_vy.x0);
        }

        protected virtual void FlyoutMap()
        {
			StopMoving();
			if (m_isLiving)
			{
				Die();
			}
        }

        private Point GetNextPointByX(int x1, int x2, int y1, int y2, int x)
        {
			if (x2 == x1)
			{
				return new Point(x, y1);
			}
			return new Point(x, (x - x1) * (y2 - y1) / (x2 - x1) + y1);
        }

        private Point GetNextPointByY(int x1, int x2, int y1, int y2, int y)
        {
			if (y2 == y1)
			{
				return new Point(x1, y);
			}
			return new Point((y - y1) * (x2 - x1) / (y2 - y1) + x1, y);
        }

        public void MoveTo(int px, int py)
        {
			if (px == m_x && py == m_y)
			{
				return;
			}
			int num = px - m_x;
			int num2 = py - m_y;
			bool flag;
			int num3;
			int num4;
			if (Math.Abs(num) > Math.Abs(num2))
			{
				flag = true;
				num3 = Math.Abs(num);
				num4 = num / num3;
			}
			else
			{
				flag = false;
				num3 = Math.Abs(num2);
				num4 = num2 / num3;
			}
			Point point = new Point(m_x, m_y);
			for (int i = 1; i <= num3; i += 3)
			{
				point = ((!flag) ? GetNextPointByY(m_x, px, m_y, py, m_y + i * num4) : GetNextPointByX(m_x, px, m_y, py, m_x + i * num4));
				Rectangle rect = m_rect;
				rect.Offset(point.X, point.Y);
				Physics[] list = m_map.FindPhysicalObjects(rect, this);
				if (list.Length != 0)
				{
					base.SetXY(point.X, point.Y);
					CollideObjects(list);
				}
				else if (!m_map.IsRectangleEmpty(rect))
				{
					base.SetXY(point.X, point.Y);
					CollideGround();
				}
				else if (m_map.IsOutMap(point.X, point.Y))
				{
					base.SetXY(point.X, point.Y);
					FlyoutMap();
				}
				if (!m_isLiving || !m_isMoving)
				{
					return;
				}
			}
			base.SetXY(px, py);
        }

        public override void SetMap(Map map)
        {
			base.SetMap(map);
			UpdateAGW();
        }

        public void setSpeedXY(int vx, int vy)
        {
			m_vx.x1 = vx;
			m_vy.x1 = vy;
        }

        public override void SetXY(int x, int y)
        {
			base.SetXY(x, y);
			m_vx.x0 = x;
			m_vy.x0 = y;
        }

        private void UpdateAGW()
        {
			if (m_map != null)
			{
				m_arf = m_map.airResistance * m_airResitFactor;
				m_gf = m_map.gravity * m_gravityFactor * m_mass;
				m_wf = m_map.wind * m_windFactor;
			}
        }

        protected void UpdateForceFactor(float air, float gravity, float wind)
        {
			m_airResitFactor = air;
			m_gravityFactor = gravity;
			m_windFactor = wind;
			UpdateAGW();
        }
    }
}
