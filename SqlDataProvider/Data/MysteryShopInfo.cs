using System;
using System.Collections.Generic;
using System.Text;
namespace SqlDataProvider.Data
{
    public class MysteryShopInfo
    {
        public int ID { get; set; }
        public int LableType { get; set; }
        public int InfoID { get; set; }
        public int Unit { get; set; }
        public int Num { get; set; }
        public int Price { get; set; }
        public int CanBuy { get; set; }
        public int Random { get; set; }
        public int Quality { get; set; }
    }
}