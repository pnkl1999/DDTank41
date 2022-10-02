using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class RankTemplateInfo
    {
        public int ID { get; set; }
        public string Rank { get; set; }
        public int Attack { get; set; }
        public int Defend { get; set; }
        public int Agility { get; set; }
        public int Lucky { get; set; }
    }
}
