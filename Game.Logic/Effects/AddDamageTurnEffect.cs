using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class AddDamageTurnEffect : BasePlayerEffect
    {
        private int int_0;

        private int int_1;

        public AddDamageTurnEffect(int count, int probability)
			: base(eEffectType.AddDamageTurnEffect)
        {
			int_0 = count;
			int_1 = probability;
        }

        public override bool Start(Living living)
        {
			AddDamageTurnEffect addDamageTurnEffect = living.EffectList.GetOfType(eEffectType.AddDamageTurnEffect) as AddDamageTurnEffect;
			if (addDamageTurnEffect != null)
			{
				int_1 = ((int_1 > addDamageTurnEffect.int_1) ? int_1 : addDamageTurnEffect.int_1);
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.TakePlayerDamage += method_1;
			player.AfterPlayerShooted += method_0;
			player.BeginSelfTurn += method_2;
			player.Game.method_59(player, 29, bool_1: true);
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.TakePlayerDamage -= method_1;
			player.AfterPlayerShooted -= method_0;
			player.BeginSelfTurn -= method_2;
			player.Game.method_59(player, 29, bool_1: false);
        }

        private void method_0(Player player_0)
        {
			player_0.FlyingPartical = 0;
        }

        private void method_1(Living living_0, Living living_1, ref int int_2, ref int int_3)
        {
			if (IsTrigger)
			{
				int_2 += int_0;
			}
        }

        private void method_2(Living living_0)
        {
			int_1--;
			if (int_1 < 0)
			{
				Stop();
			}
        }
    }
}
