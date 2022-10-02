using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(85, "场景用户离开")]
	public class MateTimeHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			GamePlayer playerById = WorldMgr.GetPlayerById(num);
			PlayerInfo playerInfo;
			if (playerById != null)
			{
				playerInfo = playerById.PlayerCharacter;
			}
			else
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				playerInfo = playerBussiness.GetUserSingleByUserID(num);
			}
			GSPacketIn gSPacketIn = new GSPacketIn(85, client.Player.PlayerCharacter.ID);
			if (playerInfo == null)
			{
				gSPacketIn.WriteDateTime(DateTime.Now);
			}
			else
			{
				gSPacketIn.WriteDateTime(playerInfo.LastDate);
			}
			client.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
