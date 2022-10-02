using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class BombKingPlayerInfo
    {
        public int UserID { get; set; }
        public int AreaID { get; set; }
        public int Place { get; set; }
        public string NickName { get; set; }
        public string AreaName { get; set; }
        public int vipType { get; set; }
        public int vipLevel { get; set; }
        public int myRank { get; set; }
        public int myScore { get; set; }
        public int Score { get; set; }
        public int RankType { get; set; }
        public int status { get; set; }
        public string style { get; set; }
        public string color { get; set; }
        public bool sex { get; set; }
        public string smg { get; set; }
    }
}
