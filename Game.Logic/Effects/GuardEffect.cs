namespace Game.Logic.Effects
{
    public class GuardEffect : AbstractEffect
    {
        private int m_count;

        public GuardEffect(int count)
			: base(eEffectType.GuardEffect)
        {
			m_count = count;
        }

        public override void OnAttached(Living living)
        {
			living.BeginSelfTurn += player_BeginFitting;
			living.Game.SendPlayerPicture(living, 30, state: true);
        }

        public override void OnRemoved(Living living)
        {
			living.BeginSelfTurn -= player_BeginFitting;
			living.Game.SendPlayerPicture(living, 30, state: false);
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
			GuardEffect ofType = living.EffectList.GetOfType(eEffectType.GuardEffect) as GuardEffect;
			if (ofType != null)
			{
				ofType.m_count = m_count;
				return true;
			}
			return base.Start(living);
        }
    }
}
