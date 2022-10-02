using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class BombKingRewardInfo
    {
        public int ID { get; set; }
        public int ItemId { get; set; }
        public int Count { get; set; }
        public int Valid { get; set; }
        public int Strengthen { get; set; }
        public int Attack { get; set; }
        public int Defend { get; set; }
        public int Agility { get; set; }
        public int Luck { get; set; }
        public int Week { get; set; }
        public int Type { get; set; }
        public string Note { get; set; }
    }
}
