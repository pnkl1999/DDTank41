using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class RecoverBloodEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probability = 0;

        public RecoverBloodEffect(int count, int probability)
			: base(eEffectType.RecoverBloodEffect)
        {
			m_count = count;
			m_probability = probability;
        }

        public override bool Start(Living living)
        {
			RecoverBloodEffect recoverBloodEffect = living.EffectList.GetOfType(eEffectType.RecoverBloodEffect) as RecoverBloodEffect;
			if (recoverBloodEffect == null)
			{
				return base.Start(living);
			}
			m_probability = ((m_probability > recoverBloodEffect.m_probability) ? m_probability : recoverBloodEffect.m_probability);
			return true;
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.AfterKilledByLiving += ChangeProperty;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.AfterKilledByLiving -= ChangeProperty;
        }

        public void ChangeProperty(Living living, Living target, int damageAmount, int criticalAmount)
        {
			if (living.IsLiving)
			{
				IsTrigger = false;
				if (rand.Next(100) < m_probability && living.DefendGemLimit == 0)
				{
					living.DefendGemLimit = 3;
					IsTrigger = true;
					living.EffectTrigger = true;
					living.SyncAtTime = true;
					living.AddBlood(m_count);
					living.SyncAtTime = false;
					living.Game.SendEquipEffect(living, LanguageMgr.GetTranslation("DefenceEffect.Success"));
					living.Game.AddAction(new LivingSayAction(living, LanguageMgr.GetTranslation("RecoverBloodEffect.msg"), 9, 0, 1000));
				}
			}
        }
    }
}
