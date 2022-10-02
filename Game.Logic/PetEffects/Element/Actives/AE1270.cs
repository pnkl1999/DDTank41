using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1270 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public AE1270(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1270, elementID)
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
            AE1270 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1270) as AE1270;
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
                target.AddPetEffect(new CE1270(2, m_probability, m_type, m_currentId, m_delay, ElementInfo.ID.ToString(), living), 0);
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
                IsTrigger = true;          
                //Console.WriteLine("Buff Name: {2}, ID: {0}, player.CurrentDamagePlus: {1}", ElementInfo.ID, player.CurrentDamagePlus, ElementInfo.Name);
            }
        }        
    }
}
