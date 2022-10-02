using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class EveryDayActiveProgressInfo
    {
        public int ID { get; set; }
        public string ActiveName { get; set; }
        public string ActiveTime { get; set; }
        public string Count { get; set; }
        public string Description { get; set; }
        public int JumpType { get; set; }
        public int LevelLimit { get; set; }
        public string DayOfWeek { get; set; }
    }
}