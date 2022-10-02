using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.PetEffects.Element.Passives
{
    public class PE1236 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public PE1236(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.PE1236, elementID)
        {
            m_count = count;
            m_coldDown = 3;
            m_probability = probability == -1 ? 10000 : probability;
            m_type = type;
            m_delay = delay;
            m_currentId = skillId;
        }

        public override bool Start(Living living)
        {
            PE1236 effect = living.PetEffectList.GetOfType(ePetEffectType.PE1236) as PE1236;
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
        }

        private void Player_BeforeTakeDamage(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
            if(rand.Next(100) < 35)
            {
                m_added = 500;
                source.SyncAtTime = true;
                source.AddBlood(-m_added, 1);
                source.SyncAtTime = false;
                if (source.Blood < 0)
                {
                    source.Die();
                    if (living != null && living is Player)
                        (living as Player).PlayerDetail.OnKillingLiving(living.Game, 2, source.Id, source.IsLiving, m_added);
                }
                living.PetEffects.ReboundDamage = m_added;                                
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.BeforeTakeDamage -= Player_BeforeTakeDamage;
        }       
    }
}
