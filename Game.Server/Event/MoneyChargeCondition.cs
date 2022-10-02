using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Event
{
    public class MoneyChargeCondition : EventCondition
    {
        public MoneyChargeCondition(EventLiveInfo eventLive, GamePlayer player)
			: base(eventLive, player)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.MoneyCharge += player_MoneyCharge;
        }

        private void player_MoneyCharge(int money)
        {
			m_event = EventLiveMgr.GetSingleEvent(m_event.EventID);
			if (money >= m_event.Condiction_Para1)
			{
				m_player.SendEventLiveRewards(m_event);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.MoneyCharge -= player_MoneyCharge;
        }
    }
}
