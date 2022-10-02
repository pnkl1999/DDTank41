using System;

namespace Game.Logic.Spells
{
    public class SpellAttibute : Attribute
    {
        public int Type { get; private set; }

        public SpellAttibute(int type)
        {
			Type = type;
        }
    }
}
