using Bussiness;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public class AddAgilityEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probablity = 0;

        private int m_added = 0;

        public AddAgilityEffect(int count, int probability)
			: base(eEffectType.AddAgilityEffect)
        {
			m_count = count;
			m_probablity = probability;
        }

        public override bool Start(Living living)
        {
			AddAgilityEffect effect = living.EffectList.GetOfType(eEffectType.AddAgilityEffect) as AddAgilityEffect;
			if (effect != null)
			{
				m_probablity = ((m_probablity > effect.m_probablity) ? m_probablity : effect.m_probablity);
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.BeginAttacking += ChangeProperty;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.BeginAttacking -= ChangeProperty;
        }

        private void ChangeProperty(Living living)
        {
			living.Agility -= m_added;
			m_added = 0;
			IsTrigger = false;
			if (rand.Next(100) < m_probablity)
			{
				living.EffectTrigger = true;
				IsTrigger = true;
				living.Agility += m_count;
				m_added = m_count;
				living.Game.SendEquipEffect(living, LanguageMgr.GetTranslation("AddAgilityEffect.Success", m_count));
			}
        }
    }
}
