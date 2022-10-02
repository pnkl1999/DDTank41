using Game.Logic.Phy.Maps;
using System;
using System.Drawing;

namespace Game.Logic.Phy.Object
{
    public class Physics
    {
        protected int m_id;

        protected bool m_isLiving;

        protected bool m_isMoving;

        protected Map m_map;

        protected Rectangle m_rect;

        protected Rectangle m_rectBomb;

        protected int m_x;

        protected int m_y;

        private object object_1;

        private object object_2;

        private int properties1;

        private int m_ShootCount;

        public Rectangle Bound=> m_rect;

        public Rectangle Bound1=> m_rectBomb;

        public int Id=> m_id;

        public int ShootCount
        {
			get
			{
				return m_ShootCount;
			}
			set
			{
				m_ShootCount = value;
			}
        }

        public bool IsLiving
        {
			get
			{
				return m_isLiving;
			}
			set
			{
				m_isLiving = value;
			}
        }

        public bool IsMoving=> m_isMoving;

        public int Properties1
        {
			get
			{
				return properties1;
			}
			set
			{
				properties1 = value;
			}
        }

        public object Properties2
        {
			get
			{
				return object_1;
			}
			set
			{
				object_1 = value;
			}
        }

        public string ActionMovie { get; set; }

        public object Properties3
        {
			get
			{
				return object_2;
			}
			set
			{
				object_2 = value;
			}
        }

        public virtual int X=> m_x;

        public virtual int Y=> m_y;

        public Physics(int id)
        {
			m_id = id;
			m_rect = new Rectangle(-5, -5, 10, 10);
			m_rectBomb = new Rectangle(0, 0, 0, 0);
			m_isLiving = true;
        }

        public virtual void CollidedByObject(Physics phy)
        {
        }

        public virtual void Die()
        {
			StopMoving();
			m_isLiving = false;
        }

        public virtual void Dispose()
        {
			if (m_map != null)
			{
				m_map.RemovePhysical(this);
			}
        }

        public double Distance(int x, int y)
        {
			return Math.Sqrt((m_x - x) * (m_x - x) + (m_y - y) * (m_y - y));
        }

        public virtual Point GetCollidePoint()
        {
			return new Point(X, Y);
        }

        public static int PointToLine(int x1, int y1, int x2, int y2, int px, int py)
        {
			int num = y1 - y2;
			int num2 = x2 - x1;
			int num3 = x1 * y2 - x2 * y1;
			return (int)((double)Math.Abs(num * px + num2 * py + num3) / Math.Sqrt(num * num + num2 * num2));
        }

        public virtual void PrepareNewTurn()
        {
        }

        public virtual void SetMap(Map map)
        {
			m_map = map;
        }

        public void SetRect(int x, int y, int width, int height)
        {
			m_rect.X = x;
			m_rect.Y = y;
			m_rect.Width = width;
			m_rect.Height = height;
        }

        public void SetRectBomb(int x, int y, int width, int height)
        {
			m_rectBomb.X = x;
			m_rectBomb.Y = y;
			m_rectBomb.Width = width;
			m_rectBomb.Height = height;
        }

        public void SetXY(Point p)
        {
			SetXY(p.X, p.Y);
        }

        public virtual void SetXY(int x, int y)
        {
			m_x = x;
			m_y = y;
        }

        public virtual void StartMoving()
        {
			if (m_map != null)
			{
				m_isMoving = true;
			}
        }

        public virtual void StopMoving()
        {
			m_isMoving = false;
        }
    }
}
