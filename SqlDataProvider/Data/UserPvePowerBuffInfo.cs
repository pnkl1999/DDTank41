using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class UserPvePowerBuffInfo
    {
        public int refreshCount { get; set; }
        public DateTime refreshDate { get; set; }
        public int getBuffCount { get; set; }
        public DateTime getBuffDate { get; set; }
        public int getBuffIndex { get; set; }
        public List<UserPvePowerBuffTempInfo> ListIndexBuff { get; set; }
        public int getBuffAtk { get; set; }
        public int getBuffDef { get; set; }
        public int getBuffAgl { get; set; }
        public int getBuffLuck { get; set; }
        public int getBuffDmg { get; set; }
        public int getBuffAr { get; set; }
        public int getBuffHp { get; set; }
        public int getBuffMAtk { get; set; }
        public int getBuffMDef { get; set; }

        public bool IsActive()
        {
            if(getBuffIndex >= 0 && getBuffDate.AddMinutes(30) > DateTime.Now)
            {
                return true;
            }
            return false;
        }
    }
}
