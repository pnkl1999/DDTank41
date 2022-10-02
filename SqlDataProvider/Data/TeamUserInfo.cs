using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class TeamUserInfo
    {
        public int UserID { get; set; }
        public int TeamID { get; set; }
        public string NickName { get; set; }
        public int type { get; set; }
        public int activeScore { get; set; }
        public int weekActiveScore { get; set; }
        public int totalActiveScore { get; set; }
        public int seasonActiveScore { get; set; }
        public int teamSocre { get; set; }
        public int totalTiems { get; set; }
        public DateTime SignDate { get; set; }
    }
}
