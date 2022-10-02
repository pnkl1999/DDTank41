﻿using System;
using System.Collections.Generic;
using Game.Logic.Phy.Object;

namespace Game.Logic.PetEffects.ContinueElement
{
    public class CE1445 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public CE1445(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.CE1445, elementID)
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
            CE1445 effect = living.PetEffectList.GetOfType(ePetEffectType.CE1445) as CE1445;
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
            player.BeginSelfTurn += Player_BeginSelfTurn;
            player.BeforeTakeDamage += Player_BeforeTakeDamage;
            player.PlayerClearBuffSkillPet += Player_PlayerClearBuffSkillPet;
        }

        private void Player_PlayerClearBuffSkillPet(Player player)
        {
            Stop();
        }

        private void Player_BeforeTakeDamage(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
            m_added += damageAmount * 5 / 100;
            damageAmount -= m_added;
        }

        private void Player_BeginSelfTurn(Living living)
        {
            m_count--;
            if(m_count < 0)
            {
                Stop();
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {

            player.Game.SendPetBuff(player, ElementInfo, false);
            player.BeginSelfTurn -= Player_BeginSelfTurn;
            player.BeforeTakeDamage -= Player_BeforeTakeDamage;
        }
    }
}
