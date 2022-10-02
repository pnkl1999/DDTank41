using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class AssimilateDamageEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probability = 0;

        public AssimilateDamageEffect(int count, int probability)
			: base(eEffectType.AssimilateDamageEffect)
        {
			m_count = count;
			m_probability = probability;
        }

        public override bool Start(Living living)
        {
			AssimilateDamageEffect effect = living.EffectList.GetOfType(eEffectType.AssimilateDamageEffect) as AssimilateDamageEffect;
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
            int rnd = rand.Next(100);
			IsTrigger = false;
			if (rnd < m_probability && living.DefendGemLimit == 0)
			{
				living.DefendGemLimit = 3;
				IsTrigger = true;
				living.EffectTrigger = true;
				living.SyncAtTime = true;
				if (damageAmount > m_count)
				{
					living.AddBlood(m_count);
				}
				else
				{
					living.AddBlood(damageAmount);
				}
				living.SyncAtTime = false;
				damageAmount -= damageAmount;
				criticalAmount -= criticalAmount;
				living.Game.AddAction(new LivingSayAction(living, LanguageMgr.GetTranslation("AssimilateDamageEffect.msg"), 9, 0, 1000));
				living.Game.SendEquipEffect(living, LanguageMgr.GetTranslation("DefenceEffect.Success"));
			}
        }
    }
}
