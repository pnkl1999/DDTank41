using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Buffer;
using Game.Server.GameUtils;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler(183, "卡片使用")]
    public class CardUseHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int bageType = packet.ReadInt();
            int num = packet.ReadInt();
            List<int> list = new List<int>();
            int num2 = packet.ReadInt();
            for (int i = 0; i < num2; i++)
            {
                int item = packet.ReadInt();
                list.Add(item);
            }
            packet.ReadInt();
            bool flag = packet.ReadBoolean();
            if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked && !flag)
            {
                client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Bag.Locked"));
                return 0;
            }
            string translateId = null;
            string message = null;
            ItemInfo itemInfo = null;
            ShopItemInfo shopItemInfo = new ShopItemInfo();
            PlayerInventory playerInventory = null;
            foreach (int item2 in list)
            {
                if (num == -1)
                {
                    int num3 = 0;
                    int num4 = 0;
                    shopItemInfo = ShopMgr.GetShopItemInfoById(item2);
                    if (shopItemInfo != null && ShopMgr.IsOnShop(item2))
                    {
                        itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(shopItemInfo.TemplateID), 1, 102);
                        if (shopItemInfo.APrice1 == -1 && shopItemInfo.AValue1 != 0)
                        {
                            num4 = shopItemInfo.AValue1;
                            itemInfo.ValidDate = shopItemInfo.AUnit;
                        }
                        if (itemInfo != null)
                        {
                            if (num3 <= client.Player.PlayerCharacter.Gold && num4 <= client.Player.PlayerCharacter.Money && (num4 > 0 || num3 > 0))
                            {
                                client.Player.RemoveMoney(num4);
                                client.Player.RemoveGold(num3);
                                translateId = "CardUseHandler.Success";
                            }
                            else
                            {
                                itemInfo = null;
                            }
                        }
                    }
                    else
                    {
                        translateId = "Không thể mua vật phẩm này.";
                    }
                }
                else
                {
                    playerInventory = client.Player.GetInventory((eBageType)bageType);
                    if (playerInventory != null)
                    {
                        itemInfo = playerInventory.GetItemAt(num);
                        translateId = "CardUseHandler.Success";
                    }
                }
                if (itemInfo == null)
                {
                    continue;
                }
                string empty = string.Empty;
                switch (itemInfo.Template.Property1)
                {
                    case 23:
                        {
                            DateTime ExpireDayOut = DateTime.Now;
                            using (PlayerBussiness playerBussiness = new PlayerBussiness())
                            {
                                int typeVIP = client.Player.SetTypeVIP(itemInfo.ValidDate);
                                playerBussiness.VIPRenewal(client.Player.PlayerCharacter.NickName, itemInfo.ValidDate, typeVIP, ref ExpireDayOut);
                                if (itemInfo.ValidDate == 0)
                                {
                                    itemInfo.ValidDate = 1;
                                }
                                if (client.Player.PlayerCharacter.typeVIP == 0)
                                {
                                    client.Player.OpenVIP(itemInfo.ValidDate, ExpireDayOut);
                                    message = $"Chúc mừng bạn nhận được {itemInfo.ValidDate} ngày sử dụng đặc quyền VIP!";
                                }
                                else
                                {
                                    client.Player.ContinuousVIP(itemInfo.ValidDate, ExpireDayOut);
                                    message = $"Bạn nhận được thêm {itemInfo.ValidDate} ngày sử dụng đặc quyền VIP!";
                                }
                                client.Player.Out.SendOpenVIP(client.Player);
                                client.Player.OnVIPUpgrade(client.Player.PlayerCharacter.VIPLevel, client.Player.PlayerCharacter.VIPExp);
                                if (itemInfo.Template.CanDelete)
                                {
                                    client.Player.GetInventory((eBageType)bageType).RemoveCountFromStack(itemInfo, 1);
                                }
                            }
                            client.Out.SendMessage(eMessageType.ChatNormal, message);
                            continue;
                        }
                    case 21:
                        if (itemInfo.IsValidItem())
                        {
                            int num5 = itemInfo.Template.Property2 * itemInfo.Count;
                            if (client.Player.Level == LevelMgr.MaxLevel)
                            {
                                int num6 = num5 / 100;
                                if (num6 > 0)
                                {
                                    client.Player.AddOffer(num6);
                                    client.Player.UpdateProperties();
                                    translateId = string.Format("", num6);
                                }
                            }
                            else
                            {
                                client.Player.AddGP(num5, false);
                                translateId = "GPDanUser.Success";
                            }
                            if (itemInfo.Template.CanDelete)
                            {
                                client.Player.RemoveCountFromStack(itemInfo, itemInfo.Count);
                            }
                        }
                        client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation(translateId, itemInfo.Template.Property2 * itemInfo.Count));
                        continue;
                }
                AbstractBuffer abstractBuffer = BufferList.CreateBuffer(itemInfo.Template, itemInfo.ValidDate);
                if (abstractBuffer != null)
                {
                    abstractBuffer.Start(client.Player);
                    if (num != -1)
                    {
                        playerInventory?.RemoveCountFromStack(itemInfo, 1);
                    }
                }
                client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation(translateId));
            }
            return 0;
        }
    }
}
