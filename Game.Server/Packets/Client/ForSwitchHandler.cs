using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(225, "场景用户离开")]
	public class ForSwitchHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			GSPacketIn pkg = new GSPacketIn(225, client.Player.PlayerCharacter.ID);
			client.SendTCP(pkg);
			return 0;
        }
    }
}
