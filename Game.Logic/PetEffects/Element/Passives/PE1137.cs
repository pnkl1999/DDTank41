using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.PetEffects.Element.Passives
{
    public class PE1137 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public PE1137(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.PE1137, elementID)
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
            PE1137 effect = living.PetEffectList.GetOfType(ePetEffectType.PE1137) as PE1137;
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
            player.BeforeTakeDamage += Player_BeforeTakeDamage;
            player.AfterKilledByLiving += Player_AfterKilledByLiving;
        }

        private void Player_AfterKilledByLiving(Living living, Living target, int damageAmount, int criticalAmount)
        {
            living.Game.SendPetBuff(living, ElementInfo, false, 0);
        }

        private void Player_BeforeTakeDamage(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
            if(rand.Next(100) <= 20)
            {
                living.PetEffects.ActiveEffect = true;
                living.Game.SendPetBuff(living, ElementInfo, true, 0);
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.BeforeTakeDamage -= Player_BeforeTakeDamage;
            player.AfterKilledByLiving -= Player_AfterKilledByLiving;
        }        
    }
}
