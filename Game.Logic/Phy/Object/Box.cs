using SqlDataProvider.Data;
using System.Drawing;

namespace Game.Logic.Phy.Object
{
    public class Box : PhysicalObj
    {
        private int _userID;

        private int _liveCount;

        public int m_type;

        private ItemInfo m_item;

        public int UserID
        {
			get
			{
				return _userID;
			}
			set
			{
				_userID = value;
			}
        }

        public int LiveCount
        {
			get
			{
				return _liveCount;
			}
			set
			{
				_liveCount = value;
			}
        }

        public ItemInfo Item=> m_item;

        public override int Type=> m_type;

        public bool IsGhost=> m_type > 1;

        public Box(int id, string model, ItemInfo item, int type)
			: base(id, "", model, "", 1, 1, 0)
        {
			_userID = 0;
			m_rect = new Rectangle(-15, -15, 30, 30);
			m_item = item;
			m_type = type;
        }

        public override void CollidedByObject(Physics phy)
        {
			if (phy is SimpleBomb)
			{
				SimpleBomb simpleBomb = phy as SimpleBomb;
				if (simpleBomb.Owner is Player)
				{
					simpleBomb.Owner.PickBox(this);
				}
			}
        }
    }
}
