using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;
using System.IO;

namespace Game.Server.Packets.Client
{
    [PacketHandler(19, "用户场景聊天")]
	public class SceneChatHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			packet.ClientID = client.Player.PlayerCharacter.ID;
			byte b = packet.ReadByte();
			bool flag = packet.ReadBoolean();
			packet.ReadString();
			string text = packet.ReadString();
			string[] array = text.Split('$');
			if (false)
			{
				if (array[1].Equals("ban") && CheckAdmin(client.Player.PlayerCharacter.ID, array[1]))
				{
					DateTime dateTime = DateTime.Now.AddYears(20);
					if (array.Length >= 4 && array[3].Length >= 8)
					{
						if (array.Length == 5)
						{
							int result = 0;
							if (!int.TryParse(array[4], out result))
							{
								client.Player.SendMessage("Failed converting to days");
								return 0;
							}
							dateTime = DateTime.Now.AddDays(result);
						}
						using ManageBussiness manageBussiness = new ManageBussiness();
						if (manageBussiness.ForbidPlayerByNickName(array[2], dateTime, isExist: false, array[3]))
						{
							GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
							for (int i = 0; i < allPlayers.Length; i++)
							{
								allPlayers[i].SendMessage("O usuário " + array[2] + " foi banido do jogo.");
							}
							using StreamWriter w = File.AppendText("BanLog.txt");
							Log(client.Player.PlayerCharacter.NickName + " banned the user " + array[2] + " for " + (dateTime - DateTime.Now).TotalDays + " days, reason: " + array[3], w);
						}
						else
						{
							client.Player.SendMessage("Failed to ban the user " + array[2]);
						}
					}
					else
					{
						client.Player.SendMessage("Comando em formato inválido. Use $ban$nick$motivo$dias ou $ban$nick$motivo para ban permanente. Motivo não pode ser vazio ou muito curto!");
					}
				}
				if (array[1].Equals("mute") && CheckAdmin(client.Player.PlayerCharacter.ID, array[1]))
				{
					if (array.Length == 5 && array[4].Length >= 8)
					{
						DateTime dateTime2 = DateTime.Now.AddMinutes(Convert.ToInt32(array[3]));
						GamePlayer clientByPlayerNickName = WorldMgr.GetClientByPlayerNickName(array[2]);
						if (clientByPlayerNickName == null || dateTime2 <= DateTime.Now)
						{
							client.Player.SendMessage("Failed to mute the user" + array[2]);
							return 0;
						}
						clientByPlayerNickName.PlayerCharacter.IsBanChat = true;
						clientByPlayerNickName.PlayerCharacter.BanChatEndDate = dateTime2;
						using StreamWriter w2 = File.AppendText("MuteLog.txt");
						Log(client.Player.PlayerCharacter.NickName + " muted the user " + array[2] + " for " + array[3] + " minutes, reason: " + array[4], w2);
					}
					else
					{
						client.Player.SendMessage("Comando em formato inválido. Use $mute$nick$minutos$motivo. Motivo não pode ser vazio ou muito curto!");
					}
				}
				if (array[1].Equals("unban") && CheckAdmin(client.Player.PlayerCharacter.ID, array[1]))
				{
					if (array.Length == 4 && array[3].Length >= 8)
					{
						DateTime now = DateTime.Now;
						using ManageBussiness manageBussiness2 = new ManageBussiness();
						if (manageBussiness2.ForbidPlayerByNickName(array[2], now, isExist: true))
						{
							using StreamWriter w3 = File.AppendText("BanLog.txt");
							Log(client.Player.PlayerCharacter.NickName + " unban the user " + array[2] + ", reason: " + array[3], w3);
						}
						else
						{
							client.Player.SendMessage("Failed to unban the user " + array[2]);
						}
					}
					else
					{
						client.Player.SendMessage("Comando em formato inválido. Use $desban$nick$motivo. Motivo não pode ser vazio ou muito curto!");
					}
				}
				if (array[1].Equals("kick") && CheckAdmin(client.Player.PlayerCharacter.ID, array[1]))
				{
					if (array.Length == 4 && array[3].Length >= 8)
					{
						using ManageBussiness manageBussiness3 = new ManageBussiness();
						if (manageBussiness3.KitoffUserByNickName(array[2], "Kick") == 0)
						{
							using StreamWriter w4 = File.AppendText("KickLog.txt");
							Log(client.Player.PlayerCharacter.NickName + " kicked the user " + array[2] + ", reason: " + array[3], w4);
						}
						else
						{
							client.Player.SendMessage("Failed to kick the user " + array[2]);
						}
					}
					else
					{
						client.Player.SendMessage("Comando em formato inválido. Use $kick$nick$motivo. Motivo não pode ser vazio ou muito curto!");
					}
				}
			}
			else
			{
				GSPacketIn gSPacketIn = new GSPacketIn(19, client.Player.PlayerCharacter.ID);
				gSPacketIn.WriteInt(client.Player.ZoneId);
				gSPacketIn.WriteByte(b);
				gSPacketIn.WriteBoolean(flag);
				gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
				gSPacketIn.WriteString(text);
				if (client.Player.CurrentRoom != null && client.Player.CurrentRoom.RoomType == eRoomType.Match && client.Player.CurrentRoom.Game != null)
				{
					if (b != 3)
					{
						client.Player.CurrentRoom.BattleServer.Server.SendChatMessage(text, client.Player, flag);
					}
					else
					{
						if (client.Player.PlayerCharacter.ConsortiaID == 0)
						{
							return 0;
						}
						if (client.Player.PlayerCharacter.IsBanChat)
						{
							client.Out.SendMessage(eMessageType.ChatERROR, LanguageMgr.GetTranslation("ConsortiaChatHandler.IsBanChat"));
							return 1;
						}
						gSPacketIn.WriteInt(client.Player.PlayerCharacter.ConsortiaID);
						GamePlayer[] allPlayers2 = WorldMgr.GetAllPlayers();
						GamePlayer[] array2 = allPlayers2;
						foreach (GamePlayer gamePlayer in array2)
						{
							if (gamePlayer.PlayerCharacter.ConsortiaID == client.Player.PlayerCharacter.ConsortiaID && !gamePlayer.IsBlackFriend(client.Player.PlayerCharacter.ID))
							{
								gamePlayer.Out.SendTCP(gSPacketIn);
							}
						}
					}
					return 1;
				}
				switch (b)
				{
				case 3:
				{
					if (client.Player.PlayerCharacter.ConsortiaID == 0)
					{
						return 0;
					}
					if (client.Player.PlayerCharacter.IsBanChat)
					{
						client.Out.SendMessage(eMessageType.ChatERROR, LanguageMgr.GetTranslation("ConsortiaChatHandler.IsBanChat"));
						return 1;
					}
					gSPacketIn.WriteInt(client.Player.PlayerCharacter.ConsortiaID);
					GamePlayer[] allPlayers4 = WorldMgr.GetAllPlayers();
					GamePlayer[] array4 = allPlayers4;
					foreach (GamePlayer gamePlayer3 in array4)
					{
						if (gamePlayer3.PlayerCharacter.ConsortiaID == client.Player.PlayerCharacter.ConsortiaID && !gamePlayer3.IsBlackFriend(client.Player.PlayerCharacter.ID))
						{
							gamePlayer3.Out.SendTCP(gSPacketIn);
						}
					}
					break;
				}
				case 9:
					if (client.Player.CurrentMarryRoom == null)
					{
						return 1;
					}
					client.Player.CurrentMarryRoom.SendToAllForScene(gSPacketIn, client.Player.MarryMap);
					break;
				case 13:
					if (client.Player.CurrentHotSpringRoom == null)
					{
						return 1;
					}
					client.Player.CurrentHotSpringRoom.SendToRoomPlayer(gSPacketIn);
					break;
				default:
				{
					if (client.Player.CurrentRoom != null)
					{
						if (flag)
						{
							client.Player.CurrentRoom.SendToTeam(gSPacketIn, client.Player.CurrentRoomTeam, client.Player);
						}
						else
						{
							client.Player.CurrentRoom.SendToAll(gSPacketIn);
						}
						break;
					}
					if (text == "xoatrangbi")
					{
						ItemInfo itemAt = client.Player.EquipBag.GetItemAt(78);
						if (itemAt == null)
						{
							client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, $"không ti\u0300m thâ\u0301y vâ\u0323t phâ\u0309m câ\u0300n xo\u0301a ta\u0323i ô cuô\u0301i BAG1 trang bi\u0323");
						}
						else
						{
							client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, $"Hủy vật phẩm thành công!");
							client.Player.RemoveItem(itemAt);
						}
					}
					if (text == "xoadaocu")
					{
						ItemInfo itemAt2 = client.Player.PropBag.GetItemAt(47);
						if (itemAt2 == null)
						{
							client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, $"không ti\u0300m thâ\u0301y vâ\u0323t phâ\u0309m câ\u0300n xo\u0301a ta\u0323i ô cuô\u0301i BAG1 đa\u0323o cu\u0323");
						}
						else
						{
							client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, $"Hủy vật phẩm thành công!");
							client.Player.RemoveItem(itemAt2);
						}
					}
					else if ((text != "xoatrangbi" || text != "xoadaocu") && DateTime.Compare(client.Player.LastChatTime.AddSeconds(30.0), DateTime.Now) > 0)
					{
						client.Out.SendMessage(eMessageType.ChatERROR, LanguageMgr.GetTranslation("SceneChatHandler.Fast"));
						return 1;
					}
					if (DateTime.Compare(client.Player.LastChatTime.AddSeconds(1.0), DateTime.Now) > 0 && b == 5)
					{
						return 1;
					}
					if (flag)
					{
						return 1;
					}
					client.Player.LastChatTime = DateTime.Now;
					GamePlayer[] allPlayers3 = WorldMgr.GetAllPlayers();
					GamePlayer[] array3 = allPlayers3;
					foreach (GamePlayer gamePlayer2 in array3)
					{
						if (gamePlayer2.CurrentRoom == null && gamePlayer2.CurrentMarryRoom == null && gamePlayer2.CurrentHotSpringRoom == null && !gamePlayer2.IsBlackFriend(client.Player.PlayerCharacter.ID))
						{
							gamePlayer2.Out.SendTCP(gSPacketIn);
						}
					}
					break;
				}
				}
			}
			return 1;
        }

        public bool CheckAdmin(int UserID, string Command)
        {
			return CommandsMgr.CheckAdmin(UserID, Command);
        }

        public static void Log(string logMessage, TextWriter w)
        {
			w.Write("\r\nLog Entry : ");
			w.WriteLine("{0} {1}", DateTime.Now.ToLongTimeString(), DateTime.Now.ToLongDateString());
			w.WriteLine("  :");
			w.WriteLine("  :{0}", logMessage);
			w.WriteLine("-------------------------------");
        }
    }
}
