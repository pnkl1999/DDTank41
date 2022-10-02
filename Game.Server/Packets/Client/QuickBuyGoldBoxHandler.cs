using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler(126, "场景用户离开")]
	public class QuickBuyGoldBoxHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			packet.ReadBoolean();
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Bag.Locked"));
				return 1;
			}
			ShopItemInfo shopItemInfoById = ShopMgr.GetShopItemInfoById(1123301);
			ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(shopItemInfoById.TemplateID);
			int value = num * shopItemInfoById.AValue1;
			if (client.Player.MoneyDirect(value, IsAntiMult: false, false))
			{
				int point = 0;
				int gold = 0;
				int giftToken = 0;
				int medal = 0;
				int exp = 0;
				List<ItemInfo> itemInfos = new List<ItemInfo>();
				ItemBoxMgr.CreateItemBox(itemTemplateInfo.TemplateID, itemInfos, ref gold, ref point, ref giftToken, ref medal, ref exp);
				int value2 = num * gold;
				client.Player.AddGold(value2);
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Bạn nhận được " + value2 + " vàng từ rương vàng."));
			}
			return 0;
        }
    }
}
