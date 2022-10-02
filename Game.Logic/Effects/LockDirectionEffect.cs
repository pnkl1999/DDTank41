namespace Game.Logic.Effects
{
    public class LockDirectionEffect : AbstractEffect
    {
        private int m_count;

        public LockDirectionEffect(int count)
			: base(eEffectType.LockDirectionEffect)
        {
			m_count = count;
        }

        public override bool Start(Living living)
        {
			LockDirectionEffect effect = living.EffectList.GetOfType(eEffectType.LockDirectionEffect) as LockDirectionEffect;
			if (effect != null)
			{
				effect.m_count = m_count;
				return true;
			}
			return base.Start(living);
        }

        public override void OnAttached(Living living)
        {
			living.BeginSelfTurn += player_BeginFitting;
			living.Game.SendPlayerPicture(living, 3, state: true);
        }

        public override void OnRemoved(Living living)
        {
			living.BeginSelfTurn -= player_BeginFitting;
			living.Game.SendPlayerPicture(living, 3, state: false);
        }

        private void player_BeginFitting(Living living)
        {
			m_count--;
			if (m_count < 0)
			{
				Stop();
			}
        }
    }
}
