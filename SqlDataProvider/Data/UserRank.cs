using System;

namespace SqlDataProvider.Data
{
    public class UserRank
    {
        public DateTime EndDate { get; set; }

        public string Rank { get; set; }

        public DateTime StartDate { get; set; }

        public int Type { get; set; }

        public int UserID { get; set; }
    }
}
