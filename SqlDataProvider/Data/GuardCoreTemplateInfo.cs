using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class GuardCoreTemplateInfo
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string TipsDescription { get; set; }
        public int Type { get; set; }
        public int GainGrade { get; set; }
        public int Parameter1 { get; set; }
        public int Parameter2 { get; set; }
        public int Parameter3 { get; set; }
        public int Parameter4 { get; set; }
        public int KeepTurn { get; set; }
        public int GroupType { get; set; }
        public int GuardGrade { get; set; }
        public int SkillGrade { get; set; }
    }
}

