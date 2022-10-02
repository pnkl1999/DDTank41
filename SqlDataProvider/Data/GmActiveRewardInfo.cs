using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class GmActiveRewardInfo
    {
        public string giftId { get; set; }
        public int templateId { get; set; }
        public int count { get; set; }
        public int isBind { get; set; }
        public int occupationOrSex { get; set; }
        public int rewardType { get; set; }
        public int validDate { get; set; }
        public string property { get; set; }
        public string remain1 { get; set; }
    }
}
