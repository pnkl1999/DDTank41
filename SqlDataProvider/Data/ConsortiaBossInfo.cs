using System;

namespace SqlDataProvider.Data
{
    public class ConsortiaBossInfo
    {
        public int ConsortiaID { get; set; }

        public int typeBoss { get; set; }

        public int callBossCount { get; set; }

        public int BossLevel { get; set; }

        public int Blood { get; set; }

        public DateTime LastOpenBoss { get; set; }

        public DateTime BossOpenTime { get; set; }

        public int powerPoint { get; set; }
    }
}
