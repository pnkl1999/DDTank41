using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class AddLuckyEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probability = 0;

        private int m_added = 0;

        public AddLuckyEffect(int count, int probability)
			: base(eEffectType.AddLuckyEffect)
        {
			m_count = count;
			m_probability = probability;
			m_added = 0;
        }

        public override bool Start(Living living)
        {
			AddLuckyEffect effect = living.EffectList.GetOfType(eEffectType.AddLuckyEffect) as AddLuckyEffect;
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
			player.PlayerShoot -= ChangeProperty;
			player.AfterPlayerShooted -= player_AfterPlayerShooted;
        }

        private void player_AfterPlayerShooted(Player player)
        {
			player.FlyingPartical = 0;
        }

        private void ChangeProperty(Player player)
        {
			player.Lucky -= m_added;
			m_added = 0;
			IsTrigger = false;
			if (!player.CurrentBall.IsSpecial() && rand.Next(100) < m_probability && player.AttackGemLimit == 0)
			{
				player.AttackGemLimit = 4;
				player.FlyingPartical = 65;
				IsTrigger = true;
				player.Lucky += m_count;
				player.EffectTrigger = true;
				m_added = m_count;
				player.Game.SendEquipEffect(player, LanguageMgr.GetTranslation("AttackEffect.Success"));
				player.Game.AddAction(new LivingSayAction(player, LanguageMgr.GetTranslation("AddLuckyEffect.msg"), 9, 0, 1000));
			}
        }
    }
}
