using SqlDataProvider.Data;
using System.Drawing;

namespace Game.Logic.Phy.Object
{
    public class SimpleWingBoss : SimpleBoss
    {
        public SimpleWingBoss(int id, BaseGame game, NpcInfo npcInfo, int direction, int type)
			: base(id, game, npcInfo, direction, type, "")
        {
        }

        public virtual Point StartFalling(bool direct, int delay, int speed)
        {
			Point result = default(Point);
			result.X = X;
			result.Y = Y;
			return result;
        }
    }
}
