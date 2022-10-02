using Bussiness;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class ReflexDamageEquipEffect : BasePlayerEffect
    {
        private int m_count;

        private int m_probability;

        public ReflexDamageEquipEffect(int count, int probability)
			: base(eEffectType.ReflexDamageEquipEffect)
        {
			m_count = count;
			m_probability = probability;
        }

        public void ChangeProperty(Living living)
        {
			IsTrigger = false;
			if (rand.Next(100) < m_probability && living.DefendGemLimit == 0)
			{
				living.DefendGemLimit = 3;
				IsTrigger = true;
				living.EffectTrigger = true;
				living.Game.SendEquipEffect(living, LanguageMgr.GetTranslation("ReflexDamageEquipEffect.Success", m_count));
			}
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.BeginAttacked += ChangeProperty;
			player.AfterKilledByLiving += player_AfterKilledByLiving;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.BeginAttacked -= ChangeProperty;
        }

        private void player_AfterKilledByLiving(Living living, Living target, int damageAmount, int criticalAmount)
        {
			if (IsTrigger)
			{
				target.AddBlood(-m_count);
			}
        }

        public override bool Start(Living living)
        {
			ReflexDamageEquipEffect ofType = living.EffectList.GetOfType(eEffectType.ReflexDamageEquipEffect) as ReflexDamageEquipEffect;
			if (ofType != null)
			{
				ofType.m_probability = ((m_probability > ofType.m_probability) ? m_probability : ofType.m_probability);
				return true;
			}
			return base.Start(living);
        }
    }
}
