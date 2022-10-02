using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class MinorPlayerInfo
    {
        public int value => ID;

        public string caption => NickName;

        public int ID { get; set; }

        public string UserName { get; set; }

        public string NickName { get; set; }
    }
}
