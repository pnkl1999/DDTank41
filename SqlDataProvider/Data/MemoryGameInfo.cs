using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class MemoryGameInfo
    {
        public int TemplateID { get; set; }
        public int count { get; set; }
        public int place1 { get; set; }
        public int place2 { get; set; }
        public bool isGet { get; set; }
        public bool show1 { get; set; }
        public bool show2 { get; set; }

    }
}
