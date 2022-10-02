using System;

namespace Game.Logic.Phy.Actions
{
    public class BombAction
    {
        public int Param1;

        public int Param2;

        public int Param3;

        public int Param4;

        public float Time;

        public int Type;

        public int TimeInt=> (int)Math.Round(Time * 1000f);

        public BombAction(float time, ActionType type, int para1, int para2, int para3, int para4)
        {
			Time = time;
			Type = (int)type;
			Param1 = para1;
			Param2 = para2;
			Param3 = para3;
			Param4 = para4;
        }
    }
}
