using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class UserCityBattleInfo
    {
        public int UserID { get; set; }
        public int ZoneID { get; set; }
        public string ZoneName { get; set; }
        public string NickName { get; set; }
        public int Score { get; set; }
        public int myScore { get; set; }
        public int Team { get; set; }
        public int Rank { get; set; }
        public bool Sex { get; set; }
        public int Hide { get; set; }
        public string Style { get; set; }
        public string Colors { get; set; }
        public string Skin { get; set; }
        public List<UserCityBattleExchageInfo> ExchangeInfo { get; set; }
    }
}
