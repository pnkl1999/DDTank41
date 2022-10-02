using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler(18, "场景用户离开")]
	public class GetPlayerCardHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			GamePlayer playerById = WorldMgr.GetPlayerById(num);
			PlayerInfo playerInfo;
			List<UsersCardInfo> list;
			if (playerById != null)
			{
				playerInfo = playerById.PlayerCharacter;
				list = playerById.CardBag.GetCards(0, 4);
			}
			else
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				playerInfo = playerBussiness.GetUserSingleByUserID(num);
				list = playerBussiness.GetUserCardEuqip(num);
			}
			if (list != null && playerInfo != null)
			{
				client.Player.Out.SendUpdateCardData(playerInfo, list);
			}
			//client.Player.OnCardEquipEvent(list);
			return 0;
        }
    }
}
