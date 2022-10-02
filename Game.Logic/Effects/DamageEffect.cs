namespace Game.Logic.Effects
{
    public class DamageEffect : AbstractEffect
    {
        private int m_count;

        public DamageEffect(int count)
			: base(eEffectType.DamageEffect)
        {
			m_count = count;
        }

        public override void OnAttached(Living living)
        {
			living.BeginSelfTurn += player_BeginFitting;
			living.Game.SendPlayerPicture(living, 29, state: true);
        }

        public override void OnRemoved(Living living)
        {
			living.BeginSelfTurn -= player_BeginFitting;
			living.Game.SendPlayerPicture(living, 29, state: false);
        }

        private void player_BeginFitting(Living living)
        {
			m_count--;
			if (m_count <= 0)
			{
				Stop();
			}
        }

        public override bool Start(Living living)
        {
			DamageEffect ofType = living.EffectList.GetOfType(eEffectType.DamageEffect) as DamageEffect;
			if (ofType != null)
			{
				ofType.m_count = m_count;
				return true;
			}
			return base.Start(living);
        }
    }
}
