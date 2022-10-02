using ProtoBuf;
using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class ActivitySystemItemInfo
    {
        public int ID;
        public int ActivityType { get; set; }
        public int Quality { get; set; }
        public int Probability { get; set; }
        public int TemplateID { get; set; }
        public int ValidDate { get; set; }
        public int Count { get; set; }
        public bool IsBind { get; set; }
        public int StrengthLevel { get; set; }
        public int AttackCompose { get; set; }
        public int DefendCompose { get; set; }
        public int AgilityCompose { get; set; }
        public int LuckCompose { get; set; }
    }
}
