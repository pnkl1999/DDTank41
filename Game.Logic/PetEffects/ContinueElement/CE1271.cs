using System;
using System.Collections.Generic;
using Game.Logic.Phy.Object;

namespace Game.Logic.PetEffects.ContinueElement
{
    public class CE1271 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;
        private Living m_liv;
        public CE1271(int count, int probability, int type, int skillId, int delay, string elementID, Living liv)
            : base(ePetEffectType.CE1271, elementID)
        {
            m_count = count;
            m_coldDown = count;
            m_probability = probability == -1 ? 10000 : probability;
            m_type = type;
            m_delay = delay;
            m_currentId = skillId;
            m_liv = liv;
        }

        public override bool Start(Living living)
        {
            CE1271 effect = living.PetEffectList.GetOfType(ePetEffectType.CE1271) as CE1271;
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
            player.PlayerClearBuffSkillPet += Player_PlayerClearBuffSkillPet;
        }

        private void Player_PlayerClearBuffSkillPet(Player player)
        {
            Stop();
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.BeginSelfTurn -= Player_BeginSelfTurn;
        }
        private void Player_BeginSelfTurn(Living living)
        {
            m_count--;
            if (m_count < 0)
            {
                Stop();
            }
            else
            {
                m_added = 1300;
                living.SyncAtTime = true;
                living.AddBlood(-m_added, 1);
                living.SyncAtTime = false;
                if (living.Blood <= 0)
                {
                    living.Die();
                    if (m_liv != null && m_liv is Player)
                        (m_liv as Player).PlayerDetail.OnKillingLiving(m_liv.Game, 2, living.Id, living.IsLiving, m_added);
                }
            }
        }
    }
}
