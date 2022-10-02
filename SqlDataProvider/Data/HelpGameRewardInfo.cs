using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class HelpGameRewardInfo
    {
        public int MissionID { get; set; }
        public int Star { get; set; }
        public int TemplateID { get; set; }
        public int StrengthenLevel { get; set; }
        public int AttackCompose { get; set; }
        public int DefendCompose { get; set; }
        public int AgilityCompose { get; set; }
        public int LuckCompose { get; set; }
        public int Count { get; set; }
        public bool IsBind { get; set; }
        public bool IsTime { get; set; }
        public int ValidDate { get; set; }
    }
}
