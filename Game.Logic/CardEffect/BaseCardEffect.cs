using Game.Logic.CardEffect;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.CardEffects
{
    public class BaseCardEffect : AbstractCardEffect
    {
        public BaseCardEffect(eCardEffectType type, CardBuffInfo info)
			: base(type, info)
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

        public sealed override void OnAttached(Living living)
        {
			if (living is Player)
			{
				OnAttachedToPlayer(living as Player);
			}
        }

        public sealed override void OnRemoved(Living living)
        {
			if (living is Player)
			{
				OnRemovedFromPlayer(living as Player);
			}
        }

        public sealed override void OnPaused(Living living)
        {
			if (living is Player)
			{
				OnPausedOnPlayer(living as Player);
			}
        }

        protected virtual void OnAttachedToPlayer(Player player)
        {
        }

        protected virtual void OnRemovedFromPlayer(Player player)
        {
        }

        protected virtual void OnPausedOnPlayer(Player player)
        {
        }
    }
}
