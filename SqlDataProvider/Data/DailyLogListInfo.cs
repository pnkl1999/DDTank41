using System;

namespace SqlDataProvider.Data
{
    public class DailyLogListInfo
    {
        public string DayLog { get; set; }

        public int ID { get; set; }

        public DateTime LastDate { get; set; }

        public int UserAwardLog { get; set; }

        public int UserID { get; set; }
    }
}
