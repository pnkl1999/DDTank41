using System;

namespace SqlDataProvider.Data
{
    public class LogItem
    {
        public int ApplicationId { get; set; }

        public string BeginProperty { get; set; }

        public string EndProperty { get; set; }

        public DateTime EnterTime { get; set; }

        public int ItemID { get; set; }

        public string ItemName { get; set; }

        public int LineId { get; set; }

        public int Operation { get; set; }

        public int Result { get; set; }

        public int SubId { get; set; }

        public int UserId { get; set; }
    }
}
