using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class TreasurePuzzleRewardInfo
    {
        public int PuzzleID { get; set; }
        public int TemplateID { get; set; }
        public int Count { get; set; }
        public int ValidDate { get; set; }
        public int StrengthenLevel { get; set; }
        public int AttackCompose { get; set; }
        public int DefendCompose { get; set; }
        public int AgilityCompose { get; set; }
        public int LuckCompose { get; set; }
        public bool IsBinds { get; set; }
    }
}
