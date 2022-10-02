using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(34, "场景用户离开")]
	public class ChangeDesignationHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			bool isShowConsortia = packet.ReadBoolean();
			client.Player.PlayerCharacter.IsShowConsortia = isShowConsortia;
			return 0;
        }
    }
}
