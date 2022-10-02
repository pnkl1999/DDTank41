using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class ContinueReduceBloodEquipEffect : BasePlayerEffect
    {
        private int m_blood = 0;

        private int m_probability = 0;

        public ContinueReduceBloodEquipEffect(int blood, int probability)
			: base(eEffectType.ContinueReduceBloodEquipEffect)
        {
			m_blood = blood;
			m_probability = probability;
        }

        public override bool Start(Living living)
        {
			ContinueReduceBloodEquipEffect effect = living.EffectList.GetOfType(eEffectType.ContinueReduceBloodEquipEffect) as ContinueReduceBloodEquipEffect;
			if (effect != null)
			{
				effect.m_probability = ((m_probability > effect.m_probability) ? m_probability : effect.m_probability);
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.PlayerShoot += ChangeProperty;
			player.AfterKillingLiving += player_AfterKillingLiving;
        }

        protected void player_AfterKillingLiving(Living living, Living target, int damageAmount, int criticalAmount)
        {
			if (IsTrigger)
			{
				target.AddEffect(new ContinueReduceBloodEffect(2, m_blood, living), 0);
			}
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.PlayerShoot -= ChangeProperty;
			player.AfterKillingLiving -= player_AfterKillingLiving;
        }

        private void ChangeProperty(Player player)
        {
			IsTrigger = false;
			if (!player.CurrentBall.IsSpecial() && rand.Next(100) < m_probability && player.AttackGemLimit == 0)
			{
				player.AttackGemLimit = 4;
				IsTrigger = true;
				player.EffectTrigger = true;
				player.Game.SendEquipEffect(player, LanguageMgr.GetTranslation("AttackEffect.Success"));
				player.Game.AddAction(new LivingSayAction(player, LanguageMgr.GetTranslation("ContinueReduceBloodEquipEffect.msg"), 9, 0, 1000));
			}
        }
    }
}
