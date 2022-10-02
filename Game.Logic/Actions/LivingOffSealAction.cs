using Game.Logic.Effects;

namespace Game.Logic.Actions
{
    public class LivingOffSealAction : BaseAction
    {
        private Living m_Living;

        private Living m_Target;

        public LivingOffSealAction(Living Living, Living target, int delay)
			: base(delay, 1000)
        {
			m_Living = Living;
			m_Target = target;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			((SealEffect)m_Target.EffectList.GetOfType(eEffectType.SealEffect))?.Stop();
			Finish(tick);
        }
    }
}
