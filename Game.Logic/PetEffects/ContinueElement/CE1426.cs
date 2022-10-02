using System;
using System.Collections.Generic;
using Game.Logic.Phy.Object;

namespace Game.Logic.PetEffects.ContinueElement
{
    public class CE1426 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public CE1426(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.CE1426, elementID)
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
            CE1426 effect = living.PetEffectList.GetOfType(ePetEffectType.CE1426) as CE1426;
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
            player.BeginAttacking += new LivingEventHandle(ChangeProperty);
            player.BeginSelfTurn += new LivingEventHandle(player_beginSeftTurn);
            player.Game.SendPetBuff(player, ElementInfo, true);
            player.ShowImprisonment(true);
            player.PlayerClearBuffSkillPet += Player_PlayerClearBuffSkillPet;
        }

        private void Player_PlayerClearBuffSkillPet(Player player)
        {
            Stop();
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.BeginAttacking -= new LivingEventHandle(ChangeProperty);
            player.BeginSelfTurn -= new LivingEventHandle(player_beginSeftTurn);
            player.Game.SendPetBuff(player, ElementInfo, false);
            player.ShowImprisonment(false);

        }
        public void player_beginSeftTurn(Living living)
        {
            if (m_count < 0)
            {
                Stop();
            }
        }
        private void ChangeProperty(Living living)
        {
            if (living.IsAttacking)
            {
                if (m_count >= 0)
                {
                    ((Player)living).SkipAttack();
                }
                m_count--;                      
            }
        }
    }
}
