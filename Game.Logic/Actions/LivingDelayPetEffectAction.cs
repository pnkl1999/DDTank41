using Game.Logic.PetEffects;

namespace Game.Logic.Actions
{
    public class LivingDelayPetEffectAction : BaseAction
    {
        private AbstractPetEffect abstractPetEffect_0;

        private Living living_0;

        public LivingDelayPetEffectAction(Living living, AbstractPetEffect effect, int delay)
			: base(delay)
        {
			abstractPetEffect_0 = effect;
			living_0 = living;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			abstractPetEffect_0.Start(living_0);
			Finish(tick);
        }
    }
}
