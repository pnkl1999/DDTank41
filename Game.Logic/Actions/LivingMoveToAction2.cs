using Game.Logic.Phy.Object;
using System.Collections.Generic;
using System.Drawing;

namespace Game.Logic.Actions
{
    public class LivingMoveToAction2 : BaseAction
    {
        private bool bool_0;

        private int int_0;

        private int int_1;

        private int int_2;

        private List<Point> list_0;

        private Living living_0;

        private LivingCallBack livingCallBack_0;

        private string string_0;

        private string string_1;

        public LivingMoveToAction2(Living living, List<Point> path, string action, string saction, int speed, int delay, LivingCallBack callback, int delayCallback)
			: base(delay, 0)
        {
			living_0 = living;
			list_0 = path;
			string_0 = action;
			string_1 = saction;
			bool_0 = false;
			int_0 = 0;
			livingCallBack_0 = callback;
			int_1 = speed;
			int_2 = delayCallback;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			if (!bool_0)
			{
				bool_0 = true;
				Point point2 = list_0[list_0.Count - 1];
				point2 = list_0[list_0.Count - 1];
				game.method_18(living_0, living_0.X, living_0.Y, point2.X, point2.Y, string_0, string_1, int_1);
			}
			int_0++;
			if (int_0 >= list_0.Count)
			{
				if (list_0[int_0 - 1].X > living_0.X)
				{
					living_0.Direction = 1;
				}
				else
				{
					living_0.Direction = -1;
				}
				Point point = list_0[int_0 - 1];
				point = list_0[int_0 - 1];
				living_0.SetXY(point.X, point.Y);
				if (livingCallBack_0 != null)
				{
					living_0.CallFuction(livingCallBack_0, 0);
				}
				Finish(tick);
			}
        }
    }
}
