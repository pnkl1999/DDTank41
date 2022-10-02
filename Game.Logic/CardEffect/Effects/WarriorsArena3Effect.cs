using Game.Logic.CardEffects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.CardEffect.Effects
{
    public class WarriorsArena3Effect : BaseCardEffect
    {
        private int m_indexValue = 0;

        private int m_value = 0;

        private int m_added = 0;

        public WarriorsArena3Effect(int index, CardBuffInfo info)
			: base(eCardEffectType.WarriorsArena3, info)
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
			WarriorsArena3Effect effect = living.CardEffectList.GetOfType(eCardEffectType.WarriorsArena3) as WarriorsArena3Effect;
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
			if (player.Game is PVEGame && (player.Game as PVEGame).Info.ID == 13)
			{
				player.AddMaxBlood(m_value);
				m_added = m_value;
			}
        }
    }
}
