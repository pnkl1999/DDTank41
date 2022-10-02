using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ProtoBuf;

namespace SqlDataProvider.Data
{
    [ProtoContract]
    public class MinesManageDataInfo
    {
        [ProtoMember(1)]
        public List<MineManageItemInfo> ListShopDrop;

        [ProtoMember(2)]
        public List<MineManageExchangeInfo> ListShopExchange;

        [ProtoMember(3)]
        public DateTime LastTimeChange;
    }
}
