using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(218, "场景用户离开")]
	public class UserGetGiftHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			UserGiftInfo[] array = null;
			PlayerInfo playerInfo = client.Player.PlayerCharacter;
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				array = playerBussiness.GetAllUserReceivedGifts(num);
				if (playerInfo.ID != num)
				{
					GamePlayer playerById = WorldMgr.GetPlayerById(num);
					playerInfo = ((playerById == null) ? playerBussiness.GetUserSingleByUserID(num) : playerById.PlayerCharacter);
				}
			}
			if (array != null && playerInfo != null)
			{
				client.Out.SendGetUserGift(playerInfo, array);
			}
			return 0;
        }
    }
}
