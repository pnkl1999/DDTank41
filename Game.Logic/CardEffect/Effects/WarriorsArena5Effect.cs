using Game.Logic.CardEffects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.CardEffect.Effects
{
    public class WarriorsArena5Effect : BaseCardEffect
    {
        private int m_indexValue = 0;

        private int m_value = 0;

        private int m_added = 0;

        public WarriorsArena5Effect(int index, CardBuffInfo info)
			: base(eCardEffectType.WarriorsArena5, info)
        {
			m_indexValue = index;
			string[] values = info.Value.Split('|');
			if (m_indexValue < values.Length)
			{
				m_value = int.Parse(values[m_indexValue]);
			}
        }

        public override bool Start(Living living)
        {
			WarriorsArena5Effect effect = living.CardEffectList.GetOfType(eCardEffectType.WarriorsArena5) as WarriorsArena5Effect;
			if (effect != null)
			{
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.BeforeTakeDamage += ChangeProperty;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.BeforeTakeDamage -= ChangeProperty;
        }

        private void ChangeProperty(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
			if (m_added != 0)
			{
				m_added = 0;
			}
			if (living.Game is PVEGame && (living.Game as PVEGame).Info.ID == 13 && living is SimpleBoss)
			{
				switch ((living as SimpleBoss).NpcInfo.ID)
				{
				case 13007:
				case 13107:
				case 13207:
				case 13307:
				case 13407:
					damageAmount -= m_value;
					break;
				}
			}
        }
    }
}
