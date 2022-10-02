namespace Game.Logic.Effects
{
    public class SealEffect : AbstractEffect
    {
        private int m_count;

        public SealEffect(int count)
			: base(eEffectType.SealEffect)
        {
			m_count = count;
        }

        public override void OnAttached(Living living)
        {
			living.BeginSelfTurn += player_BeginFitting;
			living.SetSeal(state: true);
        }

        public override void OnRemoved(Living living)
        {
			living.BeginSelfTurn -= player_BeginFitting;
			living.SetSeal(state: false);
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
			SealEffect ofType = living.EffectList.GetOfType(eEffectType.SealEffect) as SealEffect;
			if (ofType != null)
			{
				ofType.m_count = m_count;
				return true;
			}
			return base.Start(living);
        }
    }
}
