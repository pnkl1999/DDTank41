using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class AmuletPhaseItemInfo
    {
        public int AmuletLevel { get; set; }
        public int AvoidInjury { get; set; }
        public int Crit { get; set; }
        public int Expend { get; set; }
        public int Guard { get; set; }
        public int Kill { get; set; }
        public int LockPrice { get; set; }
        public int Phase { get; set; }
        public int Speed { get; set; }
        public int SunderArmor { get; set; }
        public int Tenacity { get; set; }
        public int ViolenceInjury { get; set; }
        public int WillFight { get; set; }

        public double GetProperty(int type, int value)
        {
            //Math.round(_loc4_ / 10000 * _loc8_["property" + _loc6_]);
            double property = 1;
            switch (type)
            {
                case 1:
                    property = Crit;
                    break;
                case 2:
                    property = Tenacity;
                    break;
                case 3:
                    property = SunderArmor;
                    break;
                case 4:
                    property = AvoidInjury;
                    break;
                case 5:
                    property = Kill;
                    break;
                case 6:
                    property = WillFight;
                    break;
                case 7:
                    property = ViolenceInjury;
                    break;
                case 8:
                    property = Guard;
                    break;
                case 9:
                    property = Speed;
                    break;
            }
            return  Math.Round((double)value / 10000 * property);
        }
    }
}