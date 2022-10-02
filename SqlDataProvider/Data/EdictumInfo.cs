using System;

namespace SqlDataProvider.Data
{
    public class EdictumInfo
    {
        public DateTime BeginDate { get; set; }

        public DateTime BeginTime { get; set; }

        public DateTime EndDate { get; set; }

        public DateTime EndTime { get; set; }

        public int ID { get; set; }

        public bool IsExist { get; set; }

        public string Text { get; set; }

        public string Title { get; set; }
    }
}
