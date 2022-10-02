namespace Game.Logic.Effects
{
    public class InvinciblyEffect : AbstractEffect
    {
        private int m_count;

        public InvinciblyEffect(int count)
			: base(eEffectType.InvinciblyEffect)
        {
			m_count = count;
        }

        public override void OnAttached(Living living)
        {
			living.BeginSelfTurn += player_BeginFitting;
        }

        public override void OnRemoved(Living living)
        {
			living.BeginSelfTurn -= player_BeginFitting;
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
			InvinciblyEffect ofType = living.EffectList.GetOfType(eEffectType.InvinciblyEffect) as InvinciblyEffect;
			if (ofType != null)
			{
				ofType.m_count = m_count;
				return true;
			}
			return base.Start(living);
        }
    }
}
