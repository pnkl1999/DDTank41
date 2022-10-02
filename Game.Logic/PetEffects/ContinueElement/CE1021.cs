using System;
using System.Collections.Generic;
using Game.Logic.Phy.Object;
using Bussiness;

namespace Game.Logic.PetEffects.ContinueElement
{
    public class CE1021 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public CE1021(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.CE1021, elementID)
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
            CE1021 effect = living.PetEffectList.GetOfType(ePetEffectType.CE1021) as CE1021;
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
            player.BeginSelfTurn += Player_BeginSelfTurn;
            player.IsNoHole = true;
            player.Game.SendPlayerPicture(player, (int)BuffType.NoHole, true);
            player.PlayerClearBuffSkillPet += Player_PlayerClearBuffSkillPet;
        }

        private void Player_PlayerClearBuffSkillPet(Player player)
        {
            Stop();
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.BeginSelfTurn -= Player_BeginSelfTurn;
            player.IsNoHole = false;
            player.Game.SendPlayerPicture(player, (int)BuffType.NoHole, false);
        }
        private void Player_BeginSelfTurn(Living living)
        {
            m_count--;
            if (m_count < 0)
            {
                //living.Game.SendPetBuff(living, ElementInfo, false, 0);
                Stop();
            }
        }
    }
}
