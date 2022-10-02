using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1189 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public AE1189(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1189, elementID)
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
            AE1189 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1189) as AE1189;
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
                CE1184 effect4 = player.PetEffectList.GetOfType(ePetEffectType.CE1184) as CE1184;
                if (effect4 != null)
                {
                    effect4.Stop();
                }
                CE1185 effect5 = player.PetEffectList.GetOfType(ePetEffectType.CE1185) as CE1185;
                if (effect5 != null)
                {
                    effect5.Stop();
                }
                CE1186 effect6 = player.PetEffectList.GetOfType(ePetEffectType.CE1186) as CE1186;
                if (effect6 != null)
                {
                    effect6.Stop();
                }
                CE1187 effect7 = player.PetEffectList.GetOfType(ePetEffectType.CE1187) as CE1187;
                if (effect7 != null)
                {
                    effect7.Stop();
                }
                IsTrigger = false;
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerBeginMoving -= Player_PlayerBeginMoving;
        }        
    }
}
