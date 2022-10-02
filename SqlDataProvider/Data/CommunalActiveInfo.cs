using System;

namespace SqlDataProvider.Data
{
    public class CommunalActiveInfo
    {
        public int ActiveID { get; set; }

        public string AddPropertyByMoney { get; set; }

        public string AddPropertyByProp { get; set; }

        public DateTime BeginTime { get; set; }

        public int DayMaxScore { get; set; }

        public DateTime EndTime { get; set; }

        public bool IsReset { get; set; }

        public bool IsSendAward { get; set; }

        public int LimitGrade { get; set; }

        public int MinScore { get; set; }
    }
}
