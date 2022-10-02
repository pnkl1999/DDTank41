using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1267 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public AE1267(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1267, elementID)
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
            AE1267 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1267) as AE1267;
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
            player.AfterKillingLiving += Player_AfterKillingLiving;
            player.PlayerBuffSkillPet += Player_PlayerBuffSkillPet;
        }

        private void Player_PlayerBuffSkillPet(Player player)
        {
            if (player.PetEffects.CurrentUseSkill == m_currentId && player.Game is PVPGame)
            {
                m_added = 20;
                IsTrigger = true;
            }
        }

        private void Player_AfterKillingLiving(Living living, Living target, int damageAmount, int criticalAmount)
        {
            if (IsTrigger)
            {
                target.Game.SendPetBuff(target, ElementInfo, true);
                if ((target as Player).PetMP < m_added)
                {
                    m_added = (target as Player).PetMP;
                }
                (target as Player).PetMP -= m_added;
                IsTrigger = false;
                m_added = 0;
                target.AddPetEffect(new CE1266(0, m_probability, m_type, m_currentId, m_delay, ElementInfo.ID.ToString()), 0);
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.AfterKillingLiving -= Player_AfterKillingLiving;
            player.PlayerBuffSkillPet -= Player_PlayerBuffSkillPet;
        }
    }
}
