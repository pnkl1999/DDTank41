using System;

namespace SqlDataProvider.Data
{
    public class ActiveConditionInfo
    {
        public int ActiveID { get; set; }

        public string AwardId { get; set; }

        public int Condition { get; set; }

        public int Conditiontype { get; set; }

        public DateTime EndTime { get; set; }

        public int ID { get; set; }

        public bool IsMult { get; set; }

        public string LimitGrade { get; set; }

        public DateTime StartTime { get; set; }
    }
}
