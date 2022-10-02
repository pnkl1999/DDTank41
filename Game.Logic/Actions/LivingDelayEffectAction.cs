using Game.Logic.Effects;

namespace Game.Logic.Actions
{
    public class LivingDelayEffectAction : BaseAction
    {
        private AbstractEffect m_effect;

        private Living m_living;

        public LivingDelayEffectAction(Living living, AbstractEffect effect, int delay)
			: base(delay)
        {
			m_effect = effect;
			m_living = living;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			m_effect.Start(m_living);
			Finish(tick);
        }
    }
}
