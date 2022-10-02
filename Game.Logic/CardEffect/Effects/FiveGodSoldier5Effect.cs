using Game.Logic.CardEffects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.CardEffect.Effects
{
    public class FiveGodSoldier5Effect : BaseCardEffect
    {
        private int m_indexValue = 0;

        private int m_value = 0;

        private int m_added = 0;

        public FiveGodSoldier5Effect(int index, CardBuffInfo info)
			: base(eCardEffectType.FiveGodSoldier5, info)
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
			FiveGodSoldier5Effect effect = living.CardEffectList.GetOfType(eCardEffectType.FiveGodSoldier5) as FiveGodSoldier5Effect;
			if (effect != null)
			{
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.AfterKilledByLiving += Player_AfterKilledByLiving;
        }

        private void Player_AfterKilledByLiving(Living player, Living target, int damageAmount, int criticalAmount)
        {
			m_added = damageAmount * m_value / 100;
			if (!(player.Game is PVPGame) || !(player.Game as PVPGame).IsMatchOrFreedom() || m_added <= 0)
			{
				return;
			}
			target.SyncAtTime = true;
			target.AddBlood(-m_added, 1);
			target.SyncAtTime = false;
			if (target.Blood <= 0)
			{
				target.Die();
				if (player != null && player is Player)
				{
					(player as Player).PlayerDetail.OnKillingLiving(player.Game, 2, target.Id, target.IsLiving, m_added);
				}
			}
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.AfterKilledByLiving -= Player_AfterKilledByLiving;
        }

        private void ChangeProperty(Player player)
        {
			if (m_added != 0)
			{
				player.BaseDamage -= m_added;
				player.BaseGuard -= m_added;
				m_added = 0;
			}
			if (player.Game is PVPGame && (player.Game as PVPGame).IsMatchOrFreedom())
			{
				m_added = m_value;
				player.BaseDamage += m_added;
				player.BaseGuard += m_added;
			}
        }
    }
}
