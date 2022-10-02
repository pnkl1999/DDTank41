using Game.Logic.CardEffects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.CardEffect.Effects
{
    public class AntCaveEffect : BaseCardEffect
    {
        private int m_indexValue = 0;

        private int m_value = 0;

        private int m_added = 0;

        public AntCaveEffect(int index, CardBuffInfo info)
			: base(eCardEffectType.AntCave, info)
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
			AntCaveEffect effect = living.CardEffectList.GetOfType(eCardEffectType.AntCave) as AntCaveEffect;
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
			if (player.Game is PVEGame && (player.Game as PVEGame).Info.ID == 2)
			{
				player.AddMaxBlood(m_value);
				m_added = m_value;
			}
        }
    }
}
