using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class AddDanderEquipEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probability = 0;

        public AddDanderEquipEffect(int count, int probability)
			: base(eEffectType.AddDander)
        {
			m_count = count;
			m_probability = probability;
        }

        public override bool Start(Living living)
        {
			AddDanderEquipEffect effect = living.EffectList.GetOfType(eEffectType.AddDander) as AddDanderEquipEffect;
			if (effect != null)
			{
				m_probability = ((m_probability > effect.m_probability) ? m_probability : effect.m_probability);
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.BeginAttacked += ChangeProperty;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.BeginAttacked -= ChangeProperty;
        }

        private void ChangeProperty(Living living)
        {
			IsTrigger = false;
			if (rand.Next(100) < m_probability && living.DefendGemLimit == 0)
			{
				living.DefendGemLimit = 3;
				IsTrigger = true;
				if (living is Player)
				{
					(living as Player).AddDander(m_count);
				}
				living.EffectTrigger = true;
				living.Game.SendEquipEffect(living, LanguageMgr.GetTranslation("DefenceEffect.Success"));
				living.Game.AddAction(new LivingSayAction(living, LanguageMgr.GetTranslation("AddDanderEquipEffect.msg"), 9, 0, 1000));
			}
        }
    }
}
