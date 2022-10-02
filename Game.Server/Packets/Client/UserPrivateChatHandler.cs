using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(37, "用户与用户之间的聊天")]
	public class UserPrivateChatHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			string text = packet.ReadString();
			packet.ReadString();
			string str = packet.ReadString();
			bool val = packet.ReadBoolean();
			if (num == 0)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				PlayerInfo userSingleByNickName = playerBussiness.GetUserSingleByNickName(text);
				if (userSingleByNickName != null)
				{
					num = userSingleByNickName.ID;
				}
			}
			if (num != 0)
			{
				GSPacketIn gSPacketIn = packet.Clone();
				gSPacketIn.ClearContext();
				gSPacketIn.ClientID = client.Player.PlayerCharacter.ID;
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteString(text);
				gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
				gSPacketIn.WriteString(str);
				gSPacketIn.WriteBoolean(val);
				GamePlayer playerById = WorldMgr.GetPlayerById(num);
				if (playerById != null)
				{
					if (playerById.IsBlackFriend(client.Player.PlayerCharacter.ID))
					{
						return 1;
					}
					playerById.Out.SendTCP(gSPacketIn);
				}
				else
				{
					GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
				}
				client.Out.SendTCP(gSPacketIn);
			}
			else
			{
				client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("UserPrivateChatHandler.NoUser"));
			}
			return 1;
        }
    }
}
