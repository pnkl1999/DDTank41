using System;

namespace SqlDataProvider.Data
{
    public class SubActiveInfo
    {
        public int ActiveID { get; set; }

        public string ActiveInfo { get; set; }

        public DateTime EndDate { get; set; }

        public DateTime EndTime { get; set; }

        public int ID { get; set; }

        public bool IsContinued { get; set; }

        public bool IsOpen { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime StartTime { get; set; }

        public int SubID { get; set; }
    }
}
