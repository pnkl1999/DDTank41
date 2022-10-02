using System;
using System.Collections.Generic;
using System.Text;
namespace SqlDataProvider.Data
{
    public class CloudBuyLogInfo
    {
        public int ID { get; set; }
        public int UserID { get; set; }
        public string nickName { get; set; }
        public int templateId { get; set; }
        public int validate { get; set; }
        public int count { get; set; }
        public string property { get; set; }
    }
}