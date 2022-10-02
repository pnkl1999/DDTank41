using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.PetEffects.Element.Passives
{
    public class PE1325 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public PE1325(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.PE1325, elementID)
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
            PE1325 effect = living.PetEffectList.GetOfType(ePetEffectType.PE1325) as PE1325;
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
            player.PlayerShoot += new PlayerEventHandle(ChangeProperty);
            player.AfterPlayerShooted += new PlayerEventHandle(player_AfterPlayerShooted);
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerShoot -= new PlayerEventHandle(ChangeProperty);
            player.AfterPlayerShooted -= new PlayerEventHandle(player_AfterPlayerShooted);
        }

        private void ChangeProperty(Player player)
        {
            m_added = 15;
            player.PetEffects.DamagePercent += m_added;            
        }

        private void player_AfterPlayerShooted(Player player)
        {           
            player.PetEffects.DamagePercent -= m_added;
            m_added = 0;
        }        
    }
}
