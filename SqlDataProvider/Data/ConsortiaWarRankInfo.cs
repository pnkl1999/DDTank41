using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class ConsortiaWarRankInfo
    {
        public int ConsortiaID { get; set; }
        public string ConsortiaName { get; set; }
        public int Rank { get; set; }
        public int Score { get; set; }
        public DateTime TimeCreate { get; set; }
    }
}
