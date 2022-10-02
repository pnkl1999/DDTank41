using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class GoodsCollectInfo
    {
        public int ID { get; set; }
        public int Type { get; set; }
        public int TemplateID { get; set; }
        public int Count { get; set; }
        public int ValidDate { get; set; }
        public bool IsBind { get; set; }
        public string GetFrom { get; set; }
        public string SondNode { get; set; }
    }
}
