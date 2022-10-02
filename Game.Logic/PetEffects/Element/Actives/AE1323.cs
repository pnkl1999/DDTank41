using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1323 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public AE1323(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1323, elementID)
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
            AE1323 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1323) as AE1323;
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
                    m_added = enemy.MaxBlood * 5 / 100;
                    if (enemy.Blood < m_added)
                    {
                        enemy.Die();
                        if (player is Player)
                            (player as Player).PlayerDetail.OnKillingLiving(player.Game, 2, enemy.Id, enemy.IsLiving, m_added);
                    }
                }
            }
        }        

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerBuffSkillPet -= Player_PlayerBuffSkillPet;
        }         
    }
}
