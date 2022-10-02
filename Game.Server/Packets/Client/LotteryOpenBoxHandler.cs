using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Text;

namespace Game.Server.Packets.Client
{
	[PacketHandler(26, "打开物品")]
	public class LotteryOpenBoxHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			new ProduceBussiness();
			if (client.Player.Lottery != -1)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, "Rương đang hoạt động!");
				return 1;
			}
			int bageType = packet.ReadByte();
			int slot = packet.ReadInt();
			int num = packet.ReadInt();
			List<ItemInfo> list_item = new List<ItemInfo>();
			PlayerInventory inventory = client.Player.GetInventory((eBageType)bageType);
			if (num == -1)
			{
				ItemInfo itemAt = inventory.GetItemAt(slot);
				if (itemAt != null && (itemAt.TemplateID == 112019 || itemAt.TemplateID == 190000))
				{
					AlternateLotteryOpen(client.Player, itemAt.TemplateID);
					inventory.RemoveCountFromStack(itemAt, 1);
				}
				return 0;
			}
			string string_ = client.Player.PlayerCharacter.NickName;
			if (inventory.FindFirstEmptySlot() == -1)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, "Rương đã đầy không thể mở thêm!");
				client.Out.SendTCP(GetAwards(list_item, string_, 4));
				return 1;
			}
			int templateId = 11456;
			ItemInfo itemByTemplateID = client.Player.GetItemByTemplateID(11456);
			ItemInfo itemByTemplateID2 = client.Player.GetItemByTemplateID(num);
			if (itemByTemplateID2 != null && itemByTemplateID2.Count >= 1)
			{
				List<ItemInfo> list = new List<ItemInfo>();
				StringBuilder stringBuilder = new StringBuilder();
				SpecialItemDataInfo specialItemDataInfo = new SpecialItemDataInfo();
				if (!ItemBoxMgr.CreateItemBox(itemByTemplateID2.TemplateID, list, specialItemDataInfo))
				{
					client.Out.SendTCP(GetAwards(list_item, string_, 4));
					return 0;
				}
				if (specialItemDataInfo.Gold != 0)
				{
					stringBuilder.Append(specialItemDataInfo.Gold + LanguageMgr.GetTranslation("OpenUpArkHandler.Gold"));
					client.Player.AddGold(specialItemDataInfo.Gold);
				}
				if (specialItemDataInfo.GiftToken != 0)
				{
					stringBuilder.Append(specialItemDataInfo.GiftToken + LanguageMgr.GetTranslation("OpenUpArkHandler.GiftToken"));
					client.Player.AddGiftToken(specialItemDataInfo.GiftToken);
				}
				if (list.Count > 0)
				{
					ItemInfo itemInfo = list[0];
					if (num != 112047 && num != 112100 && num != 112101)
					{
						string_ = itemInfo.Template.Name;
					}
					else
					{
						int num2 = 4;
						if (itemByTemplateID.Count >= 2 && client.Player.UsePayBuff(BuffType.Caddy_Good))
						{
							num2 = 2;
						}
						if (itemByTemplateID.Count < num2)
						{
							client.Out.SendMessage(eMessageType.GM_NOTICE, itemByTemplateID.Template.Name + " không đủ.");
							client.Out.SendTCP(GetAwards(list_item, string_, 4));
							return 0;
						}
						client.Player.RemoveTemplate(templateId, num2);
						client.Player.AddBadLuckCaddy(1);
					}
					inventory.AddItem(itemInfo);
					client.Player.OnUsingItem(num, 1);
					stringBuilder.Append(itemInfo.Template.Name);
					client.Player.RemoveTemplate(num, 1);
				}
				list_item = client.Player.CaddyBag.GetItems();
				client.Out.SendTCP(GetAwards(list_item, string_, 4));
				client.Player.Lottery = -1;
				if (stringBuilder != null)
				{
					client.Out.SendMessage(eMessageType.GM_NOTICE, "Bạn nhận được " + stringBuilder.ToString());
				}
				return 1;
			}
			list_item = client.Player.CaddyBag.GetItems();
			client.Out.SendTCP(GetAwards(list_item, string_, 4));
			return 1;
		}

		private GSPacketIn GetAwards(List<ItemInfo> list_item, string string_0, int int_0)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(245);
			gSPacketIn.WriteBoolean((list_item.Count > 0) ? true : false);
			gSPacketIn.WriteInt(list_item.Count);
			foreach (ItemInfo item in list_item)
			{
				gSPacketIn.WriteString(string_0);
				gSPacketIn.WriteInt(item.TemplateID);
				gSPacketIn.WriteInt(int_0);
				gSPacketIn.WriteBoolean(val: false);
			}
			return gSPacketIn;
		}

		private void AlternateLotteryOpen(GamePlayer m_player, int lotteryId)
		{
			List<ItemBoxInfo> list = ItemBoxMgr.FindLotteryItemBoxByRand(lotteryId, 18);
			m_player.Lottery = 0;
			m_player.LotteryItems = list;
			m_player.LotteryID = lotteryId;
			GSPacketIn gSPacketIn = new GSPacketIn(29, m_player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(lotteryId);
			for (int i = 0; i < 18; i++)
			{
				gSPacketIn.WriteInt(list[i].TemplateId);
				gSPacketIn.WriteBoolean(list[i].IsBind);
				gSPacketIn.WriteByte((byte)list[i].ItemCount);
				gSPacketIn.WriteByte((byte)list[i].ItemValid);
			}
			m_player.SendTCP(gSPacketIn);
		}

		public void OpenUpItem(string data, List<ItemInfo> infos, SpecialItemDataInfo specialInfo)
		{
			if (!string.IsNullOrEmpty(data))
			{
				ItemBoxMgr.CreateItemBox(Convert.ToInt32(data), infos, specialInfo);
			}
		}
	}
}
