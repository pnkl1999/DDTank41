using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Logic.PetEffects.Element.Passives
{
    public class PE1373 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public PE1373(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.PE1373, elementID)
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
            PE1373 effect = living.PetEffectList.GetOfType(ePetEffectType.PE1373) as PE1373;
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
            player.PlayerShootCure += Player_PlayerShootCure;
            //player.PlayerUseSecondWeapon += Player_PlayerUseSecondWeapon;

        }

        private void Player_PlayerShootCure(Player player)
        {
            m_added = player.MaxBlood * 6 / 100;
            player.SyncAtTime = true;
            player.AddBlood(m_added);
            player.SyncAtTime = false;
        }

        private void Player_PlayerUseSecondWeapon(Player player, int type)
        {
            if (type != 31)
            {
                m_added = player.MaxBlood * 6 / 100;
                player.SyncAtTime = true;
                player.AddBlood(m_added);
                player.SyncAtTime = false;
            }
        }


        protected override void OnRemovedFromPlayer(Player player)
        {
            // player.PlayerUseSecondWeapon -= Player_PlayerUseSecondWeapon;
            player.PlayerShootCure -= Player_PlayerShootCure;
        }

    }
}
