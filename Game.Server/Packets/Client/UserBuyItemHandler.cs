using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;

namespace Game.Server.Packets.Client
{
	[PacketHandler((byte)ePackageType.BUY_GOODS, "购买物品")]
	public class UserBuyItemHandler : IPacketHandler
	{
		public static int countConnect = 0;

		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (countConnect >= 3000)
			{
				client.Disconnect();
				return 0;
			}
			int gold = 0;
			int money = 0;
			int offer = 0;
			int gifttoken = 0;
			int petScore = 0;
			int Score = 0;
			int dmgScore = 0;
			StringBuilder payGoods = new StringBuilder();
			eMessageType eMsg = eMessageType.GM_NOTICE;
			string msg = "UserBuyItemHandler.Success";
			GSPacketIn gSPacketIn = new GSPacketIn((byte)ePackageType.BUY_GOODS, client.Player.PlayerCharacter.ID);
			List<ItemInfo> buyitems = new List<ItemInfo>();//buyitems
			Dictionary<int, int> needitemsinfo = new Dictionary<int, int>();
			List<bool> dresses = new List<bool>();
			List<int> places = new List<int>();
			StringBuilder types = new StringBuilder();
			bool isBinds = true;
			ConsortiaInfo consotia = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
			int count = packet.ReadInt();
			if (count > 0 && count <= 99)
			{
				List<string> ids = new List<string>();
				for (int i = 0; i < count; i++)
				{
					int GoodsID = packet.ReadInt();
					int type = packet.ReadInt();
					string color = packet.ReadString();
					bool dress = packet.ReadBoolean();
					string skin = packet.ReadString();
					int place = packet.ReadInt();
					ids.Add(GoodsID.ToString());
					ShopItemInfo shopItem = ShopMgr.GetShopItemInfoById(GoodsID);
					if (shopItem == null || !ShopMgr.IsOnShop(shopItem.ID))
					{
						continue;
					}
					if (shopItem.ShopID != 2 && ShopMgr.CanBuy(shopItem.ShopID, consotia?.ShopLevel ?? 1, ref isBinds, client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.Riches))
					{
						if (shopItem.ShopID == 20)
						{
							if (client.Player.PlayerCharacter.ShopFinallyGottenTime.Date == DateTime.Now.Date || !WorldMgr.UpdateShopFreeCount(shopItem.ID, shopItem.LimitCount))
							{
								client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("UserBuyItemHandler.FailByPermission2"));
								return 1;
							}
							List<ShopFreeCountInfo> allShopFreeCount = WorldMgr.GetAllShopFreeCount();
							client.Out.SendShopGoodsCountUpdate(allShopFreeCount);
							client.Player.PlayerCharacter.ShopFinallyGottenTime = DateTime.Now.Date;
							needitemsinfo.Add(-9999, 1);
						}
						ItemInfo item = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(shopItem.TemplateID), 1, 102);
						if (shopItem.BuyType == 0)
						{
							if (1 == type)
							{
								item.ValidDate = shopItem.AUnit;
							}
							if (2 == type)
							{
								item.ValidDate = shopItem.BUnit;
							}
							if (3 == type)
							{
								item.ValidDate = shopItem.CUnit;
							}
						}
						else
						{
							if (1 == type)
							{
								item.Count = shopItem.AUnit;
							}
							if (2 == type)
							{
								item.Count = shopItem.BUnit;
							}
							if (3 == type)
							{
								item.Count = shopItem.CUnit;
							}
						}
						if (item == null && shopItem == null)
						{
							continue;
						}
						item.Color = ((color == null) ? "" : color);
						item.Skin = ((skin == null) ? "" : skin);
						item.IsBinds = isBinds || Convert.ToBoolean(shopItem.IsBind);
						item.IsBinds = true;
						types.Append(type);
						types.Append(",");
						buyitems.Add(item);
						dresses.Add(dress);
						places.Add(place);
						List<int> list5 = ItemInfo.SetItemType(shopItem, type, ref gold, ref money, ref offer, ref gifttoken, ref petScore, ref Score, ref dmgScore);
						for (int j = 0; j < list5.Count; j += 2)
						{
							if (needitemsinfo.ContainsKey(list5[j]))
							{
								needitemsinfo[list5[j]] += list5[j + 1];
							}
							else
							{
								needitemsinfo.Add(list5[j], list5[j + 1]);
							}
						}
						continue;
					}
					client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("UserBuyItemHandler.FailByPermission"));
					return 1;
				}
				if (buyitems.Count == 0)
				{
					return 1;
				}
				if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
				{
					client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Bag.Locked"));
					return 1;
				}
                bool flag = true;
				foreach (KeyValuePair<int, int> item3 in needitemsinfo)
				{
					if (item3.Key != -9999 && client.Player.GetTemplateCount(item3.Key) < item3.Value)
					{
						flag = false;
					}
				}
				if (!flag)
				{
					string translateId2 = "UserBuyItemHandler.NoBuyItem";
					client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation(translateId2));
					return 1;
				}
				if (gold >= 0 && money >= 0 && offer >= 0 && gifttoken >= 0 && petScore >= 0 && Score >= 0 && dmgScore >= 0 && (gold > 0 || money > 0 || offer > 0 || gifttoken > 0 || petScore > 0 || Score > 0 || dmgScore > 0 || needitemsinfo.Count > 0))
				{
					int num3 = client.Player.PlayerCharacter.Money + client.Player.PlayerCharacter.MoneyLock;
					if (gold <= client.Player.PlayerCharacter.Gold && money <= client.Player.PlayerCharacter.Money + client.Player.PlayerCharacter.MoneyLock && offer <= client.Player.PlayerCharacter.Offer && gifttoken <= client.Player.PlayerCharacter.GiftToken && petScore <= client.Player.PlayerCharacter.petScore && Score <= client.Player.PlayerCharacter.Score && dmgScore <= client.Player.PlayerCharacter.damageScores)
					{
						client.Player.RemoveMoney(money);
						client.Player.RemoveGold(gold);
						client.Player.RemoveOffer(offer);
						client.Player.RemoveGiftToken(gifttoken);
						client.Player.RemovePetScore(petScore);
						client.Player.RemoveScore(Score);
						client.Player.RemoveDamageScores(dmgScore);
						int num4 = client.Player.PlayerCharacter.Money + client.Player.PlayerCharacter.MoneyLock;
						string str = $"money: {money} | gold: {gold} | offter: {offer} | gifttoken: {gifttoken} | petScore: {petScore} | boguScore: {Score} | moneyBefore: {num3} | moneyAfter: {num4} | dmg Score: {dmgScore}";
						//if (money > 0 && client.Player.Extra.CheckNoviceActiveOpen(NoviceActiveType.USE_MONEY_ACTIVE))
						//{
						//	client.Player.Extra.UpdateEventCondition((int)NoviceActiveType.USE_MONEY_ACTIVE, money, isPlus: true, 0);
						//}
						//if (money > 0 && client.Player.Extra.CheckNoviceActiveOpen(NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK))
						//{
						//	client.Player.Extra.UpdateEventCondition((int)NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK, money, isPlus: true, 0);
						//}
						foreach (KeyValuePair<int, int> item4 in needitemsinfo)
						{
							if (item4.Key != -9999)
							{
								client.Player.RemoveTemplateInShop(item4.Key, item4.Value);
							}
							payGoods.Append(item4.Key + ",");
						}
						if (needitemsinfo.Count > 0)
						{
							client.Player.UpdateProperties();
						}
						string str2 = str + " | itemNeed: " + string.Join(",", needitemsinfo.Keys.ToArray());
						string text3 = "";
						int num5 = 0;
						MailInfo mailInfo = new MailInfo();
						StringBuilder stringBuilder3 = new StringBuilder();
						stringBuilder3.Append(LanguageMgr.GetTranslation("GoodsPresentHandler.AnnexRemark"));
						for (int k = 0; k < buyitems.Count; k++)
						{
							string str3 = text3;
							string str5;
							if (!(text3 == ""))
							{
								string str4 = buyitems[k].TemplateID.ToString();
								str5 = "," + str4;
							}
							else
							{
								str5 = buyitems[k].TemplateID.ToString();
							}
							text3 = str3 + str5;
							if (client.Player.AddTemplate(buyitems[k], buyitems[k].Template.BagType, buyitems[k].Count, backToMail: false))
							{
								if (!dresses[k] || !buyitems[k].CanEquip())
								{
									continue;
								}
								int num6 = client.Player.EquipBag.FindItemEpuipSlot(buyitems[k].Template);
								if ((num6 != 9 && num6 != 10) || (places[k] != 9 && places[k] != 10))
								{
									if ((num6 == 7 || num6 == 8) && (places[k] == 7 || places[k] == 8))
									{
										num6 = places[k];
									}
								}
								else
								{
									num6 = places[k];
								}
								client.Player.EquipBag.MoveItem(buyitems[k].Place, num6, 0);
								msg = "UserBuyItemHandler.Save";
								continue;
							}
							using PlayerBussiness playerBussiness = new PlayerBussiness();
							buyitems[k].UserID = 0;
							playerBussiness.AddGoods(buyitems[k]);
							num5++;
							stringBuilder3.Append(num5);
							stringBuilder3.Append("、");
							stringBuilder3.Append(buyitems[k].Template.Name);
							stringBuilder3.Append("x");
							stringBuilder3.Append(buyitems[k].Count);
							stringBuilder3.Append(";");
							switch (num5)
							{
								case 1:
									{
										string text5 = (mailInfo.Annex1 = buyitems[k].ItemID.ToString());
										string text14 = text5;
										mailInfo.Annex1Name = buyitems[k].Template.Name;
										break;
									}
								case 2:
									{
										string text5 = (mailInfo.Annex2 = buyitems[k].ItemID.ToString());
										string text12 = text5;
										mailInfo.Annex2Name = buyitems[k].Template.Name;
										break;
									}
								case 3:
									{
										string text5 = (mailInfo.Annex3 = buyitems[k].ItemID.ToString());
										string text10 = text5;
										mailInfo.Annex3Name = buyitems[k].Template.Name;
										break;
									}
								case 4:
									{
										string text5 = (mailInfo.Annex4 = buyitems[k].ItemID.ToString());
										string text8 = text5;
										mailInfo.Annex4Name = buyitems[k].Template.Name;
										break;
									}
								case 5:
									{
										string text5 = (mailInfo.Annex5 = buyitems[k].ItemID.ToString());
										string text6 = text5;
										mailInfo.Annex5Name = buyitems[k].Template.Name;
										break;
									}
							}
							if (num5 == 5)
							{
								num5 = 0;
								mailInfo.AnnexRemark = stringBuilder3.ToString();
								stringBuilder3.Remove(0, stringBuilder3.Length);
								stringBuilder3.Append(LanguageMgr.GetTranslation("GoodsPresentHandler.AnnexRemark"));
								mailInfo.Content = LanguageMgr.GetTranslation("UserBuyItemHandler.Title") + mailInfo.Annex1Name + "]";
								mailInfo.Gold = 0;
								mailInfo.Money = 0;
								mailInfo.Receiver = client.Player.PlayerCharacter.NickName;
								mailInfo.ReceiverID = client.Player.PlayerCharacter.ID;
								mailInfo.Sender = mailInfo.Receiver;
								mailInfo.SenderID = mailInfo.ReceiverID;
								mailInfo.Title = mailInfo.Content;
								mailInfo.Type = 8;
								playerBussiness.SendMail(mailInfo);
								eMsg = eMessageType.BIGBUGLE_NOTICE;
								msg = "UserBuyItemHandler.Mail";
								mailInfo.Revert();
							}
						}
						string content = str2 + " | listsBuy: " + text3;
						if (num5 > 0)
						{
							using PlayerBussiness playerBussiness2 = new PlayerBussiness();
							mailInfo.AnnexRemark = stringBuilder3.ToString();
							mailInfo.Content = LanguageMgr.GetTranslation("UserBuyItemHandler.Title") + mailInfo.Annex1Name + "]";
							mailInfo.Gold = 0;
							mailInfo.Money = 0;
							mailInfo.Receiver = client.Player.PlayerCharacter.NickName;
							mailInfo.ReceiverID = client.Player.PlayerCharacter.ID;
							mailInfo.Sender = mailInfo.Receiver;
							mailInfo.SenderID = mailInfo.ReceiverID;
							mailInfo.Title = mailInfo.Content;
							mailInfo.Type = 8;
							playerBussiness2.SendMail(mailInfo);
							eMsg = eMessageType.BIGBUGLE_NOTICE;
							msg = "UserBuyItemHandler.Mail";
						}
						if (eMsg == eMessageType.BIGBUGLE_NOTICE)
						{
							client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
						}
						client.Player.OnPaid(money, gold, offer, gifttoken, petScore, 0, dmgScore, payGoods.ToString());
						client.Player.AddLog("Buy Shop", content);
					}
					else
					{
						if (money > client.Player.PlayerCharacter.Money && money > 0)
						{
							msg = "UserBuyItemHandler.NoMoney";
						}
						if (gold > client.Player.PlayerCharacter.Gold)
						{
							msg = "UserBuyItemHandler.NoGold";
						}
						if (offer > client.Player.PlayerCharacter.Offer)
						{
							msg = "UserBuyItemHandler.NoOffer";
						}
						if (gifttoken > client.Player.PlayerCharacter.GiftToken)
						{
							msg = "UserBuyItemHandler.GiftToken";
						}
						if (petScore > client.Player.PlayerCharacter.petScore)
						{
							msg = "UserBuyItemHandler.petScore";
						}
						if (Score > client.Player.PlayerCharacter.Score)
						{
							msg = "UserBuyItemHandler.boguScore";
						}
						if (dmgScore > client.Player.PlayerCharacter.damageScores)
						{
							msg = "UserBuyItemHandler.boguScore";
						}
						eMsg = eMessageType.BIGBUGLE_NOTICE;
					}
					client.Out.SendMessage(eMsg, LanguageMgr.GetTranslation(msg));
					gSPacketIn.WriteInt(1);
					gSPacketIn.WriteInt(3);
					client.Player.SendTCP(gSPacketIn);
					return 0;
				}
				client.Player.SendMessage("Lỗi hệ thống. Sự cố đã được gửi đến quản trị viên.");
				log.Error("username: " + client.Player.PlayerCharacter.UserName + " - hack money down.");
				return 0;
			}
			client.Player.SendMessage("Lỗi hệ thống. Sự cố đã được gửi đến quản trị viên.");
			log.Error("username: " + client.Player.PlayerCharacter.UserName + " - hack money down (count: " + count + ").");
			return 0;
		}
	}
}