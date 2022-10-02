using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class ButtonConfigInfo
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Text { get; set; }
        public bool IsShow { get; set; }
        public bool IsClose { get; set; }
    }
}