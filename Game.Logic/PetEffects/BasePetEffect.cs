using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Logic.Phy.Object;

namespace Game.Logic.PetEffects
{
    public class BasePetEffect : AbstractPetEffect
    {
        public BasePetEffect(ePetEffectType type, string elementId) : base(type, elementId) { }
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
        protected virtual void OnAttachedToPlayer(Player player) { }
        protected virtual void OnRemovedFromPlayer(Player player) { }
        protected virtual void OnPausedOnPlayer(Player player) { }
    }
}
