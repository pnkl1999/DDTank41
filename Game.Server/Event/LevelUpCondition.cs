using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Event
{
    public class LevelUpCondition : EventCondition
    {
        public LevelUpCondition(EventLiveInfo eventLive, GamePlayer player)
			: base(eventLive, player)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.LevelUp += player_LevelUp;
        }

        private void player_LevelUp(GamePlayer player)
        {
			m_event = EventLiveMgr.GetSingleEvent(m_event.EventID);
			if (m_event.Condiction_Para1 == player.Level)
			{
				m_player.SendEventLiveRewards(m_event);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.LevelUp -= player_LevelUp;
        }
    }
}
