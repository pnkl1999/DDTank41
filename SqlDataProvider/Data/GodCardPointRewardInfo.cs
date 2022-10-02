using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class GodCardPointRewardInfo
    {
        public int ID { get; set; }
        public int Count { get; set; }
        public bool IsBind { get; set; }
        public int ItemID { get; set; }
        public int Point { get; set; }
        public int Valid { get; set; }
    }
}