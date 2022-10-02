using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class CardAchievementInfo
    {
        public int AchievementID { get; set; }
        public int AddAttack { get; set; }
        public int AddBlood { get; set; }
        public int AddDamage { get; set; }
        public int AddDefend { get; set; }
        public int AddGuard { get; set; }
        public int AddLucky { get; set; }
        public int AddMagicAttack { get; set; }
        public int AddMagicDefend { get; set; }
        public string Desc { get; set; }
        public int Honor_id { get; set; }
        public int IsPrompt { get; set; }
        public string Name { get; set; }
        public int RequireGroupid { get; set; }
        public int RequireGroupNum { get; set; }
        public int RequireNum { get; set; }
        public int RequireType { get; set; }
        public int Type { get; set; }
    }
}