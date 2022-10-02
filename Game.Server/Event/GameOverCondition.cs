using Bussiness.Managers;
using Game.Logic;
using SqlDataProvider.Data;

namespace Game.Server.Event
{
    public class GameOverCondition : EventCondition
    {
        public GameOverCondition(EventLiveInfo eventLive, GamePlayer player)
			: base(eventLive, player)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.MissionTurnOver += player_MissionOver;
        }

        private void player_MissionOver(AbstractGame game, int missionId, int turnCount)
        {
			m_event = EventLiveMgr.GetSingleEvent(m_event.EventID);
			if (missionId == m_event.Condiction_Para1 && game.GameType == eGameType.Dungeon)
			{
				m_player.SendEventLiveRewards(m_event);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.MissionTurnOver -= player_MissionOver;
        }
    }
}
