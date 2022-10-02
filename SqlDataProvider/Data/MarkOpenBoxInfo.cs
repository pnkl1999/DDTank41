using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class MarkOpenBoxInfo
    {
        public int ID { get; set; }
        public int Type { get; set; }
        public int TemplateID { get; set; }
        public int BornLevel { get; set; }
        public bool IsBind { get; set; }
        public int Random { get; set; }
    }
}
