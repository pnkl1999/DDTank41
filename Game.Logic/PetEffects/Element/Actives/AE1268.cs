using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1268 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public AE1268(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1268, elementID)
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
            AE1268 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1268) as AE1268;
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
            //player.AfterPlayerShooted += new PlayerEventHandle(player_AfterPlayerShooted);
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerBuffSkillPet -= new PlayerEventHandle(player_AfterBuffSkillPetByLiving);
            //player.AfterPlayerShooted -= new PlayerEventHandle(player_AfterPlayerShooted);
        }

        void player_AfterBuffSkillPetByLiving(Player player)
        {
            if (player.PetEffects.CurrentUseSkill == m_currentId && player.Game is PVPGame)
            {
                m_added = 5;
                List<Player> allies = player.Game.GetAllTeamPlayers(player);
                foreach (Player ally in allies)
                {
                    ally.AddPetMP(m_added);
                }
            }
        }

        /*private void player_AfterPlayerShooted(Player player)
        {
            if (m_added != 0)
            {
                List<Player> allies = player.Game.GetAllTeamPlayers(player);
                foreach (Player ally in allies)
                {
                    ally.AddPetMP(m_added);
                }
                m_added = 0;
            }
            //Console.WriteLine("Buff Name: {2}, ID: {0}, player.CurrentDamagePlus: {1}", ElementInfo.ID, player.CurrentDamagePlus, ElementInfo.Name);
        }*/
    }
}
