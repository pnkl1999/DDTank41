using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class ConsortiaWarPlayerRankInfo
    {
        public int UserID { get; set; }
        public string NickName { get; set; }
        public int ConsortiaID { get; set; }
        public int Score { get; set; }
        public string ZoneName { get; set; }
        public int ZoneID { get; set; }
        public DateTime TimeCreate { get; set; }
    }
}
