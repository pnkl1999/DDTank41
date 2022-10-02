using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1222 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public AE1222(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1222, elementID)
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
            AE1222 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1222) as AE1222;
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
            player.PlayerBuffSkillPet += player_AfterBuffSkillPetByLiving;
            player.AfterKillingLiving += Player_AfterKillingLiving;
            player.BeginSelfTurn += Player_BeginSelfTurn;
        }

        private void Player_BeginSelfTurn(Living living)
        {
            IsTrigger = false;
        }

        private void Player_AfterKillingLiving(Living living, Living target, int damageAmount, int criticalAmount)
        {
            if(IsTrigger)
            {
                target.Game.SendPetBuff(target, ElementInfo, true, 0);
                target.AddPetEffect(new CE1222(2, m_probability, m_type, m_currentId, m_delay, ElementInfo.ID.ToString()), 0);
                IsTrigger = false;
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerBuffSkillPet -= player_AfterBuffSkillPetByLiving;
            player.AfterKillingLiving -= Player_AfterKillingLiving;
            player.BeginSelfTurn -= Player_BeginSelfTurn;
        }

        void player_AfterBuffSkillPetByLiving(Player player)
        {
            if (player.PetEffects.CurrentUseSkill == m_currentId)
            {
                switch (m_currentId)
                {
                    case 154:
                    case 155:                        
                        List<Player> Enemies = player.Game.GetAllEnemyPlayers(player);
                        foreach (Player enemy in Enemies)
                        {
                            enemy.Game.SendPetBuff(enemy, ElementInfo, true, 0);
                            enemy.AddPetEffect(new CE1222(2, m_probability, m_type, m_currentId, m_delay, ElementInfo.ID.ToString()), 0);
                        }
                        break;
                    default:
                        IsTrigger = true;
                        break;
                }
                        
                //Console.WriteLine("Buff Name: {2}, ID: {0}, player.CurrentDamagePlus: {1}", ElementInfo.ID, player.CurrentDamagePlus, ElementInfo.Name);
            }
        }        
    }
}
