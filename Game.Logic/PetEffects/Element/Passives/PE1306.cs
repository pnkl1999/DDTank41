using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Logic.PetEffects.Element.Passives
{
    public class PE1306 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public PE1306(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.PE1306, elementID)
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
            PE1306 effect = living.PetEffectList.GetOfType(ePetEffectType.PE1306) as PE1306;
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
            player.BeginSelfTurn += new LivingEventHandle(player_beginSeftTurn);
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.BeginSelfTurn -= new LivingEventHandle(player_beginSeftTurn);
        }

        public void player_beginSeftTurn(Living living)
        {
            if (living.Game is PVPGame)
            {
                List<Player> Enemies = living.Game.GetAllEnemyPlayers(living);
                foreach (Player enemy in Enemies)
                {
                    (living as Player).AddPetMP(1);
                }
            }            
        }
    }
}
