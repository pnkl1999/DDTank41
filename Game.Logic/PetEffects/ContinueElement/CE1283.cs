using System;
using System.Collections.Generic;
using Game.Logic.Phy.Object;

namespace Game.Logic.PetEffects.ContinueElement
{
    public class CE1283 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public CE1283(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.CE1283, elementID)
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
            CE1283 effect = living.PetEffectList.GetOfType(ePetEffectType.CE1283) as CE1283;
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
            player.BeforeTakeDamage += new LivingTakedDamageEventHandle(player_BeforeTakeDamage);
            player.BeginSelfTurn += new LivingEventHandle(player_beginSeftTurn);
            player.PlayerClearBuffSkillPet += Player_PlayerClearBuffSkillPet;
        }

        private void Player_PlayerClearBuffSkillPet(Player player)
        {
            Stop();
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.BeforeTakeDamage -= new LivingTakedDamageEventHandle(player_BeforeTakeDamage);
            player.BeginSelfTurn -= new LivingEventHandle(player_beginSeftTurn);
        }
        public void player_beginSeftTurn(Living living)
        {
            m_count--;
            if (m_count < 0)
            {
                Stop();
            }
        }

        void player_BeforeTakeDamage(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
            int damageReduceAmount = damageAmount * 50 / 100;
            //Console.WriteLine("ID:{0}, Name:{1}, damageReduesAmount:{2}, total: {3}", ElementInfo.ID, ElementInfo.Name, damageReduceAmount, damageAmount);
            damageAmount = damageAmount - damageReduceAmount;
        }
    }
}
