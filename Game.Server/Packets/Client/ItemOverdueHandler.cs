using System;
using Game.Server.GameObjects;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Game.Server.GameUtils;
using Bussiness;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.ITEM_OVERDUE, "物品过期")]
    public class ItemOverdueHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            //已经开始游戏则不处理
            if (client.Player.CurrentRoom != null && client.Player.CurrentRoom.IsPlaying)
                return 0;
            int bagType = packet.ReadByte();
            int place = packet.ReadInt();
            PlayerInventory inventory = client.Player.GetInventory((eBageType)bagType);
            if (inventory != null)
            {
                if (inventory.GetItemAt(place) != null)
                {
                    ItemInfo item = inventory.GetItemAt(place);
                    //Console.WriteLine(string.Format("bagType {0} Place: {1} Name {2}", bagType, place, item.Template.Name));
                    if (item != null && !item.IsValidItem())
                    {
                        if (bagType == 0 && place < 30)
                        {
                            int slot = inventory.FindFirstEmptySlot(inventory.BeginSlot, 80);
                            if (Equip.isAvatar(item.Template))
                            {
                                slot = inventory.FindFirstEmptySlot(81);
                            }
                            if (slot == -1 || !inventory.MoveItem(item.Place, slot, item.Count))
                            {
                                client.Player.SendItemToMail(item, LanguageMgr.GetTranslation("ItemOverdueHandler.Content"), LanguageMgr.GetTranslation("ItemOverdueHandler.Title"), eMailType.ItemOverdue);
                                client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
                                //Console.WriteLine("ItemOverdueHandler {0}", item.Template.Name);
                            }
                        }
                        else
                        {
                            inventory.UpdateItem(item);
                        }
                    }
                }
            }
            return 0;
        }
    }
}
