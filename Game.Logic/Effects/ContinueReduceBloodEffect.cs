using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class ContinueReduceBloodEffect : AbstractEffect
    {
        private int m_count;

        private int m_blood;

        private Living m_liv;

        public ContinueReduceBloodEffect(int count, int blood, Living liv)
			: base(eEffectType.ContinueReduceBloodEffect)
        {
			m_count = count;
			m_blood = blood;
			m_liv = liv;
        }

        public override bool Start(Living living)
        {
			ContinueReduceBloodEffect effect = living.EffectList.GetOfType(eEffectType.ContinueReduceBloodEffect) as ContinueReduceBloodEffect;
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
			living.Game.SendPlayerPicture(living, 2, state: true);
        }

        public override void OnRemoved(Living living)
        {
			living.BeginSelfTurn -= player_BeginFitting;
			living.Game.SendPlayerPicture(living, 2, state: false);
        }

        private void player_BeginFitting(Living living)
        {
			m_count--;
			if (m_count < 0)
			{
				Stop();
				return;
			}
			IceFronzeEffect effect = living.EffectList.GetOfType(eEffectType.IceFronzeEffect) as IceFronzeEffect;
			if (living is SimpleBoss && living.Config.IsHelper && effect != null)//check npc đang bị băng 
				return;
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
    }
}
