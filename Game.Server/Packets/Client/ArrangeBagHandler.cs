using Game.Base.Packets;
using Game.Server.GameUtils;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.Packets.Client
{
    [PacketHandler(124, "Arrange Bag")]
	public class ArrangeBagHandler : IPacketHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			bool flag = packet.ReadBoolean();
			int num = packet.ReadInt();
			int bageType = packet.ReadInt();
			PlayerInventory inventory = client.Player.GetInventory((eBageType)bageType);
			int capalility = inventory.Capalility;
			List<ItemInfo> items = inventory.GetItems(inventory.BeginSlot, capalility);
			if (num == items.Count)
			{
				inventory.BeginChanges();
				try
				{
					if (inventory.FindFirstEmptySlot(inventory.BeginSlot, capalility) != -1)
					{
						for (int i = 1; inventory.FindFirstEmptySlot(inventory.BeginSlot, capalility) < items[items.Count - i].Place; i++)
						{
							inventory.MoveItem(items[items.Count - i].Place, inventory.FindFirstEmptySlot(inventory.BeginSlot, capalility), items[items.Count - i].Count);
						}
					}
				}
				finally
				{
					if (flag)
					{
						try
						{
							items = inventory.GetItems(inventory.BeginSlot, capalility);
							List<int> list = new List<int>();
							for (int j = 0; j < items.Count; j++)
							{
								if (list.Contains(j))
								{
									continue;
								}
								for (int num2 = items.Count - 1; num2 > j; num2--)
								{
									if (!list.Contains(num2) && items[j].TemplateID == items[num2].TemplateID && items[j].CanStackedTo(items[num2]))
									{
										inventory.MoveItem(items[num2].Place, items[j].Place, items[num2].Count);
										list.Add(num2);
									}
								}
							}
						}
						finally
						{
							items = inventory.GetItems(inventory.BeginSlot, capalility);
							if (inventory.FindFirstEmptySlot(inventory.BeginSlot, capalility) != -1)
							{
								for (int k = 1; inventory.FindFirstEmptySlot(inventory.BeginSlot, capalility) < items[items.Count - k].Place; k++)
								{
									inventory.MoveItem(items[items.Count - k].Place, inventory.FindFirstEmptySlot(inventory.BeginSlot, capalility), items[items.Count - k].Count);
								}
							}
						}
					}
					inventory.CommitChanges();
				}
			}
			else
			{
				Console.WriteLine($"is not count equal  capability: {capalility}");
			}
			return 0;
        }
    }
}
