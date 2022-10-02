using ProtoBuf;
using System.Collections.Generic;

namespace SqlDataProvider.Data
{
    [ProtoContract]
	public class WorldMgrDataInfo
    {
        [ProtoMember(1)]
		public Dictionary<int, ShopFreeCountInfo> ShopFreeCount;
    }
}
