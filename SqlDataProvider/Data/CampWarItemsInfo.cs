using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class CampWarItemsInfo
    {
        public int ID { get; set; }
        public int MinRank { get; set; }
        public int MaxRank { get; set; }
        public bool IsCamp { get; set; }
        public int ItemID { get; set; }
        public int Valid { get; set; }
        public int Count { get; set; }
        public int StrengthenLevel { get; set; }
        public int AttackCompose { get; set; }
        public int DefendCompose { get; set; }
        public int AgilityCompose { get; set; }
        public int LuckCompose { get; set; }
        public bool IsBind { get; set; }
    }
}
