using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(46, "物品强化")]
	public class BuyGiftBagHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = 650*3;
			if (client.Player.PlayerCharacter.Money < num)
			{
				client.Player.SendMessage($"Thao ta\u0301c thâ\u0301t ba\u0323i.");
				return 0;
			}
			if (client.Player.RemoveMoney(num) > 0)
			{
				client.Player.ClearStoreBagWithOutPlace(5);
				ItemInfo itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(11023), 1, 101);
				itemInfo.Count = 1;
				itemInfo.ValidDate = 0;
				itemInfo.IsBinds = true;
				client.Player.StoreBag.AddItemTo(itemInfo, 0);
				itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(11023), 1, 101);
				itemInfo.Count = 1;
				itemInfo.ValidDate = 0;
				itemInfo.IsBinds = true;
				client.Player.StoreBag.AddItemTo(itemInfo, 1);
				itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(11023), 1, 101);
				itemInfo.Count = 1;
				itemInfo.ValidDate = 0;
				itemInfo.IsBinds = true;
				client.Player.StoreBag.AddItemTo(itemInfo, 2);
				itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(11020), 1, 101);
				itemInfo.Count = 1;
				itemInfo.ValidDate = 0;
				itemInfo.IsBinds = true;
				client.Player.StoreBag.AddItemTo(itemInfo, 3);
				itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(11018), 1, 101);
				itemInfo.Count = 1;
				itemInfo.ValidDate = 0;
				itemInfo.IsBinds = true;
				client.Player.StoreBag.AddItemTo(itemInfo, 4);
				client.Player.SendMessage($"Mua tha\u0300nh công tu\u0301i qua\u0300 cươ\u0300ng ho\u0301a!");
			}
			return 0;
        }
    }
}
