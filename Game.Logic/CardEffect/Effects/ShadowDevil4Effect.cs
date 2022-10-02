using Game.Logic.CardEffects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.CardEffect.Effects
{
    public class ShadowDevil4Effect : BaseCardEffect
    {
        private int m_indexValue = 0;

        private int m_value = 0;

        private int m_added = 0;

        public ShadowDevil4Effect(int index, CardBuffInfo info)
			: base(eCardEffectType.ShadowDevil4, info)
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
			ShadowDevil4Effect effect = living.CardEffectList.GetOfType(eCardEffectType.ShadowDevil4) as ShadowDevil4Effect;
			if (effect != null)
			{
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.AfterKillingLiving += Player_AfterKillingLiving;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.AfterKillingLiving -= Player_AfterKillingLiving;
        }

        private void Player_AfterKillingLiving(Living living, Living target, int damageAmount, int criticalAmount)
        {
			if (living.Game is PVEGame && (living.Game as PVEGame).Info.ID == 4 && criticalAmount > 0)
			{
				criticalAmount += m_value;
			}
        }
    }
}
