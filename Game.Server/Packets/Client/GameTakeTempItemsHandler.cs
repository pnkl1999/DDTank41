using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler(108, "选取")]
	public class GameTakeTempItemsHandler : IPacketHandler
    {
        private bool GetItem(GamePlayer player, ItemInfo item, ref string message)
        {
			if (item != null)
			{
				if (item.Template.BagType == eBageType.Card)
				{
					if (player.CardBag.AddCard(item.Template.TemplateID, item.Count))
					{
						player.TempBag.RemoveItem(item);
					}
					return true;
				}
				PlayerInventory itemInventory = player.GetItemInventory(item.Template);
				if (itemInventory.AddItem(item))
				{
					player.TempBag.RemoveItem(item);
					item.IsExist = true;
					return true;
				}
				itemInventory.UpdateChangedPlaces();
				message = LanguageMgr.GetTranslation("GameTakeTempItemsHandler.Msg");
				List<ItemInfo> items = player.TempBag.GetItems();
				if (player.SendItemsToMail(items, "Túi Đầy! Hoàn trả vật phẩm", "Administrator", eMailType.ItemOverdue))
				{
					foreach (ItemInfo item2 in items)
					{
						player.TempBag.RemoveItem(item2);
					}
				}
			}
			return false;
        }

        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			string message = string.Empty;
			int num = packet.ReadInt();
			if (num != -1)
			{
				ItemInfo itemAt = client.Player.TempBag.GetItemAt(num);
				GetItem(client.Player, itemAt, ref message);
			}
			else
			{
				foreach (ItemInfo item in client.Player.TempBag.GetItems())
				{
					if (!GetItem(client.Player, item, ref message))
					{
						break;
					}
				}
			}
			if (!string.IsNullOrEmpty(message))
			{
				client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, message);
			}
			return 0;
        }
    }
}
