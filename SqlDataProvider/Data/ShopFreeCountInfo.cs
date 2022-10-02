using ProtoBuf;
using System;

namespace SqlDataProvider.Data
{
    [ProtoContract]
	public class ShopFreeCountInfo
    {
        [ProtoMember(1)]
		public int ShopID { get; set; }

        [ProtoMember(2)]
		public int Count { get; set; }

        [ProtoMember(3)]
		public DateTime CreateDate { get; set; }
    }
}
