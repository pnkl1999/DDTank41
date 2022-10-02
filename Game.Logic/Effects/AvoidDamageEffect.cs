using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class AvoidDamageEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probability = 0;

        public AvoidDamageEffect(int count, int probability)
			: base(eEffectType.AvoidDamageEffect)
        {
			m_count = count;
			m_probability = probability;
        }

        public override bool Start(Living living)
        {
			AvoidDamageEffect effect = living.EffectList.GetOfType(eEffectType.AvoidDamageEffect) as AvoidDamageEffect;
			if (effect != null)
			{
				effect.m_probability = ((m_probability > effect.m_probability) ? m_probability : effect.m_probability);
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.BeforeTakeDamage += player_BeforeTakeDamage;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.BeforeTakeDamage -= player_BeforeTakeDamage;
        }

        private void player_BeforeTakeDamage(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
			IsTrigger = false;
			if (rand.Next(100) < m_probability && living.DefendGemLimit == 0)
			{
				living.DefendGemLimit = 3;
				IsTrigger = true;
				living.EffectTrigger = true;
				damageAmount = damageAmount * (100 - m_count) / 100;
				living.Game.SendEquipEffect(living, LanguageMgr.GetTranslation("DefenceEffect.Success"));
				living.Game.AddAction(new LivingSayAction(living, LanguageMgr.GetTranslation("AvoidDamageEffect.msg"), 9, 0, 1000));
			}
        }
    }
}
