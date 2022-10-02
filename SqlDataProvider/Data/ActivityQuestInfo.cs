using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SqlDataProvider.Data
{
    public class ActivityQuestInfo
    {
        public int ID { get; set; }
        public int QuestType { get; set; }
        public string Title { get; set; }
        public string Detail { get; set; }
        public string Objective { get; set; }
        public int NeedMinLevel { get; set; }
        public int NeedMaxLevel { get; set; }
        public int Period { get; set; }
    }
}
