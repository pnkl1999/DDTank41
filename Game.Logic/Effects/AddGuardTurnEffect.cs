using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class AddGuardTurnEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probability = 0;

        public AddGuardTurnEffect(int count, int probability)
			: base(eEffectType.AddGuardTurnEffect)
        {
			m_count = count;
			m_probability = probability;
        }

        public override bool Start(Living living)
        {
			AddGuardTurnEffect effect = living.EffectList.GetOfType(eEffectType.AddGuardTurnEffect) as AddGuardTurnEffect;
			if (effect != null)
			{
				m_probability = ((m_probability > effect.m_probability) ? m_probability : effect.m_probability);
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.BeforeTakeDamage += player_BeforeTakeDamage;
			player.BeginSelfTurn += player_SelfTurn;
			player.Game.SendPlayerPicture(player, 30, state: true);
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.BeforeTakeDamage -= player_BeforeTakeDamage;
			player.BeginSelfTurn -= player_SelfTurn;
			player.Game.SendPlayerPicture(player, 30, state: false);
        }

        private void player_AfterPlayerShooted(Player player)
        {
			player.FlyingPartical = 0;
        }

        private void player_BeforeTakeDamage(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
			damageAmount -= m_count;
			if (damageAmount <= 0)
			{
				damageAmount = 1;
			}
        }

        private void player_SelfTurn(Living living)
        {
			m_probability--;
			if (m_probability < 0)
			{
				Stop();
			}
        }
    }
}
