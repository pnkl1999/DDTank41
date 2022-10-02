using Game.Logic.CardEffects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.CardEffect.Effects
{
    public class GuluSportsMeeting2Effect : BaseCardEffect
    {
        private int m_indexValue = 0;

        private int m_value = 0;

        private int m_added = 0;

        public int CureValue=> m_added;

        public GuluSportsMeeting2Effect(int index, CardBuffInfo info)
			: base(eCardEffectType.GuluSportsMeeting2, info)
        {
			m_indexValue = index;
			string[] values = info.Value.Split('|');
			if (m_indexValue < values.Length)
			{
				m_value = int.Parse(values[m_indexValue]);
			}
        }

        public override bool Start(Living living)
        {
			GuluSportsMeeting2Effect effect = living.CardEffectList.GetOfType(eCardEffectType.GuluSportsMeeting2) as GuluSportsMeeting2Effect;
			if (effect != null)
			{
				return true;
			}
			return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
			player.PlayerCure += ChangeProperty;
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
			player.PlayerCure -= ChangeProperty;
        }

        private void ChangeProperty(Player player)
        {
			if (m_added != 0)
			{
				m_added = 0;
			}
			if (player.Game is PVEGame && (player.Game as PVEGame).Info.ID == 6)
			{
				m_added = m_value;
			}
        }
    }
}
