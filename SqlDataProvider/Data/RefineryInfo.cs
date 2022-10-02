using System.Collections.Generic;

namespace SqlDataProvider.Data
{
    public class RefineryInfo
    {
        public List<int> m_Equip = new List<int>();

        public List<int> m_Reward = new List<int>();

        public int Item1 { get; set; }

        public int Item1Count { get; set; }

        public int Item2 { get; set; }

        public int Item2Count { get; set; }

        public int Item3 { get; set; }

        public int Item3Count { get; set; }

        public int Item4 { get; set; }

        public int Item4Count { get; set; }

        public int RefineryID { get; set; }
    }
}
