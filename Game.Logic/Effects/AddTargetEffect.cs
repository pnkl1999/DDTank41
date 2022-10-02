using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class AddTargetEffect : BasePlayerEffect
    {
        public AddTargetEffect()
			: base(eEffectType.AddTargetEffect)
        {
        }

        public override bool Start(Living living)
        {
			AddTargetEffect effect = living.EffectList.GetOfType(eEffectType.AddTargetEffect) as AddTargetEffect;
			if (effect != null)
			{
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.Game.SendPlayerPicture(player, 7, state: true);
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.Game.SendPlayerPicture(player, 7, state: false);
        }
    }
}
