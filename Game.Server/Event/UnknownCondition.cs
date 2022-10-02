using SqlDataProvider.Data;

namespace Game.Server.Event
{
    public class UnknownCondition : EventCondition
    {
        public UnknownCondition(EventLiveInfo eventL, GamePlayer player)
			: base(eventL, player)
        {
        }
    }
}
