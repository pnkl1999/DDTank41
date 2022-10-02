using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System.Collections.Generic;
using System.Text;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.SEND_MAIL, "发送邮件")]
	public class UserSendMailHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.PlayerCharacter.Gold < 100)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("UserSendMailHandler.GoldNotEnought"));
				packet.WriteBoolean(val: false);
				client.Out.SendTCP(packet);
				return 1;
			}

			if (client.Player.PlayerCharacter.Money < 0)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, "Tài khoản của bạn đang bị âm xu không thể gửi thư");
				packet.WriteBoolean(val: false);
				client.Out.SendTCP(packet);
				return 1;
			}

			if (client.Player.IsLimitMail())
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("UserSendMailHandler.IsLimitMail"));
				packet.WriteBoolean(val: false);
				client.Out.SendTCP(packet);
				return 1;
			}
			string msg = "UserSendMailHandler.Success";
			eMessageType eMsg = eMessageType.GM_NOTICE;
			GSPacketIn pkg = packet.Clone();
			pkg.ClearContext();
			string nickName = packet.ReadString().Trim();
			string title = packet.ReadString();
			string content = packet.ReadString();
			bool isPay = packet.ReadBoolean();
			int validDate = packet.ReadInt();
			int money = packet.ReadInt();
			eBageType eBageType = (eBageType)packet.ReadByte();
			int place = packet.ReadInt();
			eBageType eBageType2 = (eBageType)packet.ReadByte();
			int num4 = packet.ReadInt();
			eBageType eBageType3 = (eBageType)packet.ReadByte();
			int num5 = packet.ReadInt();
			eBageType eBageType4 = (eBageType)packet.ReadByte();
			int num6 = packet.ReadInt();

			// Chức năng của BAOLT - Lâm đừng copaste nha
			if (client.Player.isPlayerWarrior())
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, "Tài khoản không có quyền thực hiện chức năng này.");
				return 0;
			}
			if ((money != 0 || place != -1 || num4 != -1 || num5 != -1 || num6 != -1) && client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Bag.Locked"));
				pkg.WriteBoolean(val: false);
				client.Out.SendTCP(pkg);
				return 1;
			}
			using (PlayerBussiness pb = new PlayerBussiness())
			{
				GamePlayer player = WorldMgr.GetClientByPlayerNickName(nickName);
				PlayerInfo user = ((player != null) ? player.PlayerCharacter : pb.GetUserSingleByNickName(nickName));
				if (user != null && !string.IsNullOrEmpty(nickName))
				{
					if (user.NickName != client.Player.PlayerCharacter.NickName)
					{
						client.Player.SaveIntoDatabase();
						MailInfo message = new MailInfo();
						message.SenderID = client.Player.PlayerCharacter.ID;
						message.Sender = client.Player.PlayerCharacter.NickName;
						message.ReceiverID = user.ID;
						message.Receiver = user.NickName;
						message.IsExist = true;
						message.Gold = 0;
						message.Money = 0;
						message.Title = title;
						message.Content = content;
						List<ItemInfo> item = new List<ItemInfo>();
						List<eBageType> bagType = new List<eBageType>();
						StringBuilder annexRemark = new StringBuilder();
						annexRemark.Append(LanguageMgr.GetTranslation("UserSendMailHandler.AnnexRemark"));
						int index = 0;
						if (place != -1)
						{
							ItemInfo info = client.Player.GetItemAt(eBageType, place);
							if (info != null && !info.IsBinds)
							{
								message.Annex1Name = info.Template.Name;
								message.Annex1 = info.ItemID.ToString();
								item.Add(info);
								bagType.Add(eBageType);
								index++;
								annexRemark.Append(index);
								annexRemark.Append("、");
								annexRemark.Append(message.Annex1Name);
								annexRemark.Append("x");
								annexRemark.Append(info.Count);
								annexRemark.Append(";");
							}
						}
						if (num4 != -1)
						{
							ItemInfo info = client.Player.GetItemAt(eBageType2, num4);
							if (info != null && !info.IsBinds)
							{
								message.Annex2Name = info.Template.Name;
								message.Annex2 = info.ItemID.ToString();
								item.Add(info);
								bagType.Add(eBageType2);
								index++;
								annexRemark.Append(index);
								annexRemark.Append("、");
								annexRemark.Append(message.Annex2Name);
								annexRemark.Append("x");
								annexRemark.Append(info.Count);
								annexRemark.Append(";");
							}
						}
						if (num5 != -1)
						{
							ItemInfo info = client.Player.GetItemAt(eBageType3, num5);
							if (info != null && !info.IsBinds)
							{
								message.Annex3Name = info.Template.Name;
								message.Annex3 = info.ItemID.ToString();
								item.Add(info);
								bagType.Add(eBageType3);
								index++;
								annexRemark.Append(index);
								annexRemark.Append("、");
								annexRemark.Append(message.Annex3Name);
								annexRemark.Append("x");
								annexRemark.Append(info.Count);
								annexRemark.Append(";");
							}
						}
						if (num6 != -1)
						{
							ItemInfo info = client.Player.GetItemAt(eBageType4, num6);
							if (info != null && !info.IsBinds)
							{
								message.Annex4Name = info.Template.Name;
								message.Annex4 = info.ItemID.ToString();
								item.Add(info);
								bagType.Add(eBageType4);
								index++;
								annexRemark.Append(index);
								annexRemark.Append("、");
								annexRemark.Append(message.Annex4Name);
								annexRemark.Append("x");
								annexRemark.Append(info.Count);
								annexRemark.Append(";");
							}
						}
						if (isPay)
						{
							if (money <= 0 || (string.IsNullOrEmpty(message.Annex1) && string.IsNullOrEmpty(message.Annex2) && string.IsNullOrEmpty(message.Annex3) && string.IsNullOrEmpty(message.Annex4)))
							{
								return 1;
							}
							message.ValidDate = validDate == 1 ? 1 : 6;
							message.Type = 101;
							if (money > 0)
							{
								message.Money = money;
								index++;
								annexRemark.Append(index);
								annexRemark.Append("、");
								annexRemark.Append(LanguageMgr.GetTranslation("UserSendMailHandler.PayMoney"));
								annexRemark.Append(money);
								annexRemark.Append(";");
							}
						}
						else
						{
							message.Type = 1;
							if (client.Player.PlayerCharacter.Money >= money && money > 0)
							{
								message.Money = money;
								client.Player.RemoveMoneyNoviceActive(money);
								//client.RemoveMoney(money, true);
								index++;
								annexRemark.Append(index);
								annexRemark.Append("、");
								annexRemark.Append(LanguageMgr.GetTranslation("UserSendMailHandler.Money"));
								annexRemark.Append(money);
								annexRemark.Append(";");
							}
						}
						if (annexRemark.Length > 1)
						{
							message.AnnexRemark = annexRemark.ToString();
						}
						if (pb.SendMail(message))
						{
							client.Player.RemoveGold(100);
							for (int i = 0; i < item.Count; i++)
							{
								item[i].UserID = 0;
								client.Player.RemoveItem(item[i]);
								item[i].IsExist = true;
							}
						}
						client.Player.SaveIntoDatabase();
						pkg.WriteBoolean(val: true);
						if (user.State != 0)
						{
							client.Player.Out.SendMailResponse(user.ID, eMailRespose.Receiver);
						}
						client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Send);
					}
					else
					{
						msg = "UserSendMailHandler.Failed1";
						pkg.WriteBoolean(val: false);
					}
				}
				else
				{
					eMsg = eMessageType.BIGBUGLE_NOTICE;
					msg = "UserSendMailHandler.Failed2";
					pkg.WriteBoolean(val: false);
				}
			}
			client.Out.SendMessage(eMsg, LanguageMgr.GetTranslation(msg));
			client.Out.SendTCP(pkg);
			return 0;
        }
    }
}
