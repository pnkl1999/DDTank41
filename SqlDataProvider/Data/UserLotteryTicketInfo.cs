using ProtoBuf;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    [ProtoContract]
    public class UserLotteryTicketInfo
    {
        [ProtoMember(1)]
        public int UserID;

        [ProtoMember(2)]
        public string NickName;

        [ProtoMember(3)]
        public int Grade;

        [ProtoMember(4)]
        public List<string> PoolList;

        [ProtoMember(5)]
        public int TotalPoolFirstWin;

        [ProtoMember(6)]
        public int TotalPoolSecondWin;

        [ProtoMember(7)]
        public int TotalPoolThreeWin;

        [ProtoMember(8)]
        public int TotalPoolFourWin;

        [ProtoMember(9)]
        public int TotalMoneyEat;
    }
}
