using System;
using System.Collections.Generic;
using Game.Logic.Phy.Object;

namespace Game.Logic.PetEffects.ContinueElement
{
    public class CE1185 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public CE1185(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.CE1185, elementID)
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
            CE1185 effect = living.PetEffectList.GetOfType(ePetEffectType.CE1185) as CE1185;
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
            player.BeginSelfTurn += Player_BeginSelfTurn;
            if (m_added == 0)
            {
                m_added = 300;
                player.BaseDamage += m_added;
            }
        }

        private void Player_BeginNextTurn(Living living)
        {
        }

        private void Player_BeginSelfTurn(Living living)
        {
           
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.BeginNextTurn -= Player_BeginNextTurn;
            player.BeginSelfTurn -= Player_BeginSelfTurn;
            player.Game.SendPetBuff(player, ElementInfo, false);
        }
    }
}
