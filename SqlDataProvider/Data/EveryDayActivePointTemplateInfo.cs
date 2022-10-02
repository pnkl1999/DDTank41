using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class EveryDayActivePointTemplateInfo
    {
        public int ID { get; set; }
        public int MinLevel { get; set; }
        public int MaxLevel { get; set; }
        public int ActivityType { get; set; }
        public int JumpType { get; set; }
        public string Description { get; set; }
        public int Count { get; set; }
        public int ActivePoint { get; set; }
        public int MoneyPoint { get; set; }
    }
}
