using System;

namespace SqlDataProvider.Data
{
    public class EventLiveInfo : DataObject
    {
        public int EventID { get; set; }

        public string Description { get; set; }

        public int CondictionType { get; set; }

        public int Condiction_Para1 { get; set; }

        public int Condiction_Para2 { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }
    }
}
