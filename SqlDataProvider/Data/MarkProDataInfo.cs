using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class MarkProDataInfo
    {
        public MarkProDataInfo()
        {
            type = 0;
            value = 0;
            attachValue = 0;
            hummerCount = 0;
        }
        public MarkProDataInfo(int _type, int _value)
        {
            type = _type;
            value = _value;
        }
        public int type { get; set; }
        public int value { get; set; }
        public int attachValue { get; set; }
        public int hummerCount { get; set; }
    }
}
