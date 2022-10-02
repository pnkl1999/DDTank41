using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class GmActivityInfo
    {
        public string activityId { get; set; }
        public string activityName { get; set; }
        public int activityType { get; set; }
        public int activityChildType { get; set; }
        public int getWay { get; set; }
        public string desc { get; set; }
        public string rewardDesc { get; set; }
        public DateTime beginTime { get; set; }
        public DateTime beginShowTime { get; set; }
        public DateTime endTime { get; set; }
        public DateTime endShowTime { get; set; }
        public int icon { get; set; }
        public int isContinue { get; set; }
        public int status { get; set; }
        public int remain1 { get; set; }
        public string remain2 { get; set; }
    }
}
