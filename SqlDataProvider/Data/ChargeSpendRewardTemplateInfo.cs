using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class ChargeSpendRewardTemplateInfo
    {
        public int ID { get; set; }
        public int RewardID { get; set; }
        public int RewardItemID { get; set; }
        public bool IsSelect { get; set; }
        public bool IsBind { get; set; }
        public int RewardItemValid { get; set; }
        public int RewardItemCount { get; set; }
        public int StrengthenLevel { get; set; }
        public int AttackCompose { get; set; }
        public int DefendCompose { get; set; }
        public int AgilityCompose { get; set; }
        public int LuckCompose { get; set; }
    }
}