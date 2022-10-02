using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class AddBombEquipEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probability = 0;

        private bool m_show = false;

        public AddBombEquipEffect(int count, int probability)
			: base(eEffectType.AddBombEquipEffect)
        {
			m_count = count;
			m_probability = probability;
        }

        public override bool Start(Living living)
        {
			AddBombEquipEffect effect = living.EffectList.GetOfType(eEffectType.AddBombEquipEffect) as AddBombEquipEffect;
			if (effect != null)
			{
				m_probability = ((m_probability > effect.m_probability) ? m_probability : effect.m_probability);
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.PlayerShoot += playerShot;
			player.BeginAttacking += ChangeProperty;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.PlayerShoot -= playerShot;
			player.BeginAttacking -= ChangeProperty;
        }

        private void playerShot(Player player)
        {
			if (IsTrigger && m_show)
			{
				player.Game.AddAction(new LivingSayAction(player, LanguageMgr.GetTranslation("AddBombEquipEffect.msg"), 9, 0, 1000));
				player.Game.SendEquipEffect(player, LanguageMgr.GetTranslation("AttackEffect.Success"));
				m_show = false;
			}
        }

        private void ChangeProperty(Living living)
        {
			IsTrigger = false;
			if (!(living as Player).CurrentBall.IsSpecial() && rand.Next(100) < m_probability && living.AttackGemLimit == 0)
			{
				m_show = true;
				living.AttackGemLimit = 4;
				IsTrigger = true;
				(living as Player).ShootCount += m_count;
				living.EffectTrigger = true;
			}
        }
    }
}
