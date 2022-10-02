using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class BasePlayerEffect : AbstractEffect
    {
        public BasePlayerEffect(eEffectType type)
			: base(type)
        {
        }

        public sealed override void OnAttached(Living living)
        {
			if (living is Player)
			{
				OnAttachedToPlayer(living as Player);
			}
        }

        protected virtual void OnAttachedToPlayer(Player player)
        {
        }

        public sealed override void OnRemoved(Living living)
        {
			if (living is Player)
			{
				OnRemovedFromPlayer(living as Player);
			}
        }

        protected virtual void OnRemovedFromPlayer(Player player)
        {
        }

        public override bool Start(Living living)
        {
			if (living is Player)
			{
				return base.Start(living);
			}
			return false;
        }
    }
}
