using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class RuneAdvanceTemplateInfo
    {
        public int AdvancedTempId { get; set; }
        public string RuneName { get; set; }
        public string MainMaterials { get; set; }
        public int Quality { get; set; }
        public int MaxLevelTempRunId { get; set; }
        public string AuxiliaryMaterials { get; set; }
        public string AdvanceDesc { get; set; }
    }
}
