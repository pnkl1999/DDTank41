using Bussiness.Managers;
using log4net;
using SqlDataProvider.Data;
using System.Reflection;

namespace Game.Server.Event
{
    public class EventCondition
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected EventLiveInfo m_event;

        protected GamePlayer m_player;

        public EventCondition(EventLiveInfo eventLive, GamePlayer player)
        {
			m_event = EventLiveMgr.GetSingleEvent(eventLive.EventID);
			m_player = player;
        }

        public virtual void AddTrigger(GamePlayer player)
        {
        }

        public static EventCondition CreateCondition(EventLiveInfo eventLive, GamePlayer player)
        {
			return eventLive.CondictionType switch
			{
				1 => new EventStrengthenCondition(eventLive, player), 
				2 => new GameOverCondition(eventLive, player), 
				3 => new MoneyChargeCondition(eventLive, player), 
				4 => new GameKillCondition(eventLive, player), 
				5 => new PlayerLoginCondition(eventLive, player), 
				6 => new UseBalanceCondition(eventLive, player), 
				7 => new FusionItemCondition(eventLive, player), 
				8 => new LevelUpCondition(eventLive, player), 
				_ => new UnknownCondition(eventLive, player), 
			};
        }

        public virtual void RemoveTrigger(GamePlayer player)
        {
        }
    }
}
