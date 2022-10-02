using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class ConsortiaWithTaskInfo
    {
        public int ID { get; set; }
        public DateTime BeginTime { get; set; }
        public int ConsortiaID { get; set; }
        public int Contribution { get; set; }
        public int Expirience { get; set; }
        public int Offer { get; set; }
        public int BuffID { get; set; }
        public int Level { get; set; }
        public int Riches { get; set; }
        public int Time { get; set; }
        public string ConditionData { get; set; }
        public string RankTable { get; set; }
       
    }
}

