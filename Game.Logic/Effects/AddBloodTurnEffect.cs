using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class AddBloodTurnEffect : BasePlayerEffect
    {
        private int int_0;

        private int int_1;

        public AddBloodTurnEffect(int count, int probability)
			: base(eEffectType.AddBloodTurnEffect)
        {
			int_0 = count;
			int_1 = probability;
        }

        public override bool Start(Living living)
        {
			AddBloodTurnEffect addBloodTurnEffect = living.EffectList.GetOfType(eEffectType.AddBloodTurnEffect) as AddBloodTurnEffect;
			if (addBloodTurnEffect != null)
			{
				addBloodTurnEffect.int_1 = int_1;
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.BeginSelfTurn += method_0;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.BeginSelfTurn -= method_0;
        }

        private void method_0(Living living_0)
        {
			int_1--;
			if (int_1 < 0)
			{
				Stop();
			}
			else
			{
				living_0.Blood += int_0;
			}
        }
    }
}
