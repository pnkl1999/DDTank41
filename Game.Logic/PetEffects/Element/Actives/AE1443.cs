using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1443 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public AE1443(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1443, elementID)
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
            AE1443 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1443) as AE1443;
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
            player.BeforeTakeDamage += Player_BeforeTakeDamage;
        }

        private void Player_BeforeTakeDamage(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
            if(IsTrigger)
            {
                m_added = 500;
                m_added += damageAmount * 10 / 100;
                damageAmount -= m_added;
                IsTrigger = false;
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerBuffSkillPet -= new PlayerEventHandle(player_AfterBuffSkillPetByLiving);
        }

        void player_AfterBuffSkillPetByLiving(Player player)
        {
            if (player.PetEffects.CurrentUseSkill == m_currentId)
            {
                IsTrigger = true;
                //player.AddPetEffect(new CE1443(1, m_probability, m_type, m_currentId, m_delay, ElementInfo.ID.ToString()), 0);
                //Console.WriteLine("Buff Name: {2}, ID: {0}, player.CurrentDamagePlus: {1}", ElementInfo.ID, player.CurrentDamagePlus, ElementInfo.Name);
            }
        }        
    }
}
