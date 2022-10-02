using System;

namespace SqlDataProvider.Data
{
    public class LogFight
    {
        public int ApplicationId { get; set; }

        public int FightType { get; set; }

        public int LineId { get; set; }

        public int MapId { get; set; }

        public DateTime PlayBegin { get; set; }

        public DateTime PlayEnd { get; set; }

        public string PlayResult { get; set; }

        public int RoomType { get; set; }

        public int SubId { get; set; }

        public int UserCount { get; set; }

        public string Users { get; set; }
    }
}
