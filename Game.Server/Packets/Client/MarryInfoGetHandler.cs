using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(235, "获取征婚信息")]
	internal class MarryInfoGetHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.PlayerCharacter.MarryInfoID != 0)
			{
				int iD = packet.ReadInt();
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				MarryInfo marryInfoSingle = playerBussiness.GetMarryInfoSingle(iD);
				if (marryInfoSingle != null)
				{
					client.Player.Out.SendMarryInfo(client.Player, marryInfoSingle);
					return 0;
				}
			}
			return 1;
        }
    }
}
