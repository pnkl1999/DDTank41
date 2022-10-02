using System;

namespace SqlDataProvider.Data
{
    public class AcademyRequestInfo
    {
        public int SenderID { get; set; }

        public int ReceiderID { get; set; }

        public int Type { get; set; }

        public DateTime CreateTime { get; set; }
    }
}
