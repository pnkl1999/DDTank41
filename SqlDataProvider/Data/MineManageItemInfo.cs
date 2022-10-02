using ProtoBuf;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    [ProtoContract]
    public class MineManageItemInfo
    {
        [ProtoMember(1)]
        public int TemplateID;

        [ProtoMember(2)]
        public int MaxCount;

        [ProtoMember(3)]
        public int CurrentCount;

        [ProtoMember(4)]
        public int Price;
    }
}
