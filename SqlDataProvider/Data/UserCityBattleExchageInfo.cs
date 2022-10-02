using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class UserCityBattleExchageInfo
    {
        public UserCityBattleExchageInfo Clone()
        {
            UserCityBattleExchageInfo clone = new UserCityBattleExchageInfo();
            clone.ID = ID;
            clone.Count = Count;

            return clone;
        }
        public int ID { get; set; }
        public int Count { get; set; }
    }
}
