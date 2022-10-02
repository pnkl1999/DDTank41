using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class ContinueReduceBlood : AbstractEffect
    {
        private int m_blood;

        private int m_count;

        private Living m_liv;

        public ContinueReduceBlood(int count, int blood, Living liv)
			: base(eEffectType.ContinueReduceBlood)
        {
			m_count = count;
			m_blood = blood;
			m_liv = liv;
        }

        public override void OnAttached(Living living)
        {
			living.BeginSelfTurn += player_BeginFitting;
			living.Game.SendPlayerPicture(living, 28, state: true);
        }

        public override void OnRemoved(Living living)
        {
			living.BeginSelfTurn -= player_BeginFitting;
			living.Game.SendPlayerPicture(living, 28, state: false);
        }

        private void player_BeginFitting(Living living)
        {
			m_count--;
			if (m_count < 0)
			{
				Stop();
				return;
			}
			living.AddBlood(-m_blood, 1);
			if (living.Blood <= 0)
			{
				living.Die();
				if (m_liv != null && m_liv is Player)
				{
					(m_liv as Player).PlayerDetail.OnKillingLiving(m_liv.Game, 2, living.Id, living.IsLiving, m_blood);
				}
			}
        }

        public override bool Start(Living living)
        {
			ContinueReduceBlood ofType = living.EffectList.GetOfType(eEffectType.ContinueReduceBlood) as ContinueReduceBlood;
			if (ofType != null)
			{
				ofType.m_count = m_count;
				return true;
			}
			return base.Start(living);
        }
    }
}
