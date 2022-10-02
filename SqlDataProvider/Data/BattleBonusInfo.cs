using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class BattleBonusInfo
    {
        public int ID { get; set; }
        public int Rate { get; set; }
        public int MinValue { get; set; }
        public int MaxValue { get; set; }
        public DateTime BeginTime { get; set; }
        public DateTime EndTime { get; set; }
        public string Notice { get; set; }
        public int TemplateID { get; set; }
        public int Type { get; set; }
        public bool IsLog { get; set; }
        public bool IsBinds { get; set; }
        public int ValidDate { get; set; }
        public int StrengthenLevel { get; set; }
        public int AttackCompose { get; set; }
        public int DefendCompose { get; set; }
        public int AgilityCompose { get; set; }
        public int LuckCompose { get; set; }
        public int Random { get; set; }
        public int MagicAttack { get; set; }
        public int MagicDefence { get; set; }
        public bool HasValidate { get; set; }
        public int goldValidate { get; set; }
        public string Detail { get; set; }
        public bool DisableRandom { get; set; }
        public bool IsExist { get; set; }
               
        public bool ValiddateHour()
        {
            if (HasValidate == false)
                return true;

            if (BeginTime.Date > DateTime.Now.Date || EndTime.Date < DateTime.Now.Date)
                return false;

            return BeginTime.Hour <= DateTime.Now.Hour && EndTime.Hour > DateTime.Now.Hour;
        }

    }
}

