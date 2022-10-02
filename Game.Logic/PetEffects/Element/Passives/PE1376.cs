using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;

namespace Game.Logic.PetEffects.Element.Passives
{
    public class PE1376 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;

        public PE1376(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.PE1376, elementID)
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
            PE1376 effect = living.PetEffectList.GetOfType(ePetEffectType.PE1376) as PE1376;
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
            player.BeginNextTurn += new LivingEventHandle(player_beginNextTurn);
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.BeginNextTurn -= new LivingEventHandle(player_beginNextTurn);
        }

        public void player_beginNextTurn(Living living)
        {
            if (living.Game.CurrentLiving is Player && living.Game.CurrentLiving != living)
            {
                CE1366 effect66 = living.Game.CurrentLiving.PetEffectList.GetOfType(ePetEffectType.CE1366) as CE1366;
                CE1367 effect67 = living.Game.CurrentLiving.PetEffectList.GetOfType(ePetEffectType.CE1367) as CE1367;
                if (effect66 != null || effect67 != null)
                {
                    (living as Player).AddPetMP(1);
                }
            }           
        }
    }
}
