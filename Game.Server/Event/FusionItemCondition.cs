using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Event
{
    public class FusionItemCondition : EventCondition
    {
        public FusionItemCondition(EventLiveInfo eventLive, GamePlayer player)
			: base(eventLive, player)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.ItemFusion += player_ItemFusion;
        }

        private void player_ItemFusion(int templateID)
        {
			m_event = EventLiveMgr.GetSingleEvent(m_event.EventID);
			if (m_event.Condiction_Para1 == templateID)
			{
				m_player.SendEventLiveRewards(m_event);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.ItemFusion -= player_ItemFusion;
        }
    }
}
