namespace Game.Logic.Effects
{
    public class IceFronzeEffect : AbstractEffect
    {
        private int m_count;

        public IceFronzeEffect(int count)
			: base(eEffectType.IceFronzeEffect)
        {
			m_count = count;
        }

        public override void OnAttached(Living living)
        {
			living.BeginSelfTurn += player_BeginFitting;
			living.IsFrost = true;
        }

        public override void OnRemoved(Living living)
        {
			living.BeginSelfTurn -= player_BeginFitting;
			living.IsFrost = false;
        }

        private void player_BeginFitting(Living player)
        {
			m_count--;
			if (m_count < 0)
			{
				Stop();
			}
        }

        public override bool Start(Living living)
        {
			IceFronzeEffect ofType = living.EffectList.GetOfType(eEffectType.IceFronzeEffect) as IceFronzeEffect;
			if (ofType != null)
			{
				ofType.m_count = m_count;
				return true;
			}
			return base.Start(living);
        }
    }
}
