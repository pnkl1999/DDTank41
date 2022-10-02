﻿using System;
using System.Collections.Generic;
using Game.Logic.Phy.Object;

namespace Game.Logic.PetEffects.ContinueElement
{
    public class CE1183 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;
        public int Count
        {
            get { return m_count; }
        }
        public CE1183(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.CE1183, elementID)
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
            CE1183 effect = living.PetEffectList.GetOfType(ePetEffectType.CE1183) as CE1183;
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
            if (m_added == 0)
            {
                m_added = 300;
                player.BaseGuard += m_added;
            }
            player.PlayerClearBuffSkillPet += Player_PlayerClearBuffSkillPet;
        }

        private void Player_PlayerClearBuffSkillPet(Player player)
        {
            Stop();
        }

        private void Player_BeginSelfTurn(Living living)
        {
            m_count--;
            if (m_count < 0)
            {               
                Stop();
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.Game.SendPetBuff(player, ElementInfo, false, 1);
            player.BaseGuard -= m_added;
            m_added = 0;
            player.BeginSelfTurn -= Player_BeginSelfTurn;            
        }
    }
}
