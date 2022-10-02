using System;
using System.Collections.Generic;
using Game.Logic.Phy.Object;

namespace Game.Logic.PetEffects.ContinueElement
{
    public class CE1433 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public CE1433(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.CE1433, elementID)
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
            CE1433 effect = living.PetEffectList.GetOfType(ePetEffectType.CE1433) as CE1433;
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
            player.BeginSelfTurn += new LivingEventHandle(player_beginSelfTurn);
            player.BeforeTakeDamage += new LivingTakedDamageEventHandle(player_BeforeTakeDamage);
            player.PlayerClearBuffSkillPet += Player_PlayerClearBuffSkillPet;
        }

        private void Player_PlayerClearBuffSkillPet(Player player)
        {
            Stop();
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.BeginSelfTurn -= new LivingEventHandle(player_beginSelfTurn);
            player.BeforeTakeDamage -= new LivingTakedDamageEventHandle(player_BeforeTakeDamage);
        }
        public void player_beginSelfTurn(Living living)
        {
            m_count--;
            if (m_count < 0)
            {
                Stop();
            }
        }
        void player_BeforeTakeDamage(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
            int addDamageAmount = damageAmount * 20 / 100;
            //Console.WriteLine("ID:{0}, Name:{1}, Add damage amount:{2}, total: {3}", ElementInfo.ID, ElementInfo.Name, addDamageAmount, damageAmount);
            damageAmount += addDamageAmount;
        }
    }
}
