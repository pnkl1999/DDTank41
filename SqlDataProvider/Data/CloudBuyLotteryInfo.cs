using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class CloudBuyLotteryInfo
    {
        public int ID { get; set; }
        public int GroupId { get; set; }
        public int templateId { get; set; }
        public int templatedIdCount { get; set; }
        public int validDate { get; set; }
        public string property { get; set; }
        public string buyItemsArr { get; set; }
        public int buyMoney { get; set; }
        public int maxNum { get; set; }
        public int currentNum { get; set; }
    }
}
