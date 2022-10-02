using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(47, "解除物品")]
	public class UserUnchainItemHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.CurrentRoom == null || !client.Player.CurrentRoom.IsPlaying)
			{
				int fromSlot = packet.ReadInt();
				int toSlot = client.Player.EquipBag.FindFirstEmptySlot(31);
				client.Player.EquipBag.MoveItem(fromSlot, toSlot, 0);
			}
			return 0;
        }
    }
}
