using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Event
{
    public class EventStrengthenCondition : EventCondition
    {
        public EventStrengthenCondition(EventLiveInfo eventLive, GamePlayer player)
			: base(eventLive, player)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.ItemStrengthen += player_ItemStrengthen;
        }

        private void player_ItemStrengthen(int categoryID, int level)
        {
			m_event = EventLiveMgr.GetSingleEvent(m_event.EventID);
			if (m_event.Condiction_Para1 == categoryID && m_event.Condiction_Para2 == level)
			{
				m_player.SendEventLiveRewards(m_event);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.ItemStrengthen -= player_ItemStrengthen;
        }
    }
}
