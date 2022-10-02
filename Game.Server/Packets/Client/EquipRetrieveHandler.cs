using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server;
using Game.Server.GameUtils;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using Game.Logic;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.EQUIP_RECYCLE_ITEM, "场景用户离开")]
    public class EquipRetrieveHandler : IPacketHandler
    {
        private Random rnd = new Random();

        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int probability = 0;
            PlayerInventory inventory = client.Player.GetInventory(eBageType.Store);
            int totalQuality = 0;
            bool isBlind = false;
            for (int i = 1; i < 5; i++)
            {
                ItemInfo item = inventory.GetItemAt(i);
                if (item != null)
                {
                    inventory.RemoveItemAt(i);
                }
                if (item.IsBinds)
                {
                    isBlind = true;
                }

                totalQuality += item.Template.Quality;

            }
            switch (totalQuality)
            {
                case 8:
                case 12:
                case 15:
                case 20:
                    probability = totalQuality;
                    break;
            }
            List<ItemInfo> infos = null;
            DropInventory.RetrieveDrop(probability, ref infos);
            int index = rnd.Next(infos.Count);
            int templateID = infos[index].TemplateID;
            ItemInfo RecycleItem = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(templateID), 1, 105);
            RecycleItem.IsBinds = isBlind;
            RecycleItem.BeginDate = DateTime.Now;
            if (RecycleItem.Template.CategoryID != 11)
            {
                RecycleItem.ValidDate = 30;
                RecycleItem.IsBinds = true;
            }
            RecycleItem.IsBinds = true;
            inventory.AddItemTo(RecycleItem, 0);

            return 1;
        }

    }
}
