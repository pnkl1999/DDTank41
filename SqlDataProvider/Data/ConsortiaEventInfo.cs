using System;

namespace SqlDataProvider.Data
{
    public class ConsortiaEventInfo
    {
        public int ID { get; set; }

        public int ConsortiaID { get; set; }

        public DateTime Date { get; set; }

        public int Type { get; set; }

        public string NickName { get; set; }

        public int EventValue { get; set; }

        public string ManagerName { get; set; }

        public bool IsExist { get; set; }
    }
}
