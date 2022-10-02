using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler(168, "物品强化")]
	public class GoodsCountHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			List<ShopFreeCountInfo> allShopFreeCount = WorldMgr.GetAllShopFreeCount();
			client.Out.SendShopGoodsCountUpdate(allShopFreeCount);
			return 0;
        }
    }
}
