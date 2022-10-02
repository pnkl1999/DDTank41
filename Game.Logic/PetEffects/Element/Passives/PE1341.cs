using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Logic.PetEffects.Element.Passives
{
    public class PE1341 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public PE1341(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.PE1341, elementID)
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
            PE1341 effect = living.PetEffectList.GetOfType(ePetEffectType.PE1341) as PE1341;
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
            player.PlayerShoot += Player_PlayerShoot;
            player.AfterPlayerShooted += Player_AfterPlayerShooted;
        }

        private void Player_AfterPlayerShooted(Player player)
        {
            player.Game.SendPetBuff(player, ElementInfo, false, 0);
        }

        private void Player_PlayerShoot(Player player)
        {
            m_added = player.Blood * 3 / 100;
            player.Game.SendPetBuff(player, ElementInfo, true, 0);
            List<Living> allies = player.Game.Map.FindAllNearestEnemy(player.X, player.Y, 250, player);
            foreach (Living ally in allies)
            {
                ally.SyncAtTime = true;
                ally.AddBlood(-m_added, 1);
                ally.SyncAtTime = false;
                if (ally.Blood <= 0)
                {
                    ally.Die();
                    if (player != null && player is Player)
                        (player as Player).PlayerDetail.OnKillingLiving(player.Game, 2, ally.Id, ally.IsLiving, m_added);
                }
            }
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerShoot -= Player_PlayerShoot;
            player.AfterPlayerShooted -= Player_AfterPlayerShooted;
        }
    }
}
