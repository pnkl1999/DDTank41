using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class FatalEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probability = 0;

        private int m_saycount = 0;

        public FatalEffect(int count, int probability)
			: base(eEffectType.FatalEffect)
        {
			m_count = count;
			m_probability = probability;
        }

        public override bool Start(Living living)
        {
			FatalEffect effect = living.EffectList.GetOfType(eEffectType.FatalEffect) as FatalEffect;
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
			player.TakePlayerDamage += player_BeforeTakeDamage;
			player.BeginNextTurn += player_BeginNextTurn;
			player.AfterPlayerShooted += player_AfterPlayerShooted;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.PlayerShoot -= ChangeProperty;
			player.TakePlayerDamage -= player_BeforeTakeDamage;
			player.BeginNextTurn -= player_BeginNextTurn;
			player.AfterPlayerShooted -= player_AfterPlayerShooted;
        }

        private void player_AfterPlayerShooted(Player player)
        {
			IsTrigger = false;
			player.ControlBall = false;
			player.EffectTrigger = false;
        }

        private void player_BeginNextTurn(Living living)
        {
			m_saycount = 0;
        }

        private void player_BeforeTakeDamage(Living living, Living source, ref int damageAmount, ref int criticalAmount)
        {
			if (IsTrigger && living is Player && m_probability != 15112004)
			{
				damageAmount = damageAmount * (100 - m_count) / 100;
			}
        }

        private void ChangeProperty(Player player)
        {
			m_saycount++;
			IsTrigger = false;
			if (m_probability == 15112004)
			{
				if (!player.CurrentBall.IsSpecial())
				{
					player.ShootMovieDelay = 50;
					IsTrigger = true;
					if (player.CurrentBall.ID != 3)
					{
						player.ControlBall = true;
					}
					if (m_saycount == 1)
					{
						player.EffectTrigger = true;
						player.Game.SendEquipEffect(player, "Tân thủ nên được quyền lợi hiệu ứng dẫn đường!");
					}
				}
			}
			else
			{
				if (!player.CurrentBall.IsSpecial() && rand.Next(100) < m_probability && player.AttackGemLimit == 0)
				{
					player.AttackGemLimit = 4;
					player.ShootMovieDelay = 50;
					IsTrigger = true;
					if (player.CurrentBall.ID != 3)
					{
						player.ControlBall = true;
					}
					if (m_saycount == 1)
					{
						player.EffectTrigger = true;
						player.Game.SendEquipEffect(player, LanguageMgr.GetTranslation("AttackEffect.Success"));
						player.Game.AddAction(new LivingSayAction(player, LanguageMgr.GetTranslation("FatalEffect.msg"), 9, 0, 1000));
					}
				}
			}
        }
    }
}
