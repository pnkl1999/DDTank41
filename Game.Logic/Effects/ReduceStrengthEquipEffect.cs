using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class ReduceStrengthEquipEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probability = 0;

        public ReduceStrengthEquipEffect(int count, int probability)
			: base(eEffectType.ReduceStrengthEquipEffect)
        {
			m_count = count;
			m_probability = probability;
        }

        public override bool Start(Living living)
        {
			ReduceStrengthEquipEffect effect = living.EffectList.GetOfType(eEffectType.ReduceStrengthEquipEffect) as ReduceStrengthEquipEffect;
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

        private void player_AfterKillingLiving(Living living, Living target, int damageAmount, int criticalAmount)
        {
			if (IsTrigger)
			{
				target.AddEffect(new ReduceStrengthEffect(2, m_count), 0);
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
				player.Game.AddAction(new LivingSayAction(player, LanguageMgr.GetTranslation("ReduceStrengthEquipEffect.msg"), 9, 0, 1000));
			}
        }
    }
}
