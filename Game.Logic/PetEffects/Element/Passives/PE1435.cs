using Game.Logic.Actions;
using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.PetEffects.Element.Passives
{
    public class PE1435 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public PE1435(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.PE1435, elementID)
        {
            m_count = count;
            m_coldDown = 3;
            m_probability = probability == -1 ? 10000 : probability;
            m_type = type;
            m_delay = delay;
            m_currentId = skillId;
        }

        public override bool Start(Living living)
        {
            PE1435 effect = living.PetEffectList.GetOfType(ePetEffectType.PE1435) as PE1435;
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
            player.AfterKilledByLiving += player_afterKilledByLiving;//new KillLivingEventHanlde(player_afterKilledByLiving);
            player.BeginNextTurn += new LivingEventHandle(player_beginNextTurn);
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.AfterKilledByLiving -= player_afterKilledByLiving;//new KillLivingEventHanlde(player_afterKilledByLiving);
            player.BeginNextTurn -= new LivingEventHandle(player_beginNextTurn);
        }
        void player_afterKilledByLiving(Living living, Living target, int damageAmount, int criticalAmount)
        {
            if (living.Game is PVPGame && m_coldDown > 0 && criticalAmount != 0 && living.Blood <= 0)
            {
                if (rand.Next(100) < 50)
                {
                    m_added = living.MaxBlood * 5 / 100;
                    living.SyncAtTime = true;
                    living.AddBlood(m_added);
                    living.SyncAtTime = false;
                    living.Game.SendPetBuff(living, ElementInfo, true);
                    if (target is Player)
                    {
                        target.Game.AddAction(new FightAchievementAction(living, eFightAchievementType.ExpertInStrokes, living.Direction, 1200)); //7, living.Direction, 1200));
                    }
                }
                m_coldDown--;
            }

        }
        public void player_beginNextTurn(Living living)
        {
            if (m_coldDown > 0 && m_added != 0)
            {
                living.Game.SendPetBuff(living, ElementInfo, false);
                m_added = 0;
            }
        }
    }
}
