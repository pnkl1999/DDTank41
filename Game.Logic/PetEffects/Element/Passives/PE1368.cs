using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Logic.PetEffects.Element.Passives
{
    public class PE1368 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public PE1368(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.PE1368, elementID)
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
            PE1368 effect = living.PetEffectList.GetOfType(ePetEffectType.PE1368) as PE1368;
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
            player.BeginNextTurn += Player_BeginNextTurn;

        }

        private void Player_BeginNextTurn(Living living)
        {
            if (!IsTrigger)
            {
                List<Player> allies = living.Game.GetAllTeamPlayers(living);
                foreach (Player ally in allies)
                {
                    ally.AddPetEffect(new CE1368(0, m_probability, m_type, m_currentId, m_delay, ElementInfo.ID.ToString()), 0);
                }
                IsTrigger = true;
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.BeginNextTurn -= Player_BeginNextTurn;
        }

    }
}
