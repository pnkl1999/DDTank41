using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class Phongan : AbstractEffect
    {
        private int m_count;

        public Phongan(int count)
			: base(eEffectType.PhongAn)
        {
			m_count = count;
        }

        public override void OnAttached(Living living)
        {
			living.BeginSelfTurn += player_BeginFitting;
			living.Game.SendPlayerPicture(living, 2, state: true);
        }

        public override void OnRemoved(Living living)
        {
			living.BeginSelfTurn -= player_BeginFitting;
			living.Game.SendPlayerPicture(living, 2, state: false);
        }

        private void player_BeginFitting(Living living)
        {
			Player player = null;
			m_count--;
			if (living is Player)
			{
				player = living as Player;
				player.capnhatstate("silencedSpecial", "true");
				player.IconPicture(eMirariType.Lockstate, result: true);
				player.State = 9;
			}
			if (m_count < 0)
			{
				if (player != null)
				{
					player.capnhatstate("silencedSpecial", "false");
					player.IconPicture(eMirariType.ReversePlayer, result: true);
					player.State = 0;
				}
				Stop();
			}
        }

        public override bool Start(Living living)
        {
			Phongan ofType = living.EffectList.GetOfType(eEffectType.PhongAn) as Phongan;
			if (ofType != null)
			{
				ofType.m_count = m_count;
				return true;
			}
			return base.Start(living);
        }
    }
}
