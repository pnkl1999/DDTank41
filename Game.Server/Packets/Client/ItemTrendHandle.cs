using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System.Collections.Generic;
using System.Text;

namespace Game.Server.Packets.Client
{
    [PacketHandler(120, "物品倾向转移")]
    public class ItemTrendHandle : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            eBageType bagType = (eBageType)packet.ReadInt();
            int place = packet.ReadInt();
            eBageType bagType2 = (eBageType)packet.ReadInt();
            List<ShopItemInfo> list = new List<ShopItemInfo>();
            int num = packet.ReadInt();
            int operation = packet.ReadInt();
            ItemInfo itemInfo;
            if (num == -1)
            {
                packet.ReadInt();
                packet.ReadInt();
                int num2 = 0;
                int num3 = 0;
                itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(34101), 1, 102);
                list = ShopMgr.FindShopbyTemplatID(34101);
                for (int i = 0; i < list.Count; i++)
                {
                    if (list[i].APrice1 == -1 && list[i].AValue1 != 0)
                    {
                        num3 = list[i].AValue1;
                        itemInfo.ValidDate = list[i].AUnit;
                    }
                }
                if (itemInfo != null)
                {
                    if (num2 <= client.Player.PlayerCharacter.Gold && num3 <= client.Player.PlayerCharacter.Money + client.Player.PlayerCharacter.MoneyLock)
                    {
                        client.Player.RemoveMoney(num3);
                        client.Player.RemoveGold(num2);
                    }
                    else
                    {
                        itemInfo = null;
                    }
                }
            }
            else
            {
                itemInfo = client.Player.GetItemAt(bagType2, num);
            }
            ItemInfo itemAt = client.Player.GetItemAt(bagType, place);
            StringBuilder stringBuilder = new StringBuilder();
            if (itemInfo != null && itemAt != null)
            {
                bool result = false;
                ItemTemplateInfo itemTemplateInfo = RefineryMgr.RefineryTrend(operation, itemAt, ref result);
                if (result && itemTemplateInfo != null)
                {
                    ItemInfo itemInfo2 = ItemInfo.CreateFromTemplate(itemTemplateInfo, 1, 115);
                    AbstractInventory itemInventory = client.Player.GetItemInventory(itemTemplateInfo);
                    if (itemInventory.AddItem(itemInfo2, itemInventory.BeginSlot))
                    {
                        client.Player.UpdateItem(itemInfo2);
                        client.Player.RemoveItem(itemAt);
                        itemInfo.Count--;
                        client.Player.UpdateItem(itemInfo);
                        client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ItemTrendHandle.Success"));
                    }
                    else
                    {
                        stringBuilder.Append("NoPlace");
                        client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation(itemInfo2.GetBagName()) + LanguageMgr.GetTranslation("ItemFusionHandler.NoPlace"));
                    }
                    return 1;
                }
                client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ItemTrendHandle.Fail"));
            }
            return 1;
        }
    }
}
