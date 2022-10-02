using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class ArmorPiercerEquipEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probability = 0;

        public ArmorPiercerEquipEffect(int count, int probability)
			: base(eEffectType.ArmorPiercer)
        {
			m_count = count;
			m_probability = probability;
        }

        public override bool Start(Living living)
        {
			ArmorPiercerEquipEffect effect = living.EffectList.GetOfType(eEffectType.ArmorPiercer) as ArmorPiercerEquipEffect;
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
			player.AfterPlayerShooted += player_AfterPlayerShooted;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.PlayerShoot += ChangeProperty;
			player.AfterPlayerShooted -= player_AfterPlayerShooted;
        }

        private void player_AfterPlayerShooted(Player player)
        {
			player.FlyingPartical = 0;
			player.IgnoreArmor = false;
        }

        private void ChangeProperty(Player player)
        {
			IsTrigger = false;
			if (!player.CurrentBall.IsSpecial() && rand.Next(100) < m_probability && player.AttackGemLimit == 0 && rand.Next(100) < m_probability)
			{
				player.AttackGemLimit = 5;
				player.FlyingPartical = 65;
				player.IgnoreArmor = true;
				player.EffectTrigger = true;
				player.Game.SendEquipEffect(player, LanguageMgr.GetTranslation("AttackEffect.Success"));
				player.Game.AddAction(new LivingSayAction(player, LanguageMgr.GetTranslation("ArmorPiercerEquipEffect.msg"), 9, 0, 1000));
			}
        }
    }
}
