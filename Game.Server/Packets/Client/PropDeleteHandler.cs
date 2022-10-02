using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(75, "删除道具")]
	public class PropDeleteHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int place = packet.ReadInt();
			client.Player.FightBag.RemoveItemAt(place);
			return 0;
        }
    }
}
