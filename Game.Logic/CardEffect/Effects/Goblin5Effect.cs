using Game.Logic.CardEffects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.CardEffect.Effects
{
    public class Goblin5Effect : BaseCardEffect
    {
        private int m_indexValue = 0;

        private int m_value = 0;

        private int m_added = 0;

        public Goblin5Effect(int index, CardBuffInfo info)
			: base(eCardEffectType.Goblin5, info)
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
			Goblin5Effect effect = living.CardEffectList.GetOfType(eCardEffectType.Goblin5) as Goblin5Effect;
			if (effect != null)
			{
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.PlayerAfterReset += ChangeProperty;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.PlayerAfterReset -= ChangeProperty;
        }

        private void ChangeProperty(Player player)
        {
			if (m_added != 0)
			{
				player.Attack -= m_added;
				player.Agility -= m_added;
				player.Lucky -= m_added;
				player.Defence -= m_added;
				m_added = 0;
			}
			if (player.Game is PVEGame && (player.Game as PVEGame).Info.ID == 5)
			{
				m_added = m_value;
				player.Attack += m_added;
				player.Agility += m_added;
				player.Lucky += m_added;
				player.Defence += m_added;
			}
        }
    }
}
