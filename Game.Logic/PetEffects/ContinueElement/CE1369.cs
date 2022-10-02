using System;
using System.Collections.Generic;
using Game.Logic.Phy.Object;

namespace Game.Logic.PetEffects.ContinueElement
{
    public class CE1369 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public CE1369(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.CE1369, elementID)
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
            CE1369 effect = living.PetEffectList.GetOfType(ePetEffectType.CE1369) as CE1369;
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
            player.AfterKilledByLiving += Player_AfterKilledByLiving;           
        }

        private void Player_AfterKilledByLiving(Living living, Living target, int damageAmount, int criticalAmount)
        {
            m_added = living.MaxBlood * 4 / 10 / 100;
            List<Player> allies = living.Game.GetAllTeamPlayers(living);
            foreach (Player ally in allies)
            {
                ally.SyncAtTime = true;
                if (ally.Blood < (ally.MaxBlood * 20 / 100))
                {
                    ally.AddBlood(m_added * 2);
                }
                else
                {
                    ally.AddBlood(m_added);
                }
                ally.SyncAtTime = false;
            }
        }       

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.AfterKilledByLiving -= Player_AfterKilledByLiving;
        }
    }
}
