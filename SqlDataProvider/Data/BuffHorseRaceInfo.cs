using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SqlDataProvider.Data
{
    public class BuffHorseRaceInfo
    {
        public BuffHorseRaceInfo() { }
        public BuffHorseRaceInfo(int type, int vaildDate)
        {
            UserID = 0;
            OwerID = 0;
            Type = type;
            VaildTime = vaildDate;
            StartTime = DateTime.Now;
        }
        public int UserID { get; set; }
        public int OwerID { get; set; }
        public int Type { get; set; }
        public DateTime StartTime { get; set; }
        public int VaildTime { get; set; }
    }
}
