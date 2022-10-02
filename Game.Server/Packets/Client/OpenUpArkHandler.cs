using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Text;

namespace Game.Server.Packets.Client
{
    [PacketHandler(63, "打开物品")]
	public class OpenUpArkHandler : IPacketHandler
    {
        public static readonly ILog log = LogManager.GetLogger("FlashErrorLogger");

        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int bageType = packet.ReadByte();
			int slot = packet.ReadInt();
			int num = packet.ReadInt();
			PlayerInventory inventory = client.Player.GetInventory((eBageType)bageType);
			ItemInfo itemAt = inventory.GetItemAt(slot);
			string str = "";
			if (itemAt != null && itemAt.IsValidItem() && itemAt.Template.CategoryID == 11 && itemAt.Template.Property1 == 6 && client.Player.PlayerCharacter.Grade >= itemAt.Template.NeedLevel)
			{
				if (num < 1 || num > itemAt.Count)
				{
					num = itemAt.Count;
				}
				int num2 = 0;
				string str2 = "";
				StringBuilder stringBuilder = new StringBuilder();
				StringBuilder stringBuilder2 = new StringBuilder();
				if (!inventory.RemoveCountFromStack(itemAt, num))
				{
					return 0;
				}
				Dictionary<int, ItemInfo> dictionary = new Dictionary<int, ItemInfo>();
				List<ItemInfo> list = new List<ItemInfo>();
				stringBuilder2.Append(LanguageMgr.GetTranslation("OpenUpArkHandler.Start"));
				for (int i = 0; i < num; i++)
				{
					int point = 0;
					int gold = 0;
					int giftToken = 0;
					int medal = 0;
					int exp = 0;
					int hardCurrency = 0;
					int leagueMoney = 0;
					int useableScore = 0;
					int prestge = 0;
					int honor = 0;
					List<ItemInfo> list2 = new List<ItemInfo>();
					ItemBoxMgr.CreateItemBox(itemAt.TemplateID, list2, ref gold, ref point, ref giftToken, ref medal, ref exp, ref hardCurrency, ref leagueMoney, ref useableScore, ref prestge, ref honor);
					if (point != 0)
					{
						num2 += point;
						str2 = LanguageMgr.GetTranslation("OpenUpArkHandler.Money");
						client.Player.AddMoney(point);
					}
					if (gold != 0)
					{
						num2 += gold;
						str2 = LanguageMgr.GetTranslation("OpenUpArkHandler.Gold");
						client.Player.AddGold(gold);
					}
					if (giftToken != 0)
					{
						num2 += giftToken;
						str2 = LanguageMgr.GetTranslation("OpenUpArkHandler.GiftToken");
						client.Player.AddGiftToken(giftToken);
					}
					if (medal != 0)
					{
						num2 += medal;
						str2 = LanguageMgr.GetTranslation("OpenUpArkHandler.Medal");
						client.Player.AddMedal(medal);
					}
					if (honor != 0)
					{
						num2 += honor;
						str2 = LanguageMgr.GetTranslation("OpenUpArkHandler.honor");
						client.Player.AddHonor(honor);
					}
					if (exp != 0)
					{
						num2 += exp;
						if (client.Player.Level == LevelMgr.MaxLevel)
						{
							int num3 = num2 / 500;
							if (num3 > 0)
							{
								client.Player.AddOffer(num3);
								str2 = $"Max level khinh nghiệm quy đổi thành {num3} công trạng";
							}
						}
						else
						{
							str2 = LanguageMgr.GetTranslation("OpenUpArkHandler.Exp");
							client.Player.AddGP(exp, false);
						}
					}
					if (hardCurrency != 0)
					{
						num2 += hardCurrency;
						str2 = LanguageMgr.GetTranslation("OpenUpArkHandler.hardCurrency");
						client.Player.AddHardCurrency(hardCurrency);
					}
					if (leagueMoney != 0)
					{
						num2 += leagueMoney;
						str2 = LanguageMgr.GetTranslation("OpenUpArkHandler.leagueMoney");
						client.Player.AddLeagueMoney(leagueMoney);
					}
					if (useableScore != 0)
					{
						num2 += useableScore;
						str2 = LanguageMgr.GetTranslation("OpenUpArkHandler.useableScore");
					}
					if (prestge != 0)
					{
						num2 += prestge;
						str2 = LanguageMgr.GetTranslation("OpenUpArkHandler.prestge");
					}
					foreach (ItemInfo item in list2)
					{
						if (!dictionary.ContainsKey(item.TemplateID))
						{
							dictionary.Add(item.TemplateID, item);
						}
						else
						{
							dictionary[item.TemplateID].Count += item.Count;
						}
					}
				}
				string name = itemAt.Template.Name;
				if (num2 > 0)
				{
					stringBuilder2.Append(num2 + str2);
				}
				if (stringBuilder.Length > 0)
				{
					stringBuilder.Remove(stringBuilder.Length - 1, 1);
					string[] array = stringBuilder.ToString().Split(',');
					for (int j = 0; j < array.Length; j++)
					{
						int num4 = 1;
						for (int k = j + 1; k < array.Length; k++)
						{
							if (array[j].Contains(array[k]) && array[k].Length == array[j].Length)
							{
								num4++;
								array[k] = k.ToString();
							}
						}
						if (num4 > 1)
						{
							array[j] = array[j].Remove(array[j].Length - 1, 1);
							string[] array2;
							IntPtr value;
							(array2 = array)[(int)(value = (IntPtr)j)] = array2[(int)value] + num4;
						}
						if (array[j] != j.ToString())
						{
							string[] array3;
							IntPtr value2;
							(array3 = array)[(int)(value2 = (IntPtr)j)] = array3[(int)value2] + ",";
							stringBuilder2.Append(array[j]);
						}
					}
				}
				stringBuilder2.Remove(stringBuilder2.Length - 1, 1);
				stringBuilder2.Append(".");
				if (num2 > 0)
				{
					client.Out.SendMessage(eMessageType.GM_NOTICE, str + stringBuilder2.ToString());
				}
				if (dictionary.Count > 0)
				{
					GSPacketIn gSPacketIn = new GSPacketIn(63, client.Player.PlayerCharacter.ID);
					gSPacketIn.WriteString(name);
					gSPacketIn.WriteByte((byte)dictionary.Count);
					foreach (ItemInfo value3 in dictionary.Values)
					{
						gSPacketIn.WriteInt(value3.TemplateID);
						gSPacketIn.WriteInt(value3.Count);
						gSPacketIn.WriteBoolean(value3.IsBinds);
						gSPacketIn.WriteInt(value3.ValidDate);
						gSPacketIn.WriteInt(value3.StrengthenLevel);
						gSPacketIn.WriteInt(value3.AttackCompose);
						gSPacketIn.WriteInt(value3.DefendCompose);
						gSPacketIn.WriteInt(value3.AgilityCompose);
						gSPacketIn.WriteInt(value3.LuckCompose);
						stringBuilder.Append(value3.Template.Name + "x" + value3.Count + ",");
						//List<ItemInfo> list3 = ItemMgr.SpiltGoodsMaxCount(value3);
						//foreach (ItemInfo item2 in list3)
						//{
						//	if (!client.Player.StoreBag.AddItem(item2))
						//	{
						//		list.Add(item2);
						//	}
						if (value3.IsTips)
                        {
							GameServer.Instance.LoginServer.SendPacket(WorldMgr.SendSysNotice(eMessageType.ChatNormal, $"[{client.Player.ZoneName}] Chúc mừng người chơi [{client.Player.PlayerCharacter.NickName}] mở hộp quà nhận được {value3.TemplateID}x{value3.Count}.", value3.ItemID, value3.TemplateID, null));
						}
						//}
						if (value3.Template.MaxCount < 2)
						{
							//Console.WriteLine("xyz" + current2.Count.ToString());
							//List<ItemInfo> clone1s = new List<ItemInfo>();
							for (var xi = 0; xi < value3.Count; xi++)
							{
								ItemInfo clone0 = ItemInfo.CreateFromTemplate(value3.Template, 1, value3.RemoveType); // clone item current2 voi so luong la 1
								clone0.ValidDate = value3.ValidDate;
								clone0.IsBinds = value3.IsBinds;
								client.Player.AddTemplate(clone0, clone0.Template.BagType, 1, eGameView.OtherTypeGet, name);
							}
							//client.Player.SendItemsToMail(clone1s, "Mở hộp quà", "Thư trả hộp quà", eMailType.OpenUpArk);
						}
						else
						{
							//Console.WriteLine("x2");
							client.Player.AddTemplate(value3, value3.Template.BagType, value3.Count, eGameView.OtherTypeGet, name);
						}

					}
					client.Player.SendTCP(gSPacketIn);
					//if (list.Count > 0)
					//{
					//	client.Player.SendItemsToMail(list, "Vật phẩm gửi về thư do mở quà trong khi túi đầy.", "Mở túi quà đầy gửi về thư", eMailType.BuyItem);
					//}
				}
			}
			return 1;
        }
    }
}
