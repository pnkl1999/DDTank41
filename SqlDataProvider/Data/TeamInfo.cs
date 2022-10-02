using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class TeamInfo
    {
        public int TeamID { get; set; }
        public string Name { get; set; }
        public string Tag { get; set; }
        public int Division { get; set; }
        public int Grade { get; set; }
        public int Score { get; set; }
        public int Active { get; set; }
        public int TotalActive { get; set; }
        public int MaxActive { get; set; }
        public DateTime CreateDate { get; set; }
        public int WinTime { get; set; }
        public int TotalTime { get; set; }
        public int Rank { get; set; }
        public int Season { get; set; }
        public string SeasonInfo { get; set; }
        public int Member { get; set; }
        public int TotalMember { get; set; }
        public int CreatorID { get; set; }
        public string CreatorName { get; set; }
        public int ChairmanID { get; set; }
        public string ChairmanName { get; set; }
        public bool IsExits { get; set; }
        public Dictionary<int, TeamUserInfo> ListUsers { get; set; }
    }
}
