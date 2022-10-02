using Bussiness.Managers;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Event
{
    public class PlayerLoginCondition : EventCondition
    {
        public PlayerLoginCondition(EventLiveInfo eventLive, GamePlayer player)
			: base(eventLive, player)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.PlayerLogin += player_Login;
        }

        private void player_Login()
        {
			m_event = EventLiveMgr.GetSingleEvent(m_event.EventID);
			if (m_event.Condiction_Para1 == 0 || (DateTime.Now - m_player.PlayerCharacter.NewDay).TotalDays >= (double)m_event.Condiction_Para1)
			{
				m_player.SendEventLiveRewards(m_event);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.PlayerLogin -= player_Login;
        }
    }
}
