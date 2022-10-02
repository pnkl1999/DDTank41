using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class CardsTakeOutInfo
    {
        public int templateID { get; set; }
        public int place { get; set; }
        public int count { get; set; }
        public bool IsTake { get; set; }
    }
}
