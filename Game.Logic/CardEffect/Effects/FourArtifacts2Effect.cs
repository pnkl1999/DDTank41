using Game.Logic.CardEffects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.CardEffect.Effects
{
    public class FourArtifacts2Effect : BaseCardEffect
    {
        private int m_indexValue = 0;

        private int m_value = 0;

        public FourArtifacts2Effect(int index, CardBuffInfo info)
			: base(eCardEffectType.FourArtifacts2, info)
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
			FourArtifacts2Effect effect = living.CardEffectList.GetOfType(eCardEffectType.FourArtifacts2) as FourArtifacts2Effect;
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
			player.AfterKillingLiving += Player_AfterKillingLiving;
        }

        private void Player_AfterKillingLiving(Living living, Living target, int damageAmount, int criticalAmount)
        {
			if (living.Game is PVPGame && (living.Game as PVPGame).IsMatchOrFreedom())
			{
				(living as Player).AddDander(m_value);
			}
        }

        private void ChangeProperty(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
			if (living.Game is PVPGame && (living.Game as PVPGame).IsMatchOrFreedom())
			{
				(living as Player).AddDander(m_value);
			}
        }
    }
}
