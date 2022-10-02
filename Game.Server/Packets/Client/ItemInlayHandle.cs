using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.Statics;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.ITEM_INLAY, "物品镶嵌")]
    public class ItemInlayHandle : IPacketHandler
    {
        public static int countConnect = 0;
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            GSPacketIn pkg = packet.Clone();
            pkg.ClearContext();
            int ItemBagType = packet.ReadInt();
            int ItemPlace = packet.ReadInt();
            int HoleNum = packet.ReadInt();
            int GemBagType = packet.ReadInt();
            int GemPlace = packet.ReadInt();
            ItemInfo Item = client.Player.GetItemAt((eBageType)ItemBagType, ItemPlace);
            ItemInfo Gem = client.Player.GetItemAt((eBageType)GemBagType, GemPlace);
            string BeginProperty = null;
            string AddItem = "";
            using (ItemRecordBussiness db = new ItemRecordBussiness())
            {
                db.PropertyString(Item, ref BeginProperty);
            }
            int Glod = GameProperties.InlayGoldPrice;
            if (Item != null && Gem != null && Gem.Template.Property1 == 31)
            {
                if (client.Player.PlayerCharacter.Gold > Glod)
                {
                    string[] Hole = Item.Template.Hole.Split('|');
                    if (HoleNum > 0 && HoleNum < 7)
                    {
                        client.Player.RemoveGold(Glod);
                        bool result = false;
                        switch (HoleNum)
                        {
                            case 1:
                                if (Convert.ToInt32(Hole[0].Split(',')[1]) == Gem.Template.Property2)
                                {
                                    Item.Hole1 = Gem.TemplateID;
                                    AddItem = AddItem + "," + Gem.ItemID + "," + Gem.Template.Name;
                                    result = true;
                                }
                                break;
                            case 2:
                                if (Convert.ToInt32(Hole[1].Split(',')[1]) == Gem.Template.Property2)
                                {
                                    Item.Hole2 = Gem.TemplateID;
                                    AddItem = AddItem + "," + Gem.ItemID + "," + Gem.Template.Name;
                                    result = true;
                                }
                                break;
                            case 3:
                                if (Convert.ToInt32(Hole[2].Split(',')[1]) == Gem.Template.Property2)
                                {
                                    Item.Hole3 = Gem.TemplateID;
                                    AddItem = AddItem + "," + Gem.ItemID + "," + Gem.Template.Name;
                                    result = true;
                                }
                                break;
                            case 4:
                                if (Convert.ToInt32(Hole[3].Split(',')[1]) == Gem.Template.Property2)
                                {
                                    Item.Hole4 = Gem.TemplateID;
                                    AddItem = AddItem + "," + Gem.ItemID + "," + Gem.Template.Name;
                                    result = true;
                                }
                                break;
                            case 5:
                                if (Convert.ToInt32(Hole[4].Split(',')[1]) != Gem.Template.Property2)
                                {
                                    break;
                                }
                                if (Item.Hole5 != 0)
                                {
                                    ItemInfo item = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(Item.Hole5), 1, (int)ItemAddType.Buy);
                                    item.IsBinds = true;
                                    item.ValidDate = 0;
                                    //if (!client.Player.AddItem(item))
                                    //{
                                    //    client.Player.SendItemsToMail(new List<ItemInfo>
                                    //{
                                    //    item
                                    //}, "Tháo châu báu túi đầy.", "Tháo châu báu túi đầy.", eMailType.BuyItem);
                                    //}
                                    if (!client.Player.AddItem(item))
                                    {
                                        client.Player.SendItemsToMail(item, "Tháo châu báu túi đầy.", "Tháo châu báu túi đầy.", eMailType.BuyItem);
                                    }
                                }
                                Item.Hole5 = Gem.TemplateID;
                                AddItem = AddItem + "," + Gem.ItemID + "," + Gem.Template.Name;
                                result = true;
                                break;
                            case 6:
                                if (Convert.ToInt32(Hole[5].Split(',')[1]) != Gem.Template.Property2)
                                {
                                    break;
                                }
                                if (Item.Hole6 != 0)
                                {
                                    ItemInfo item = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(Item.Hole6), 1, (int)ItemAddType.Buy);
                                    item.IsBinds = true;
                                    item.ValidDate = 0;
                                    //if (!client.Player.AddItem(item))
                                    //{
                                    //    client.Player.SendItemsToMail(new List<ItemInfo>
                                    //{
                                    //    item
                                    //}, "Tháo châu báu túi đầy.", "Tháo châu báu túi đầy.", eMailType.BuyItem);
                                    //}
                                    if (!client.Player.AddItem(item))
                                    {
                                        client.Player.SendItemsToMail(item, "Tháo châu báu túi đầy.", "Tháo châu báu túi đầy.", eMailType.BuyItem);
                                    }
                                }
                                Item.Hole6 = Gem.TemplateID;
                                AddItem = AddItem + "," + Gem.ItemID + "," + Gem.Template.Name;
                                result = true;
                                break;
                        }
                        if (result)
                        {
                            pkg.WriteInt(0);
                            Gem.Count--;
                            if (Gem.IsBinds)
                            {
                                Item.IsBinds = true;
                            }
                            client.Player.UpdateItem(Gem);
                            client.Player.UpdateItem(Item);
                            client.Player.StoreBag.SaveToDatabase();
                            //GameServer.Instance.LoginServer.SendPacket(WorldMgr.SendSysNotice(eMessageType.ChatNormal, LanguageMgr.GetTranslation("ItemInlay.Success", client.Player.ZoneName, client.Player.PlayerCharacter.NickName, itemAt2.Template.Name, itemAt.TemplateID), itemAt.ItemID, itemAt.TemplateID, null));
                        }
                        else
                        {
                            client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.InlayItem.Msg1"));
                        }
                        LogMgr.LogItemAdd(client.Player.PlayerCharacter.ID, LogItemType.Insert, BeginProperty, Item, AddItem, Convert.ToInt32(result));
                    }
                    else
                    {
                        pkg.WriteByte(1);
                        client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ItemInlayHandle.NoPlace"));
                    }
                    client.Player.SendTCP(pkg);
                    client.Player.SaveIntoDatabase();
                }
                else
                {
                    client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("UserBuyItemHandler.NoMoney"));
                }
                return 0;
            }
            return 0;
        }
    }
}
