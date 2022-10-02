using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.REClAIM_GOODS, "物品比较")]
    public class ItemReclaimHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            eBageType bagType = (eBageType)packet.ReadByte();
            int place = packet.ReadInt();
            int count = packet.ReadInt();
            PlayerInventory bag = client.Player.GetInventory(bagType);
            if (bag != null && bag.GetItemAt(place) != null)
            {
                if (bag.GetItemAt(place).Count <= count)
                {
                    count = bag.GetItemAt(place).Count;
                }
                ItemTemplateInfo item = bag.GetItemAt(place).Template;
                int price = count * item.ReclaimValue;
                if (item.ReclaimType == 3)
                {
                    client.Out.SendMessage(eMessageType.GM_NOTICE, $"Không thể bán vật phẩm này.");
                    return 0;
                    //client.Player.AddMoney(num3);
                    //client.Out.SendMessage(eMessageType.GM_NOTICE, $"Bạn nhận được {num3} xu.");
                }
                else if (item.ReclaimType == 2)
                {
                    client.Player.AddGiftToken(price);
                    //client.Out.SendMessage(eMessageType.GM_NOTICE, $"Bạn nhận được {num3} lễ kim.");
                    client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemReclaimHandler.Success1", price));
                }
                else if (item.ReclaimType == 1)
                {
                    client.Player.AddGold(price);
                    //client.Out.SendMessage(eMessageType.GM_NOTICE, $"Bạn nhận được {price} vàng.");
                    client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemReclaimHandler.Success2", price));
                }
                if (item.TemplateID == 11408)
                {
                    client.Player.RemoveMedal(count);
                }
                bag.RemoveItemAt(place);
                return 0;
            }
            //client.Out.SendMessage(eMessageType.GM_NOTICE, $"Bán vật phẩm không thành công.");
            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemReclaimHandler.NoSuccess"));
            return 1;
        }
    }
}
