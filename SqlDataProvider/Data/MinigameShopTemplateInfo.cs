using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class MinigameShopTemplateInfo
    {
        public int ID { get; set; }
        public int ItemID { get; set; }
        public int Count { get; set; }
        public bool IsBind { get; set; }
        public int Price { get; set; }
        public int LimitCount { get; set; }
        public int Type { get; set; }
        public int Valid { get; set; }
    }
}
