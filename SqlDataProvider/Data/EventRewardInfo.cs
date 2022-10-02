using System.Collections.Generic;

namespace SqlDataProvider.Data
{
    public class EventRewardInfo
    {
        public int ActivityType { get; set; }

        public List<EventRewardGoodsInfo> AwardLists { get; set; }

        public int Condition { get; set; }

        public int SubActivityType { get; set; }
    }
}
