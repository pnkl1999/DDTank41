using Game.Logic.CardEffects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.CardEffect.Effects
{
    public class PioneerEffect : BaseCardEffect
    {
        private int m_indexValue = 0;

        private int m_value = 0;

        private int m_added = 0;

        public PioneerEffect(int index, CardBuffInfo info)
			: base(eCardEffectType.PioneerDeck, info)
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
			PioneerEffect effect = living.CardEffectList.GetOfType(eCardEffectType.PioneerDeck) as PioneerEffect;
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
				player.AddMaxBlood(-m_value);
				m_added = 0;
			}
			if (player.Game is PVPGame && (player.Game as PVPGame).IsMatchOrFreedom())
			{
				player.AddMaxBlood(m_value);
				m_added = m_value;
			}
        }
    }
}
