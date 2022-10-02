using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(160, "添加好友")]
	public class IMHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			byte b = packet.ReadByte();
			switch (b)
			{
			case 160:
			{
				string text = packet.ReadString();
				int num3 = packet.ReadInt();
				if (num3 < 0 || num3 > 1)
				{
					return 1;
				}
				using (PlayerBussiness playerBussiness2 = new PlayerBussiness())
				{
					PlayerInfo playerInfo = null;
					GamePlayer clientByPlayerNickName = WorldMgr.GetClientByPlayerNickName(text);
					playerInfo = ((clientByPlayerNickName == null) ? playerBussiness2.GetUserSingleByNickName(text) : clientByPlayerNickName.PlayerCharacter);
					if (playerInfo != null)
					{
						if (!client.Player.Friends.ContainsKey(playerInfo.ID) || client.Player.Friends[playerInfo.ID] != num3)
						{
							FriendInfo friendInfo = new FriendInfo();
							friendInfo.FriendID = playerInfo.ID;
							friendInfo.IsExist = true;
							friendInfo.Remark = "";
							friendInfo.UserID = client.Player.PlayerCharacter.ID;
							friendInfo.Relation = num3;
							if (!playerBussiness2.AddFriends(friendInfo))
							{
								break;
							}
							client.Player.FriendsAdd(playerInfo.ID, num3);
							if (num3 != 1 && playerInfo.State != 0)
							{
								GSPacketIn gSPacketIn = new GSPacketIn(160, client.Player.PlayerCharacter.ID);
								gSPacketIn.WriteByte(166);
								gSPacketIn.WriteInt(playerInfo.ID);
								gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
								gSPacketIn.WriteBoolean(val: false);
								if (clientByPlayerNickName != null)
								{
									clientByPlayerNickName.SendTCP(gSPacketIn);
								}
								else
								{
									GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
								}
							}
							client.Out.SendAddFriend(playerInfo, num3, state: true);
							client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("FriendAddHandler.Success2"));
							break;
						}
						client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("FriendAddHandler.Falied"));
					}
					else
					{
						client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("FriendAddHandler.Success") + text);
					}
				}
				break;
			}
			case 161:
			{
				int num2 = packet.ReadInt();
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					if (playerBussiness.DeleteFriends(client.Player.PlayerCharacter.ID, num2))
					{
						client.Player.FriendsRemove(num2);
						client.Out.SendFriendRemove(num2);
					}
				}
				break;
			}
			case 165:
			{
				int num4 = packet.ReadInt();
				GSPacketIn gSPacketIn2 = new GSPacketIn(160, client.Player.PlayerCharacter.ID);
				gSPacketIn2.WriteByte(165);
				gSPacketIn2.WriteInt(num4);
				gSPacketIn2.WriteInt(client.Player.PlayerCharacter.typeVIP);
				gSPacketIn2.WriteInt(client.Player.PlayerCharacter.VIPLevel);
				gSPacketIn2.WriteBoolean(val: false);
				GameServer.Instance.LoginServer.SendPacket(gSPacketIn2);
				WorldMgr.ChangePlayerState(client.Player.PlayerCharacter.ID, num4, client.Player.PlayerCharacter.ConsortiaID);
				break;
			}
			case 51:
			{
				int num = packet.ReadInt();
				string msg = packet.ReadString();
				packet.ReadBoolean();
				GamePlayer playerById = WorldMgr.GetPlayerById(num);
				if (playerById != null)
				{
					client.Player.Out.sendOneOnOneTalk(num, isAutoReply: false, client.Player.PlayerCharacter.NickName, msg, client.Player.PlayerCharacter.ID);
					playerById.Out.sendOneOnOneTalk(client.Player.PlayerCharacter.ID, isAutoReply: false, client.Player.PlayerCharacter.NickName, msg, num);
				}
				else
				{
					client.Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("FriendAddHandler.Ofline"));
				}
				break;
			}
			default:
			{
				IMPackageType iMPackageType = (IMPackageType)b;
				Console.WriteLine("IMPackageType." + iMPackageType);
				break;
			}
			}
			return 1;
        }
    }
}
