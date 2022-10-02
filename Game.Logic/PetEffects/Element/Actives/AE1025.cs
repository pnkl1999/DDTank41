using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1025 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public AE1025(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1025, elementID)
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
            AE1025 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1025) as AE1025;
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
            player.PlayerBuffSkillPet += new PlayerEventHandle(player_AfterBuffSkillPetByLiving);
            player.PlayerAnyShellThrow += Player_PlayerAnyShellThrow;
        }

        private void Player_PlayerAnyShellThrow(Player player)
        {
            if (IsTrigger)
            {
                List<Player> allies = player.Game.GetAllTeamPlayers(player);
                foreach (Player ally in allies)
                {
                    if (ally.PlayerDetail == player.PlayerDetail)
                        continue;
                    ally.Game.SendPetBuff(ally, ElementInfo, true);
                    ally.AddPetEffect(new CE1025(2, m_probability, m_type, m_currentId, m_delay, ElementInfo.ID.ToString()), 0);
                }
                IsTrigger = false;
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerBuffSkillPet -= new PlayerEventHandle(player_AfterBuffSkillPetByLiving);
            player.PlayerAnyShellThrow -= Player_PlayerAnyShellThrow;
        }

        void player_AfterBuffSkillPetByLiving(Player player)
        {
            if (player.PetEffects.CurrentUseSkill == m_currentId)
            {
                IsTrigger = true;
                //Console.WriteLine("Buff Name: {2}, ID: {0}, player.CurrentDamagePlus: {1}", ElementInfo.ID, player.CurrentDamagePlus, ElementInfo.Name);
            }
        }        
    }
}
