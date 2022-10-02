using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Event
{
    public class UseBalanceCondition : EventCondition
    {
        public UseBalanceCondition(EventLiveInfo eventLive, GamePlayer player)
			: base(eventLive, player)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.Paid += player_Shop;
        }

        private void player_Shop(int money, int gold, int offer, int gifttoken, int petScore, int medal, int damageScores, string payGoods)
        {
			m_event = EventLiveMgr.GetSingleEvent(m_event.EventID);
			if (m_event.Condiction_Para1 == 0 && money >= m_event.Condiction_Para2)
			{
				m_player.SendEventLiveRewards(m_event);
			}
			if (m_event.Condiction_Para1 == 1 && m_event.Condiction_Para2 >= gold)
			{
				m_player.SendEventLiveRewards(m_event);
			}
			if (m_event.Condiction_Para1 == 2 && m_event.Condiction_Para2 >= offer)
			{
				m_player.SendEventLiveRewards(m_event);
			}
			if (m_event.Condiction_Para1 == 3 && m_event.Condiction_Para2 >= gifttoken)
			{
				m_player.SendEventLiveRewards(m_event);
			}
			if (m_event.Condiction_Para1 == 4 && m_event.Condiction_Para2 >= medal)
			{
				m_player.SendEventLiveRewards(m_event);
			}
			if (m_event.Condiction_Para1 == 5 && m_event.Condiction_Para2 >= petScore)
			{
				m_player.SendEventLiveRewards(m_event);
			}
            if (m_event.Condiction_Para1 == 7 && m_event.Condiction_Para2 >= damageScores)
            {
				m_player.SendEventLiveRewards(m_event);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.Paid -= player_Shop;
        }
    }
}
