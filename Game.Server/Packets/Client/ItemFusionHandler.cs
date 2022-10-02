using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.ITEM_FUSION, "熔化")]
    public class ItemFusionHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            new StringBuilder();
            int opertionType = packet.ReadByte();
            int MinValid = int.MaxValue;
            int MinValidItem = 0;
            List<ItemInfo> Items = new List<ItemInfo>();
            List<ItemInfo> AppendItems = new List<ItemInfo>();
            if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                return 1;
            }
            Items.Clear();
            PlayerInventory storeBag = client.Player.StoreBag;
            for (int i = 1; i <= 4; i++)
            {
                ItemInfo itemAt = storeBag.GetItemAt(i);
                if (itemAt != null)
                {
                    Items.Add(itemAt);
                }
            }

            if (Items.Count >= 4 && (Items[0].TemplateID != Items[1].TemplateID || Items[0].TemplateID != Items[2].TemplateID || Items[0].TemplateID != Items[3].TemplateID))
            {
                client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("Tồn tại vật phẩm không cùng loại!"));
                return 0;
            }

            if (MinValid == int.MaxValue)
            {
                foreach (var item in Items)
                {
                    int[] Valid = new int[4];
                    for (int i = 0; i < Items.Count; i++)
                    {
                        Valid[i] = Items[i].ValidDate;
                    }
                    Array.Sort(Valid);
                    if (Items[0].ValidDate != 0 && Items[1].ValidDate != 0 && Items[2].ValidDate != 0 && Items[3].ValidDate != 0)
                    {
                        MinValidItem = Valid[0];
                    }
                    else
                    {
                        MinValidItem = Valid[1];
                    }
                }

                MinValid = MinValidItem;
            }
            bool isBind = false;
            //bool IsBind = false;
            bool result = false;
            ItemTemplateInfo rewardItem = FusionMgr.Fusion(Items, AppendItems, ref isBind, ref result);
            if (rewardItem != null)
            {
                if (rewardItem.CategoryID == 7 || rewardItem.CategoryID == 17)
                {
                    MinValid = 7;
                    isBind = true;
                }
            }
            if (Items.Count != 4)
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.ItemNotEnough"));
                return 0;
            }
            if (opertionType == 0)
            {
                Dictionary<int, double> previewItemList = FusionMgr.FusionPreview(Items, AppendItems, ref isBind);
                if (previewItemList != null)
                {
                    if (previewItemList.Count != 0)
                    {
                        client.Out.SendFusionPreview(client.Player, previewItemList, isBind, MinValid);
                    }
                }
            }
            else
            {
                int value = 400;
                if (client.Player.PlayerCharacter.Gold < 400)
                {
                    client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemFusionHandler.NoMoney"));
                    return 0;
                }
                if (rewardItem != null)
                {
                    ItemInfo itemAt = storeBag.GetItemAt(0);
                    if (itemAt != null)
                    {
                        if (!client.Player.StackItemToAnother(itemAt) && !client.Player.AddItem(itemAt))
                        {
                            client.Player.SendItemsToMail(itemAt, "Vật phẩm từ dung luyện thành công trả về thư do túi đầy", "Vật phẩm dung luyện", eMailType.StoreCanel);
                        }
                        storeBag.TakeOutItemAt(0);
                    }
                    client.Player.RemoveGold(value);
                    for (int j = 0; j < Items.Count; j++)
                    {
                        Items[j].Count--;
                        client.Player.UpdateItem(Items[j]);
                    }
                    for (int k = 0; k < AppendItems.Count; k++)
                    {
                        AppendItems[k].Count--;
                        client.Player.UpdateItem(AppendItems[k]);
                    }
                    if (result)
                    {
                        if (rewardItem.BagType == eBageType.EquipBag)
                        {
                            MinValid = MinValidItem;
                        }
                        ItemInfo item = ItemInfo.CreateFromTemplate(rewardItem, 1, 105);
                        if (item == null)
                        {
                            return 0;
                        }
                        item.IsBinds = isBind;
                        item.ValidDate = MinValid;
                        client.Player.OnItemFusion(item.Template.FusionType);
                        client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.Succeed1") + item.Template.Name);
                        //if (item.Template.CategoryID == 7 || item.Template.CategoryID == 17 || item.Template.CategoryID == 19 || item.Template.CategoryID == 16)
                        if (item.Template.CategoryID == 7 || item.Template.CategoryID == 8 || item.Template.CategoryID == 9 || item.Template.CategoryID == 14 || item.Template.CategoryID == 16 || item.Template.CategoryID == 17 || item.Template.CategoryID == 35)
                        {
                            client.Player.SaveNewItems();
                            string translation = LanguageMgr.GetTranslation("ItemFusionHandler.Notice", client.Player.ZoneName, client.Player.PlayerCharacter.NickName, item.TemplateID);
                            GSPacketIn packet2 = WorldMgr.SendSysNotice(eMessageType.ChatNormal, translation, item.ItemID, item.TemplateID, null);
                            GameServer.Instance.LoginServer.SendPacket(packet2);
                            client.Player.AddLog("Fusion", "TemplateID: " + item.TemplateID + "|Name: " + item.Template.Name);
                        }
                        if (!client.Player.StoreBag.AddItemTo(item, 0))
                        {
                            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(item.GetBagName()) + LanguageMgr.GetTranslation("ItemFusionHandler.NoPlace"));
                            client.Player.AddLog("Error", "ItemFusionError" + item.Template.Name + "|TemplateID:" + item.TemplateID);
                            client.Player.SendItemsToMail(new List<ItemInfo>
                            {
                                item
                            }, LanguageMgr.GetTranslation("GameServer.Fustion.msg2", item.Name), LanguageMgr.GetTranslation("GameServer.Fustion.Msg3"), eMailType.BuyItem);
                        }
                        client.Out.SendFusionResult(client.Player, result);
                    }
                    else
                    {
                        client.Out.SendFusionResult(client.Player, result);
                        client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.Failed"));
                    }
                    client.Player.SaveIntoDatabase();
                }
                else
                {
                    client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemFusionHandler.NoCondition"));
                }
            }
            return 0;
        }
    }
}
