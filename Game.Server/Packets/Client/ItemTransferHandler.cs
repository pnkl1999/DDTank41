using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System.Text;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.ITEM_TRANSFER, "物品转移")]
    public class ItemTransferHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            //GSPacketIn pkg = packet.Clone();
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.ITEM_TRANSFER, client.Player.PlayerCharacter.ID);
            //pkg.ClearContext();
            StringBuilder str = new StringBuilder();
            int mustGold = 10000;
            bool _moveHole = packet.ReadBoolean();
            bool _moveFivSixHole = packet.ReadBoolean();
            ItemInfo ordItem = client.Player.StoreBag.GetItemAt(0);
            ItemInfo newItem = client.Player.StoreBag.GetItemAt(1);
            if (ordItem != null && newItem != null && ordItem.Template.CategoryID == newItem.Template.CategoryID && newItem.Count == 1 && ordItem.Count == 1)
            {
                if (client.Player.PlayerCharacter.Gold < mustGold)
                {
                    client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ItemTransferHandler.NoGold"));
                    return 1;
                }
                client.Player.RemoveGold(mustGold);
                StrengthenMgr.InheritTransferProperty(ref ordItem, ref newItem, _moveHole, _moveFivSixHole);
                int m_temIdOrd = OrginWeaponID(ordItem);
                int m_temIdNew = OrginWeaponID(newItem);
                ItemTemplateInfo temOrd = null;
                ItemTemplateInfo temNew = null;
                if (m_temIdOrd > 0)
                {
                    //temOrd = ItemMgr.FindItemTemplate(GainWeaponID(ordItem));
                    temOrd = ItemMgr.FindItemTemplate(GainWeaponID(ordItem.StrengthenLevel, m_temIdOrd));
                }
                if (m_temIdNew > 0)
                {
                    //temNew = ItemMgr.FindItemTemplate(GainWeaponID(newItem));
                    temNew = ItemMgr.FindItemTemplate(GainWeaponID(newItem.StrengthenLevel, m_temIdNew));
                }
                if (TransferCondition(newItem, ordItem) && temOrd != null && temNew != null)
                {
                    if (temOrd != null)
                    {
                        ItemInfo itemZero = ItemInfo.CloneFromTemplate(temOrd, ordItem);
                        ItemInfo.OpenHole(ref itemZero);
                        if (itemZero.isGold)
                        {
                            GoldEquipTemplateInfo goldEquip = GoldEquipMgr.FindGoldEquipByTemplate(temOrd.TemplateID);
                            if (goldEquip != null)
                            {
                                ItemTemplateInfo template = ItemMgr.FindItemTemplate(goldEquip.NewTemplateId);
                                if (template != null)
                                {
                                    itemZero.GoldEquip = template;
                                }
                            }
                        }
                        client.Player.StoreBag.RemoveItemAt(0);
                        client.Player.StoreBag.AddItemTo(itemZero, 0);
                    }
                    if (temOrd != null && temNew != null)
                    {
                        ItemInfo itemOne = ItemInfo.CloneFromTemplate(temNew, newItem);
                        ItemInfo.OpenHole(ref itemOne);
                        if (itemOne.isGold)
                        {
                            GoldEquipTemplateInfo goldEquip = GoldEquipMgr.FindGoldEquipByTemplate(temNew.TemplateID);
                            if (goldEquip != null)
                            {
                                ItemTemplateInfo template = ItemMgr.FindItemTemplate(goldEquip.NewTemplateId);
                                if (template != null)
                                {
                                    itemOne.GoldEquip = template;
                                }
                            }
                        }
                        client.Player.StoreBag.RemoveItemAt(1);
                        client.Player.StoreBag.AddItemTo(itemOne, 1);
                    }
                }
                else
                {
                    client.Player.StoreBag.UpdateItem(ordItem);
                    client.Player.StoreBag.UpdateItem(newItem);
                }
                client.Player.StoreBag.SaveNewsItemIntoDatabas();
                pkg.WriteByte(0);
                client.SendTCP(pkg);
            }
            else
            {
                client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("itemtransferhandler.nocondition"));
            }
            return 0;
        }

        public bool TransferCondition(ItemInfo itemAtZero, ItemInfo itemAtOne)
        {
            if (itemAtZero.Template.CategoryID == 7 && itemAtOne.Template.CategoryID == 7)
            {
                return true;
            }
            //if (itemAtZero.StrengthenLevel < 10 && itemAtOne.StrengthenLevel < 10)
            //{
            //	return false;
            //}
            return false;
        }

        //private int OrginWeaponID(ItemInfo _item)
        //{
        //    StrengthenGoodsInfo info = StrengthenMgr.FindTransferInfo(_item.TemplateID);
        //    if (info == null)
        //    {
        //        GoldEquipTemplateInfo goldEquip = GoldEquipMgr.FindGoldEquipOldTemplate(_item.TemplateID);
        //        if (goldEquip == null)
        //        {
        //            return 0;
        //        }
        //        info = StrengthenMgr.FindTransferInfo(goldEquip.OldTemplateId);
        //    }
        //    return info.OrginEquip;
        //}

        private int OrginWeaponID(ItemInfo item)
        {
            StrengthenGoodsInfo info = StrengthenMgr.FindTransferInfo(item.TemplateID);
            if (info == null)
            {
                GoldEquipTemplateInfo goldEquip = GoldEquipMgr.FindGoldEquipOldTemplate(item.TemplateID);
                if (goldEquip != null)
                {
                    info = StrengthenMgr.FindTransferInfo(goldEquip.OldTemplateId);
                }
                else
                {
                    return 0;
                }

            }
            return info.OrginEquip;

        }

        //private int GainWeaponID(ItemInfo _item)
        //{
        //    if (_item.StrengthenLevel >= 10)
        //    {
        //        return StrengthenMgr.FindTransferInfo(_item.StrengthenLevel, _item.TemplateID)?.GainEquip ?? (-1);
        //    }
        //    return StrengthenMgr.FindTransferInfo(_item.TemplateID)?.OrginEquip ?? (-1);
        //}

        private int GainWeaponID(int strengthenLevel, int transId)
        {
            StrengthenGoodsInfo info;
            switch (strengthenLevel)
            {
                case 10:
                    info = StrengthenMgr.FindTransferInfo(strengthenLevel, transId);
                    if (info == null)
                        return -1;
                    return info.GainEquip;
                case 11:
                    info = StrengthenMgr.FindTransferInfo(strengthenLevel, transId);
                    if (info == null)
                        return -1;
                    return info.GainEquip;
                case 12:
                    info = StrengthenMgr.FindTransferInfo(strengthenLevel, transId);
                    if (info == null)
                        return -1;
                    return info.GainEquip;
                case 13:
                    info = StrengthenMgr.FindTransferInfo(strengthenLevel, transId);
                    if (info == null)
                        return -1;
                    return info.GainEquip;
                case 14:
                    info = StrengthenMgr.FindTransferInfo(strengthenLevel, transId);
                    if (info == null)
                        return -1;
                    return info.GainEquip;
                case 15:
                    info = StrengthenMgr.FindTransferInfo(strengthenLevel, transId);
                    if (info == null)
                        return -1;
                    return info.GainEquip;
                default:
                    info = StrengthenMgr.FindTransferInfo(transId);
                    if (info == null)
                        return -1;
                    return info.OrginEquip;
            }
        }
    }
}
