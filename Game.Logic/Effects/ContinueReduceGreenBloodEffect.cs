using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class ContinueReduceGreenBloodEffect : AbstractEffect
    {
        private int int_0;

        private int int_1;

        private Living yktowyBbie;

        public ContinueReduceGreenBloodEffect(int count, int blood, Living liv)
			: base(eEffectType.ContinueReduceGreenBloodEffect)
        {
			int_0 = count;
			int_1 = blood;
			yktowyBbie = liv;
        }

        private void method_0(Living living_0)
        {
			int_0--;
			if (int_0 < 0)
			{
				Stop();
				return;
			}
			living_0.AddBlood(-int_1, 1);
			if (living_0.Blood > 0)
			{
				return;
			}
			living_0.Die();
			if (yktowyBbie != null && yktowyBbie is Player)
			{
				int type = 2;
				if (living_0 is Player)
				{
					type = 1;
				}
				(yktowyBbie as Player).PlayerDetail.OnKillingLiving(yktowyBbie.Game, type, living_0.Id, living_0.IsLiving, int_1);
			}
        }

        public override void OnAttached(Living living)
        {
			living.BeginSelfTurn += method_0;
			living.Game.method_47(living, 28, bool_0: true);
        }

        public override void OnRemoved(Living living)
        {
			living.BeginSelfTurn -= method_0;
			living.Game.method_47(living, 28, bool_0: false);
        }

        public override bool Start(Living living)
        {
			ContinueReduceGreenBloodEffect ofType = living.EffectList.GetOfType(eEffectType.ContinueReduceGreenBloodEffect) as ContinueReduceGreenBloodEffect;
			if (ofType != null)
			{
				ofType.int_0 = int_0;
				return true;
			}
			return base.Start(living);
        }
    }
}
