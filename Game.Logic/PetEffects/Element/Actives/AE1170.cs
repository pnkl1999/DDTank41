using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1170 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public AE1170(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1170, elementID)
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
            AE1170 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1170) as AE1170;
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
            if (player.PetEffects.CurrentUseSkill == m_currentId && player.Game is PVPGame)
            {
                List<Player> enemies = player.Game.GetAllEnemyPlayers(player);
                foreach (Player enemy in enemies)
                {
                    //enemy.Game.SendPetBuff(enemy, ElementInfo, true);
                    enemy.AddPetEffect(new CE1170(3, m_probability, m_type, m_currentId, m_delay, ElementInfo.ID.ToString(), player), 0);
                }
            }
        }        

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerBuffSkillPet -= Player_PlayerBuffSkillPet;
        }         
    }
}
