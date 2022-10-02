using Bussiness;
using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1349 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public AE1349(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1349, elementID)
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
            AE1349 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1349) as AE1349;
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
            player.PlayerBeginMoving += Player_PlayerBeginMoving;
            player.PlayerBuffSkillPet += Player_PlayerBuffSkillPet;   
        }

        private void Player_PlayerBuffSkillPet(Player player)
        {
            if (player.PetEffects.CurrentUseSkill == m_currentId)
            {
                IsTrigger = true;
            }
        }

        private void Player_PlayerBeginMoving(Player player)
        {
            if (IsTrigger)
            {               
                AE1342 effect1 = player.PetEffectList.GetOfType(ePetEffectType.AE1342) as AE1342;
                if (effect1 != null)
                {
                    effect1.Pause();
                }

                AE1343 effect2 = player.PetEffectList.GetOfType(ePetEffectType.AE1343) as AE1343;
                if (effect2 != null)
                {
                    effect2.Pause();
                }

                AE1344 effect3 = player.PetEffectList.GetOfType(ePetEffectType.AE1344) as AE1344;
                if (effect3 != null)
                {
                    effect3.Pause();
                }
                player.Game.SendPlayerPicture(player, (int)BuffType.NoHole, false);
                player.IsNoHole = false;
                IsTrigger = false;
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerBeginMoving -= Player_PlayerBeginMoving;
        }        
    }
}
