using Game.Logic.CardEffects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.CardEffect.Effects
{
    public class EvilTribe3Effect : BaseCardEffect
    {
        private int m_indexValue = 0;

        private int m_value = 0;

        private int m_added = 0;

        public EvilTribe3Effect(int index, CardBuffInfo info)
			: base(eCardEffectType.EvilTribe3, info)
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
			EvilTribe3Effect effect = living.CardEffectList.GetOfType(eCardEffectType.EvilTribe3) as EvilTribe3Effect;
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
			if (living.Game is PVEGame && (living.Game as PVEGame).Info.ID == 3)
			{
				damageAmount -= m_value;
			}
        }
    }
}
