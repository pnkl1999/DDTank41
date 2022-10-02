namespace Game.Logic.Effects
{
    public class HideEffect : AbstractEffect
    {
        private int m_count;

        public HideEffect(int count)
			: base(eEffectType.HideEffect)
        {
			m_count = count;
        }

        public override void OnAttached(Living living)
        {
			living.BeginSelfTurn += player_BeginFitting;
			living.IsHide = true;
        }

        public override void OnRemoved(Living living)
        {
			living.BeginSelfTurn += player_BeginFitting;
			living.IsHide = false;
        }

        private void player_BeginFitting(Living player)
        {
			m_count--;
			if (m_count <= 0)
			{
				Stop();
			}
        }

        public override bool Start(Living living)
        {
			HideEffect ofType = living.EffectList.GetOfType(eEffectType.HideEffect) as HideEffect;
			if (ofType != null)
			{
				ofType.m_count = m_count;
				return true;
			}
			return base.Start(living);
        }
    }
}
