using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Bussiness;
using SqlDataProvider.Data;
using Game.Server.GameUtils;
using Game.Server.Managers;
using log4net;
using System.Reflection;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.CHANGE_PLACE_GOODS, "改变物品位置")]
    public class UserChangeItemPlaceHandler : IPacketHandler
    {
        public static readonly ILog log = LogManager.GetLogger("ItemLogger");
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            eBageType bagType = (eBageType)packet.ReadByte();//_loc_2.BagType
            int place = packet.ReadInt();//_loc_2.Place
            eBageType toBagType = (eBageType)packet.ReadByte();//BagInfo.STOREBAG
            int toPlace = packet.ReadInt();//_loc_3.index
            int count = packet.ReadInt();//
            bool allMove = packet.ReadBoolean();//_loc_7.writeBoolean(allMove);
            PlayerInventory bag = client.Player.GetInventory(bagType);
            PlayerInventory toBag = client.Player.GetInventory(toBagType);
            ItemInfo item = bag.GetItemAt(place);
            
            //if (DateTime.Compare(client.Player.LastMovePlaceItem.AddMilliseconds(300.0), DateTime.Now) > 0)
            //{
            //    client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Thao tác quá nhanh !"));
            //    return 0;
            //}
            if (item == null)
            {
                return 0;
            }

            if (count < 0 || count > item.Count)
            {
                client.Disconnect();
                log.ErrorFormat("client disconnect bagType: {0}, place: {1}, toBagType: {2}, toPlace: {3}, count: {4}, allMove: {5}", bagType, place, toBagType, toPlace, count, allMove);
                return 0;
            }
            if (toBagType == eBageType.Store)
            {
                if (!client.Player.isPassCheckCode())
                {
                    client.Player.ShowCheckCode();
                    return 0;
                }
                client.Player.CountFunction2++;
            }
            bag.BeginChanges();
            toBag.BeginChanges();
            
            try
            {
                if (toBagType == eBageType.Consortia)
                {
                    ConsortiaInfo info = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
                    if (info != null)
                        toBag.Capalility = info.StoreLevel * 10;
                }
                if (toBagType == eBageType.EquipBag)
                {
                    if (toBag.FindFirstEmptySlot() == -1 && toPlace >= 31)
                    {
                        return 0;
                    }    
                } else
                {
                    if (toBag.FindFirstEmptySlot() == -1)
                    {
                        return 0;
                    }
                }
                if (toPlace == -1)
                {
                    bool isFull = false;
                    if (bagType == eBageType.CaddyBag && toBagType == eBageType.BeadBag)
                    {
                        toPlace = toBag.FindFirstEmptySlot(toBag.BeginSlot);
                        if (toBag.AddItemTo(item, toPlace))
                            bag.TakeOutItem(item);
                        else
                            isFull = true;
                    }
                    else if (bagType == toBagType && toBagType == eBageType.EquipBag)
                    {
                        toPlace = toBag.FindFirstEmptySlot(toBag.BeginSlot);
                        if (Equip.isAvatar(item.Template))
                        {
                            toPlace = toBag.FindFirstEmptySlot(81);
                        }
                        if (!bag.MoveItem(place, toPlace, count))
                            isFull = true;
                    }
                    else
                    {
                        if (toBag.StackItemToAnother(item) || toBag.AddItem(item))
                            bag.TakeOutItem(item);
                        else
                            isFull = true;
                    }
                    if (isFull)
                    {
                        client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"));
                        client.Player.LastMovePlaceItem = DateTime.Now;
                        return 0;
                    }
                }
                else if (bagType == toBagType)
                {
                    if (toBagType == eBageType.EquipBag && toPlace < bag.BeginSlot)
                    {
                        item.IsBinds = true;
                    }

                    ItemInfo itemTo = bag.GetItemAt(toPlace);
                    if (itemTo != null && toPlace >= bag.BeginSlot)
                    {
                        toPlace = toBag.FindFirstEmptySlot(toBag.BeginSlot);
                        if (Equip.isAvatar(item.Template))
                        {
                            toPlace = toBag.FindFirstEmptySlot(81);
                        }
                        bag.MoveItem(place, toPlace, count);
                    }
                    else
                        bag.MoveItem(place, toPlace, count);

                    //Console.WriteLine("same change place!");
                    client.Player.OnNewGearEvent(item);

                }
                else if (bagType == eBageType.Store)
                {
                    MoveFromStore(client, bag, item, toPlace, toBag, count);
                }
                else if (bagType == eBageType.Consortia || bagType == eBageType.BankBag)
                {
                    ItemInfo itemTo = toBag.GetItemAt(toPlace);
                    if (itemTo != null)
                    {
                        toPlace = toBag.FindFirstEmptySlot(toBag.BeginSlot);
                        if (Equip.isAvatar(item.Template))
                        {
                            toPlace = toBag.FindFirstEmptySlot(81);
                        }
                        MoveFromBank(client, place, toPlace, bag, toBag, item);
                    }
                    else
                    {
                        if (toBagType == eBageType.EquipBag && toPlace < toBag.BeginSlot)
                        {
                            toPlace = toBag.FindFirstEmptySlot(toBag.BeginSlot);
                            if (Equip.isAvatar(item.Template))
                            {
                                toPlace = toBag.FindFirstEmptySlot(81);
                            }
                        }
                        MoveFromBank(client, place, toPlace, bag, toBag, item);
                    }
                    //Console.WriteLine("Move from Bank!");
                }
                else if (toBagType == eBageType.Store)
                {
                    int timestampnow = (int)(DateTime.Now.Date.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
                    if (timestampnow > item.StrengthenTimes)
                    {
                        item.StrengthenExp = 0;
                    }
                    MoveToStore(client, bag, item, toPlace, toBag, count);
                    //Console.WriteLine("Move to Store!");
                }
                else if (toBagType == eBageType.Consortia || toBagType == eBageType.BankBag)
                {
                    ItemInfo itemTo = toBag.GetItemAt(toPlace);
                    if (itemTo != null)
                    {
                        toPlace = toBag.FindFirstEmptySlot();
                        MoveToBank(place, toPlace, bag, toBag, item);
                    }
                    else
                    {
                        MoveToBank(place, toPlace, bag, toBag, item);
                    }
                    //Console.WriteLine("Move to Bank!");
                }
                else if (toBag.AddItemTo(item, toPlace))
                {
                    bag.TakeOutItem(item);
                    log.ErrorFormat("User: {1} Add item to: {0}", toBag.BagType, client.Player.PlayerCharacter.UserName);
                }
            }
            finally
            {
                bag.CommitChanges();
                toBag.CommitChanges();
            }
            client.Player.LastMovePlaceItem = DateTime.Now;
            return 0;
        }

        public void MoveFromStore(GameClient client, PlayerInventory storeBag, ItemInfo item, int toSlot, PlayerInventory bag, int count)
        {
            if ((((client.Player != null && item != null) && storeBag != null) && bag != null) && ((int)item.Template.BagType == bag.BagType))
            {
                if ((toSlot < bag.BeginSlot) || (toSlot > bag.Capalility))
                {
                    if (bag.StackItemToAnother(item))
                    {
                        storeBag.RemoveItem(item, eItemRemoveType.Stack);
                        return;
                    }
                    string key = string.Format("temp_place_{0}", item.ItemID);
                    if (client.Player.TempProperties.ContainsKey(key))
                    {
                        toSlot = (int)storeBag.Player.TempProperties[key];
                        storeBag.Player.TempProperties.Remove(key);
                    }
                    else
                    {
                        toSlot = bag.FindFirstEmptySlot();
                    }
                }
                if (bag.StackItemToAnother(item) || bag.AddItemTo(item, toSlot))
                {
                    storeBag.TakeOutItem(item);
                }
                else
                {
                    toSlot = bag.FindFirstEmptySlot();
                    if (bag.AddItemTo(item, toSlot))
                    {
                        storeBag.TakeOutItem(item);
                    }
                    else
                    {
                        ItemInfo toItem = item.Clone();
                        storeBag.RemoveItem(item);
                        client.Player.SendItemToMail(toItem, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), eMailType.ItemOverdue);
                        client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
                    }
                }
                bag.SaveToDatabase();
                storeBag.SaveToDatabase();
            }
        }
        //
        public void MoveToStore(GameClient client, PlayerInventory bag, ItemInfo item, int toSlot, PlayerInventory storeBag, int count)
        {
            if (((client.Player != null && bag != null) && item != null) && storeBag != null)
            {
                int oldplace = item.Place;
                string key;
                ItemInfo toItem = storeBag.GetItemAt(toSlot);
                if (toItem != null)
                {
                    if (item.Count == 1 && item.BagType == toItem.BagType)
                    {
                        bag.TakeOutItem(item);
                        storeBag.TakeOutItem(toItem);
                        bag.AddItemTo(toItem, oldplace);
                        storeBag.AddItemTo(item, toSlot);
                    }
                    else
                    {
                        PlayerInventory tb = client.Player.GetItemInventory(toItem.Template);
                        key = string.Format("temp_place_{0}", toItem.ItemID);
                        if (tb.BagType == (int)eBageType.EquipBag)
                        {
                            if (client.Player.TempProperties.ContainsKey(key))
                            {
                                int tempSlot = (int)client.Player.TempProperties[key];
                                client.Player.TempProperties.Remove(key);
                                if (tb.AddItemTo(toItem, tempSlot))
                                {
                                    storeBag.TakeOutItem(toItem);
                                }
                            }

                        }
                        else if (tb.StackItemToAnother(toItem))
                        {
                            //storeBag.RemoveItem(toItem, eItemRemoveType.Stack);
                            storeBag.RemoveItem(toItem);
                        }
                        else if (tb.AddItem(toItem))
                        {
                            storeBag.TakeOutItem(toItem);
                        }
                        else
                        {
                            client.Player.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"));
                        }
                        //Console.WriteLine("toItem {0}", toItem.Template.Name);
                    }
                }
                if (storeBag.IsEmpty(toSlot))
                {
                    if (item.Count == 1)
                    {
                        if (storeBag.AddItemTo(item, toSlot))
                        {
                            bag.TakeOutItem(item);
                            if (item.Template.BagType == eBageType.EquipBag && oldplace < 31)
                            {
                                key = string.Format("temp_place_{0}", item.ItemID);
                                if (client.Player.TempProperties.ContainsKey(key))
                                {
                                    client.Player.TempProperties[key] = oldplace;
                                }
                                else
                                {
                                    client.Player.TempProperties.Add(key, oldplace);
                                }
                            }
                        }
                    }
                    else
                    {
                        ItemInfo newItem = item.Clone();
                        newItem.Count = count;
                        if (bag.RemoveCountFromStack(item, count, eItemRemoveType.Stack) && !storeBag.AddItemTo(newItem, toSlot))
                        {
                            bag.AddCountToStack(item, count);
                        }
                    }
                }
                bag.SaveToDatabase();
                storeBag.SaveToDatabase();
            }
        }
        private static void MoveToBank(int place, int toplace, PlayerInventory bag, PlayerInventory bank, ItemInfo item)
        {
            if (bag != null && item != null)
            {
                ItemInfo toItem = bank.GetItemAt(toplace);
                if (toItem != null)
                {
                    if (item.CanStackedTo(toItem) && ((item.Count + toItem.Count) <= item.Template.MaxCount))
                    {
                        if (bank.AddCountToStack(toItem, item.Count))
                            bag.RemoveCountFromStack(item, item.Count);
                    }
                    else if ((int)toItem.Template.BagType == bag.BagType)
                    {
                        bag.TakeOutItem(item);
                        bank.TakeOutItem(toItem);
                        bag.AddItemTo(toItem, place);
                        bank.AddItemTo(item, toplace);
                    }
                }
                else if (bank.AddItemTo(item, toplace))
                {
                    bag.TakeOutItem(item);
                }
            }
        }
        private static void MoveFromBank(GameClient client, int place, int toplace, PlayerInventory bag, PlayerInventory tobag, ItemInfo item)
        {
            if (item != null)
            {
                PlayerInventory tb = client.Player.GetItemInventory(item.Template);
                if (tb == tobag)
                {
                    ItemInfo toitem = tb.GetItemAt(toplace);
                    if (toitem == null)
                    {
                        if (tb.AddItemTo(item, toplace))
                        {
                            bag.TakeOutItem(item);
                        }
                    }
                    else if (item.CanStackedTo(toitem) && ((item.Count + toitem.Count) <= item.Template.MaxCount))
                    {
                        if (tb.AddCountToStack(toitem, item.Count))
                        {
                            bag.RemoveCountFromStack(item, item.Count);
                        }
                    }
                    else
                    {
                        tb.TakeOutItem(toitem);
                        bag.TakeOutItem(item);
                        tb.AddItemTo(item, toplace);
                        bag.AddItemTo(toitem, place);
                    }
                }
                else if (tb.AddItem(item))
                {
                    bag.TakeOutItem(item);
                }
            }
        }
    }
}