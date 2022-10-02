using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Event
{
    public class ExerciseUpCondition : EventCondition
    {
        public ExerciseUpCondition(EventLiveInfo eventLive, GamePlayer player)
			: base(eventLive, player)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.AfterUsingItem += player_Exercise;
        }

        private void player_Exercise(int templateID, int count)
        {
			m_event = EventLiveMgr.GetSingleEvent(m_event.EventID);
			if (m_event.Condiction_Para1 == templateID)
			{
				m_player.SendEventLiveRewards(m_event);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.AfterUsingItem -= player_Exercise;
        }
    }
}
