using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1367 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public AE1367(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1367, elementID)
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
            AE1367 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1367) as AE1367;
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
            player.PlayerBuffSkillPet += Player_PlayerBuffSkillPet;      
        }

        private void Player_PlayerBuffSkillPet(Player player)
        {
            if (player.PetEffects.CurrentUseSkill == m_currentId)
            {
                List<Living> allies = player.Game.Map.FindAllNearestSameTeam(player.X, player.Y, 250, player);
                foreach (Living ally in allies)
                {
                    ally.Game.SendPetBuff(ally, ElementInfo, true, 2, player.PlayerDetail);
                    ally.AddPetEffect(new CE1367(4, m_probability, m_type, m_currentId, m_delay, ElementInfo.ID.ToString()), 0);
                }
                player.Game.SendPetBuff(player, ElementInfo, true, 2, player.PlayerDetail);
                player.AddPetEffect(new CE1367(4, m_probability, m_type, m_currentId, m_delay, ElementInfo.ID.ToString()), 0);
            }
        }        

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerBuffSkillPet -= Player_PlayerBuffSkillPet;
        }         
    }
}
