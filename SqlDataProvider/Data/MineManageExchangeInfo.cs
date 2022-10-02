using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ProtoBuf;

namespace SqlDataProvider.Data
{
    [ProtoContract]
    public class MineManageExchangeInfo
    {
        [ProtoMember(1)]
        public int ID;

        [ProtoMember(16)]
        public int activityType;

        [ProtoMember(2)]
        public int Quality;

        [ProtoMember(3)]
        public int TemplateID;

        [ProtoMember(4)]
        public string Name;

        [ProtoMember(5)]
        public int Price;

        [ProtoMember(6)]
        public int strengthLevel;

        [ProtoMember(7)]
        public int attackCompose;

        [ProtoMember(8)]
        public int defendCompose;

        [ProtoMember(9)]
        public int agilityCompose;

        [ProtoMember(10)]
        public int luckCompose;

        [ProtoMember(11)]
        public bool isBind;

        [ProtoMember(12)]
        public int validDate;

        [ProtoMember(13)]
        public int Count;

        [ProtoMember(14)]
        public int Position;

        [ProtoMember(15)]
        public int LimitCount;
    }
}
