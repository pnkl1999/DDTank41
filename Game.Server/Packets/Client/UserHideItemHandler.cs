using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(60, "隐藏装备")]
	public class UserHideItemHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			bool hide = packet.ReadBoolean();
			int num = packet.ReadInt();
			switch (num)
			{
			case 13:
				num = 3;
				break;
			case 15:
				num = 4;
				break;
			}
			client.Player.HideEquip(num, hide);
			return 0;
        }
    }
}
