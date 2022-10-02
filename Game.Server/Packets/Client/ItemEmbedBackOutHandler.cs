using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Statics;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.ITEM_EMBED_BACKOUT, "物品比较")]
	public class ItemEmbedBackOutHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			GSPacketIn pkg = packet.Clone();
			pkg.ClearContext();
			int holeNum = packet.ReadInt();
			int templateId = packet.ReadInt();
			int mustGold = 500;
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			if (client.Player.PlayerCharacter.Money + client.Player.PlayerCharacter.MoneyLock < mustGold && !client.Player.isPlayerWarrior())
			{
				client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("ItemComposeHandler.NoMoney"));
				return 0;
			}
			if (client.Player.PropBag.CountTotalEmptySlot() <= 0)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"));
				return 0;
			}
			ItemInfo storeBag = client.Player.GetInventory(eBageType.Store).GetItemAt(0);
			ItemTemplateInfo goods = ItemMgr.FindItemTemplate(templateId);
			if (goods == null)
			{
				return 11;
			}
			bool result = false;
			switch (holeNum)
			{
			case 1:
				if (storeBag.Hole1 > 0 && goods.TemplateID == storeBag.Hole1)
				{
					storeBag.Hole1 = 0;
					result = true;
				}
				break;
			case 2:
				if (storeBag.Hole2 > 0 && goods.TemplateID == storeBag.Hole2)
				{
					storeBag.Hole2 = 0;
					result = true;
				}
				break;
			case 3:
				if (storeBag.Hole3 > 0 && goods.TemplateID == storeBag.Hole3)
				{
					storeBag.Hole3 = 0;
					result = true;
				}
				break;
			case 4:
				if (storeBag.Hole4 > 0 && goods.TemplateID == storeBag.Hole4)
				{
					storeBag.Hole4 = 0;
					result = true;
				}
				break;
			case 5:
				if (storeBag.Hole5 > 0 && goods.TemplateID == storeBag.Hole5)
				{
					storeBag.Hole5 = 0;
					result = true;
				}
				break;
			case 6:
				if (storeBag.Hole6 > 0 && goods.TemplateID == storeBag.Hole6)
				{
					storeBag.Hole6 = 0;
					result = true;
				}
				break;
			default:
				return 1;
			}
			if (result)
			{
				pkg.WriteInt(0);
				client.Player.BeginChanges();
				ItemInfo gem = ItemInfo.CreateFromTemplate(goods, 1, (int)ItemAddType.Buy);
				gem.IsBinds = true;
				gem.ValidDate = 0;
				if (!client.Player.AddItem(gem))
				{
					GamePlayer player = client.Player;
					List<ItemInfo> items = new List<ItemInfo>
					{
						gem
					};
					string content = "Administrator.";
					string title = "Administrator 1.";
					int type = 8;
					player.SendItemsToMail(items, content, title, (eMailType)type);
				}
				client.Player.ClearStoreBag();
				client.Player.UpdateItem(storeBag);
				if (!client.Player.isPlayerWarrior())
				{
					client.Player.RemoveMoney(mustGold);
				}
				client.Player.CommitChanges();
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("OK"));
			}
			else
			{
				pkg.WriteInt(1);
			}
			client.Player.SendTCP(pkg);
			client.Player.SaveIntoDatabase();
			return 0;
        }
    }
}
