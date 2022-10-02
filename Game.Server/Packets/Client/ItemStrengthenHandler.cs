using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.ITEM_STRENGTHEN, "物品强化")]
    public class ItemStrengthenHandler : IPacketHandler
    {
        public static int countConnect = 0;

        private static RandomSafe random = new RandomSafe();

        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            if (countConnect >= 3000)
            {
                client.Disconnect();
                return 0;
            }
            GSPacketIn pkg = packet.Clone();
            pkg.ClearContext();
            bool isconsortia = packet.ReadBoolean();
            List<ItemInfo> stones = new List<ItemInfo>();
            ItemInfo item = client.Player.StoreBag.GetItemAt(5);
            ItemInfo luck = null;
            ItemInfo god = null;
            bool isGod = false;
            double probability = 0.0;
            double num2 = 0.0;
            double num3 = 0.0;
            double num4 = 0.0;
            if (item != null && item.Template.CanStrengthen && item.Count == 1)
            {
                bool isBinds = item.IsBinds;
                ItemInfo stone1 = client.Player.StoreBag.GetItemAt(0);
                if (stone1 != null && stone1.Template.CategoryID == 11 && (stone1.Template.Property1 == 2 || stone1.Template.Property1 == 35) && !stones.Contains(stone1))
                {
                    stones.Add(stone1);
                    probability += StrengthenMgr.RateItems[stone1.Template.Level - 1];
                }
                ItemInfo stone2 = client.Player.StoreBag.GetItemAt(1);
                if (stone2 != null && stone2.Template.CategoryID == 11 && (stone2.Template.Property1 == 2 || stone2.Template.Property1 == 35) && !stones.Contains(stone2))
                {
                    stones.Add(stone2);
                    probability += StrengthenMgr.RateItems[stone2.Template.Level - 1];
                }
                ItemInfo stone3 = client.Player.StoreBag.GetItemAt(2);
                if (stone3 != null && stone3.Template.CategoryID == 11 && (stone3.Template.Property1 == 2 || stone3.Template.Property1 == 35) && !stones.Contains(stone3))
                {
                    stones.Add(stone3);
                    probability += StrengthenMgr.RateItems[stone3.Template.Level - 1];
                }
                if (client.Player.StoreBag.GetItemAt(4) != null)
                {
                    luck = client.Player.StoreBag.GetItemAt(4);
                    if (luck != null && luck.Template.CategoryID == 11 && luck.Template.Property1 == 3)
                    {
                        num2 += probability + (double)(luck.Template.Property2 / 100);
                    }
                    else
                    {
                        luck = null;
                    }
                }
                if (client.Player.StoreBag.GetItemAt(3) != null)
                {
                    god = client.Player.StoreBag.GetItemAt(3);
                    if (god != null && god.Template.CategoryID == 11 && god.Template.Property1 == 7)
                    {
                        isGod = true;
                    }
                    else
                    {
                        god = null;
                    }
                }
                double num5 = probability * 100.0 / (double)StrengthenMgr.GetNeedRate(item);
                double num6 = num2 * 100.0 / (double)StrengthenMgr.GetNeedRate(item);
                if ((stone1 != null && stone1.IsBinds) || (stone2 != null && stone2.IsBinds) || (stone3 != null && stone3.IsBinds) || (luck != null && luck.IsBinds) || (god?.IsBinds ?? false))
                {
                    isBinds = true;
                }
                if (isconsortia)
                {
                    ConsortiaInfo consortiaInfo = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
                    ConsortiaEquipControlInfo consortiaEuqipRiches = new ConsortiaBussiness().GetConsortiaEuqipRiches(client.Player.PlayerCharacter.ConsortiaID, 0, 2);
                    if (consortiaInfo == null)
                    {
                        client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ItemStrengthenHandler.Fail"));
                    }
                    else if (client.Player.PlayerCharacter.Riches < consortiaEuqipRiches.Riches)
                    {
                        client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("ItemStrengthenHandler.FailbyPermission"));
                    }
                    else
                    {
                        num4 = num5 * (0.1 * (double)consortiaInfo.SmithLevel);
                    }
                }
                if (client.Player.PlayerCharacter.typeVIP > 0)
                {
                    num3 += StrengthenMgr.VIPStrengthenEx * num5;
                }
                if (stones.Count >= 1)
                {
                    item.StrengthenTimes++;
                    item.IsBinds = isBinds;
                    client.Player.StoreBag.ClearBag();
                    //client.Player.StoreBag.SaveToDatabase();
                    double num7 = Math.Floor((num5 + num6 + num4 + num3) * 100.0);
                    int num8 = random.Next(10000);
                    if (client.Player.isPlayerWarrior())
                    {
                        num8 = 0;
                    }
                    if (num7 > (double)num8)
                    {
                        pkg.WriteByte(0);
                        pkg.WriteBoolean(val: true);
                        item.StrengthenLevel++;
                        StrengthenGoodsInfo strengthenGoodsInfo = StrengthenMgr.FindStrengthenGoodsInfo(item.StrengthenLevel, item.TemplateID);
                        if (strengthenGoodsInfo != null && item.Template.CategoryID == 7 && strengthenGoodsInfo.GainEquip > item.TemplateID)
                        {
                            ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(strengthenGoodsInfo.GainEquip);
                            if (itemTemplateInfo != null)
                            {
                                ItemInfo itemInfo3 = ItemInfo.CloneFromTemplate(itemTemplateInfo, item);
                                client.Player.StoreBag.RemoveItemAt(5);
                                item = itemInfo3;
                            }
                        }
                        ItemInfo.OpenHole(ref item);
                        client.Player.StoreBag.AddItemTo(item, 5);
                        client.Player.OnItemStrengthen(item.Template.CategoryID, item.StrengthenLevel);
                        client.Player.SaveIntoDatabase();
                        if (item.StrengthenLevel >= 10)
                        {
                            GameServer.Instance.LoginServer.SendPacket(WorldMgr.SendSysNotice(eMessageType.ChatNormal, LanguageMgr.GetTranslation("ItemStrengthenHandler.congratulation", client.Player.ZoneName, client.Player.PlayerCharacter.NickName, item.TemplateID, item.StrengthenLevel), item.ItemID, item.TemplateID, null));
                        }
                        if (item.Template.CategoryID == 7 && client.Player.Extra.CheckNoviceActiveOpen(NoviceActiveType.STRENGTHEN_WEAPON_ACTIVE))
                        {
                            client.Player.Extra.UpdateEventCondition((int)NoviceActiveType.STRENGTHEN_WEAPON_ACTIVE, item.StrengthenLevel);
                        }
                    }
                    else
                    {
                        pkg.WriteByte(1);
                        pkg.WriteBoolean(val: false);
                        if (!isGod)
                        {
                            if (item.Template.Level == 3)
                            {
                                item.StrengthenLevel = ((item.StrengthenLevel < 5) ? item.StrengthenLevel : (item.StrengthenLevel - 1));
                                StrengthenGoodsInfo strengthenGoodsInfo2 = StrengthenMgr.FindRealStrengthenGoodInfo(item.StrengthenLevel, item.TemplateID);
                                if (strengthenGoodsInfo2 != null && item.Template.CategoryID == 7 && item.TemplateID != strengthenGoodsInfo2.GainEquip)
                                {
                                    ItemTemplateInfo itemTemplateInfo2 = ItemMgr.FindItemTemplate(strengthenGoodsInfo2.GainEquip);
                                    if (itemTemplateInfo2 != null)
                                    {
                                        ItemInfo itemInfo4 = ItemInfo.CloneFromTemplate(itemTemplateInfo2, item);
                                        client.Player.StoreBag.RemoveItemAt(5);
                                        item = itemInfo4;
                                    }
                                }
                                client.Player.StoreBag.AddItemTo(item, 5);
                            }
                            else
                            {
                                item.Count--;
                                client.Player.StoreBag.AddItemTo(item, 5);
                            }
                        }
                        else
                        {
                            client.Player.StoreBag.AddItemTo(item, 5);
                        }
                        ItemInfo.OpenHole(ref item);
                        client.Player.SaveIntoDatabase();
                    }
                    client.Out.SendTCP(pkg);
                    if (item.Place < 31)
                    {
                        client.Player.EquipBag.UpdatePlayerProperties();
                    }
                }
                else
                {
                    client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ItemStrengthenHandler.Content1") + 1 + LanguageMgr.GetTranslation("ItemStrengthenHandler.Content2"));
                }
            }
            else
            {
                client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ItemStrengthenHandler.Success"));
            }
            return 0;
        }
    }
}
