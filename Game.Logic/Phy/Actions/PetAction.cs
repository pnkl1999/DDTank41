using System;

namespace Game.Logic.Phy.Actions
{
    public class PetAction
    {
        public int blood;

        public int damage;

        public int dander;

        public int id;

        public float Time;

        public int Type;

        public int TimeInt=> (int)Math.Round(Time * 1000f);

        public PetAction(float time, PetActionType type, int _id, int _damage, int _dander, int _blood)
        {
			Time = time;
			Type = (int)type;
			id = _id;
			damage = _damage;
			blood = _blood;
			dander = _dander;
        }
    }
}
