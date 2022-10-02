using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.PetEffects.Element.Passives
{
    public class PE1431 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public PE1431(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.PE1431, elementID)
        {
            m_count = count;
            m_coldDown = count;
            m_probability = probability == -1 ? 10000 : probability;
            m_type = type;
            m_delay = delay;
            m_currentId = skillId;
        }

        public override bool Start(Living living)
        {
            PE1431 effect = living.PetEffectList.GetOfType(ePetEffectType.PE1431) as PE1431;
            if (effect != null)
            {
                effect.m_probability = m_probability > effect.m_probability ? m_probability : effect.m_probability;
                return true;
            }
            else
            {
                return base.Start(living);
            }
        }

        protected override void OnAttachedToPlayer(Player player)
        {
            player.TakePlayerDamage += new LivingTakedDamageEventHandle(player_BeforeTakeDamage);
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.TakePlayerDamage -= new LivingTakedDamageEventHandle(player_BeforeTakeDamage);
        }
        void player_BeforeTakeDamage(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
            if (rand.Next(100) < 30)
            {
                //Console.WriteLine("Guard ID:{0}, Name:{1}, criticalAmount:{2}", ElementInfo.ID, ElementInfo.Name, criticalAmount);
                criticalAmount = 0;
            }

        }
    }
}
