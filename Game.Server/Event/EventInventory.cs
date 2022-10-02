using Bussiness.Managers;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Event
{
    public class EventInventory
    {
        private object m_lock;

        private GamePlayer m_player;

        public EventInventory(GamePlayer player)
        {
			m_player = player;
			m_lock = new object();
        }

        public void LoadFromDatabase()
        {
			lock (m_lock)
			{
				foreach (EventLiveInfo item in EventLiveMgr.GetAllEventInfo())
				{
					if (item.StartDate < DateTime.Now && item.EndDate > DateTime.Now)
					{
						EventCondition.CreateCondition(item, m_player);
					}
				}
			}
        }
    }
}
