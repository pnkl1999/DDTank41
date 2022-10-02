using System;
using System.Collections.Generic;
using Game.Logic.Phy.Object;
using Game.Logic.PetEffects.Element.Passives;

namespace Game.Logic.PetEffects.ContinueElement
{
    public class CE1300 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public CE1300(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.CE1300, elementID)
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
            CE1300 effect = living.PetEffectList.GetOfType(ePetEffectType.CE1300) as CE1300;
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
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerBuffSkillPet -= new PlayerEventHandle(player_AfterBuffSkillPetByLiving);
        }

        void player_AfterBuffSkillPetByLiving(Player player)
        {
            List<Player> Enemies = player.Game.GetAllEnemyPlayers(player);
            foreach (Player enemy in Enemies)
            {
                PE1300 effect = enemy.PetEffectList.GetOfType(ePetEffectType.PE1300) as PE1300;
                if (effect != null)
                {
                    if (player.PetMP > 0)
                    {
                        m_added = player.PetMP * 30 / 100;
                        enemy.AddPetMP(m_added == 0 ? 1 : m_added);
                    }
                }
            }
        }
    }
}
