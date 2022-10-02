using Bussiness.Managers;
using Game.Logic;
using SqlDataProvider.Data;

namespace Game.Server.Event
{
    public class GameKillCondition : EventCondition
    {
        public GameKillCondition(EventLiveInfo eventLive, GamePlayer player)
			: base(eventLive, player)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.AfterKillingLiving += player_AfterKillingLiving;
        }

        private void player_AfterKillingLiving(AbstractGame game, int type, int id, bool isLiving, int demage, bool isSpanArea)
        {
			m_event = EventLiveMgr.GetSingleEvent(m_event.EventID);
			if (isLiving || type != 1)
			{
				return;
			}
			switch (game.GameType)
			{
			case eGameType.Free:
				if (m_event.Condiction_Para1 == 0)
				{
					m_player.playersKilled++;
					if (m_player.playersKilled >= m_event.Condiction_Para2)
					{
						m_player.SendEventLiveRewards(m_event);
						m_player.playersKilled = 0;
					}
				}
				break;
			case eGameType.Guild:
				if (m_event.Condiction_Para1 == 1)
				{
					m_player.playersKilled++;
					if (m_player.playersKilled >= m_event.Condiction_Para2)
					{
						m_player.SendEventLiveRewards(m_event);
						m_player.playersKilled = 0;
					}
				}
				break;
			case eGameType.ALL:
				if (m_event.Condiction_Para1 == 2)
				{
					m_player.playersKilled++;
					if (m_player.playersKilled >= m_event.Condiction_Para2)
					{
						m_player.SendEventLiveRewards(m_event);
						m_player.playersKilled = 0;
					}
				}
				break;
			case eGameType.Training:
			case eGameType.Boss:
				break;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.AfterKillingLiving -= player_AfterKillingLiving;
        }
    }
}
