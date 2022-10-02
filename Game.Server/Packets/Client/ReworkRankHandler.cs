using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(189, "场景用户离开")]
	public class ReworkRankHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			string text = packet.ReadString();
			if (!string.IsNullOrEmpty(text))
			{
				client.Player.UpdateHonor(text);
			}
			return 0;
        }
    }
}
