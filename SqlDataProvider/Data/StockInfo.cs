using ProtoBuf;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    [ProtoContract]
    public class StockInfo
    {
        [ProtoMember(1)]
        public int StockID { get; set; }
        [ProtoMember(2)]
        public string StockName { get; set; }
        [ProtoMember(3)]
        public int BasePrice { get; set; }
        [ProtoMember(4)]
        public int CurrentPrice { get; set; }
        [ProtoMember(5)]
        public int FlowCoeffcient { get; set; }
        [ProtoMember(6)]
        public string TimelineData { get; set; }

        /*public List<StockTimeLineInfo> TimeLineList()
        {

        }*/
    }
}
