using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class QiYuanAwardInfo
    {
        public int ID { get; set; }
        public int Type { get; set; }
        public int Rank { get; set; }
        public int TemplateID { get; set; }
        public int Count { get; set; }
        public bool IsBind { get; set; }
        public int VaildDate { get; set; }
        public int Probability { get; set; }
    }
}
