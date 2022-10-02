using System.Collections.Generic;
using System.Drawing;

namespace Game.Logic
{
    public class MapPoint
    {
        private List<Point> posX = new List<Point>();

        private List<Point> posX1 = new List<Point>();

        public List<Point> PosX
        {
			get
			{
				return posX;
			}
			set
			{
				posX = value;
			}
        }

        public List<Point> PosX1
        {
			get
			{
				return posX1;
			}
			set
			{
				posX1 = value;
			}
        }
    }
}
