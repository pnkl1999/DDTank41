using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(141, "防沉迷系统开关")]
	public class AcademyHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			switch (packet.ReadByte())
			{
			case 4:
			{
				int num5 = packet.ReadInt();
				string str2 = packet.ReadString();
				if (AcademyMgr.GetRequest(client.Player.PlayerId, num5) != null)
				{
					break;
				}
				if (client.Player.PlayerCharacter.freezesDate <= DateTime.Now)
				{
					GamePlayer playerById3 = WorldMgr.GetPlayerById(num5);
					if (playerById3 != null && playerById3.PlayerCharacter.apprenticeshipState < AcademyMgr.MASTER_FULL_STATE && AcademyMgr.CheckCanMaster(playerById3.PlayerCharacter.Grade))
					{
						AcademyMgr.AddRequest(new AcademyRequestInfo
						{
							SenderID = client.Player.PlayerId,
							ReceiderID = num5,
							Type = 1,
							CreateTime = DateTime.Now
						});
						GSPacketIn gSPacketIn2 = new GSPacketIn(141);
						gSPacketIn2.WriteByte(4);
						gSPacketIn2.WriteInt(client.Player.PlayerId);
						gSPacketIn2.WriteString(client.Player.PlayerCharacter.NickName);
						gSPacketIn2.WriteString(str2);
						playerById3.SendTCP(gSPacketIn2);
					}
					else
					{
						client.Player.SendMessage($"Ngươ\u0300i chơi na\u0300y không online.");
					}
				}
				else
				{
					client.Player.SendMessage($"Bạn bị giới hạn do trước đó đã từ bỏ đệ tử hoặc sư phụ. Vui lòng thử lại sau {checkDate(client.Player.PlayerCharacter.freezesDate)} giờ nữa.");
				}
				break;
			}
			case 5:
			{
				int num4 = packet.ReadInt();
				string str = packet.ReadString();
				if (AcademyMgr.GetRequest(client.Player.PlayerId, num4) != null)
				{
					break;
				}
				if (client.Player.PlayerCharacter.freezesDate <= DateTime.Now)
				{
					GamePlayer playerById2 = WorldMgr.GetPlayerById(num4);
					if (playerById2 != null && playerById2.PlayerCharacter.masterID == 0 && AcademyMgr.CheckCanApp(playerById2.PlayerCharacter.Grade))
					{
						AcademyMgr.AddRequest(new AcademyRequestInfo
						{
							SenderID = client.Player.PlayerId,
							ReceiderID = num4,
							Type = 0,
							CreateTime = DateTime.Now
						});
						GSPacketIn gSPacketIn = new GSPacketIn(141);
						gSPacketIn.WriteByte(5);
						gSPacketIn.WriteInt(client.Player.PlayerId);
						gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
						gSPacketIn.WriteString(str);
						playerById2.SendTCP(gSPacketIn);
					}
					else
					{
						client.Player.SendMessage($"Người chơi này không online.");
					}
				}
				else
				{
					client.Player.SendMessage($"Bạn bị giới hạn do trước đó đã từ bỏ đệ tử hoặc sư phụ. Vui lòng thử lại sau {checkDate(client.Player.PlayerCharacter.freezesDate)} giờ nữa.");
				}
				break;
			}
			case 6:
			{
				int num7 = packet.ReadInt();
				AcademyRequestInfo request3 = AcademyMgr.GetRequest(num7, client.Player.PlayerId);
				if (request3 != null && request3.Type == 1)
				{
					AcademyMgr.RemoveRequest(request3);
					if (client.Player.PlayerCharacter.freezesDate <= DateTime.Now)
					{
						if (client.Player.PlayerCharacter.apprenticeshipState < AcademyMgr.MASTER_FULL_STATE && AcademyMgr.CheckCanMaster(client.Player.PlayerCharacter.Grade))
						{
							GamePlayer playerById4 = WorldMgr.GetPlayerById(num7);
							if (playerById4 != null && AcademyMgr.CheckCanApp(playerById4.PlayerCharacter.Grade))
							{
								if (AcademyMgr.AddApprentice(client.Player, playerById4))
								{
									playerById4.Out.SendAcademySystemNotice($"[{client.Player.PlayerCharacter.NickName}] đa\u0303 châ\u0301p nhâ\u0323n ba\u0323n la\u0300m sư phu\u0323", isAlert: true);
									client.Player.SendMailToUser(new PlayerBussiness(), $"Xin chu\u0301c mư\u0300ng ba\u0323n co\u0301 mô\u0323t đê\u0323 tư\u0309. Khi sư phu\u0323 đa\u0323t câ\u0301p 10/15/18 se\u0303 nhâ\u0323n đươ\u0323c rương ba\u0309o vâ\u0323t cu\u0309a câ\u0301p tương ư\u0301ng. Bên trong rương co\u0301 râ\u0301t nhiê\u0300u thư\u0301 hay ho như Đa\u0301 cươ\u0300ng ho\u0301a, tiê\u0300n va\u0300ng, điê\u0309m kinh nghiê\u0323m!", $"Thông ba\u0301o khen thươ\u0309ng sư đô\u0300!", eMailType.ItemOverdue);
									client.Player.SendMessage($"[{playerById4.PlayerCharacter.NickName}] đa\u0303 châ\u0301p nhâ\u0323n la\u0300m đô\u0300 đê\u0323 cu\u0309a ba\u0323n");
								}
								else
								{
									client.Player.SendMessage($"Thâ\u0323t tiê\u0301c, đô\u0301i phương đa\u0303 co\u0301 sư phu\u0323 ha\u0303y nhanh hơn va\u0300o lâ\u0300n sau");
								}
							}
							else
							{
								client.Player.SendMessage($"Đô\u0301i phương không trư\u0323c tuyê\u0301n, vui lo\u0300ng đơ\u0323i hoă\u0323c thư\u0309 la\u0323i sau!");
							}
						}
						else
						{
							client.Player.SendMessage(LanguageMgr.GetTranslation("Thâ\u0323t tiê\u0301c, đô\u0301i phương đa\u0303 la\u0300 bâ\u0323c thâ\u0300y ha\u0303y thư\u0309 la\u0323i va\u0300o lâ\u0300n sau!"));
						}
					}
					else
					{
						client.Player.SendMessage($"Bạn bị giới hạn do trước đó đã từ bỏ đệ tử hoặc sư phụ. Vui lòng thử lại sau {checkDate(client.Player.PlayerCharacter.freezesDate)} giờ nữa.");
					}
				}
				else
				{
					client.Player.SendMessage($"Sô\u0309 đăng ky\u0301 thiê\u0301u hoă\u0323c đa\u0303 bi\u0323 xo\u0301a.");
				}
				break;
			}
			case 7:
			{
				int num3 = packet.ReadInt();
				AcademyRequestInfo request = AcademyMgr.GetRequest(num3, client.Player.PlayerId);
				if (request != null && request.Type == 0)
				{
					AcademyMgr.RemoveRequest(request);
					if (client.Player.PlayerCharacter.freezesDate <= DateTime.Now)
					{
						if (client.Player.PlayerCharacter.masterID == 0 && AcademyMgr.CheckCanApp(client.Player.PlayerCharacter.Grade))
						{
							GamePlayer playerById = WorldMgr.GetPlayerById(num3);
							if (playerById != null && playerById.PlayerCharacter.Grade >= client.Player.PlayerCharacter.Grade + AcademyMgr.LEVEL_GAP && AcademyMgr.CheckCanMaster(playerById.PlayerCharacter.Grade))
							{
								if (AcademyMgr.AddApprentice(playerById, client.Player))
								{
									playerById.Out.SendAcademySystemNotice(LanguageMgr.GetTranslation("Game.Server.AppSystem.ApprenticeConfirm", client.Player.PlayerCharacter.NickName), isAlert: true);
									playerById.SendMailToUser(new PlayerBussiness(), LanguageMgr.GetTranslation("Game.Server.AppSystem.TakeApprenticeMail.Content"), LanguageMgr.GetTranslation("Game.Server.AppSystem.TakeApprenticeMail.Title"), eMailType.ItemOverdue);
									client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.AppSystem.MasterConfirm", playerById.PlayerCharacter.NickName));
								}
								else
								{
									client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.AppSystem.AlreadlyHasRelationship.Apprentice"));
								}
							}
							else
							{
								client.Player.SendMessage(LanguageMgr.GetTranslation("LoginServerConnector.HandleSysMess.Msg2"));
							}
						}
						else
						{
							client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.AppSystem.BeApprentice.Failed"));
						}
					}
					else
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.AppSystem.BeApprentice.Frozen", checkDate(client.Player.PlayerCharacter.freezesDate)));
					}
				}
				else
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.AppSystem.AppClub.RemoveInfo.RecordNotFound"));
				}
				break;
			}
			case 8:
			{
				int num8 = packet.ReadInt();
				AcademyRequestInfo request4 = AcademyMgr.GetRequest(num8, client.Player.PlayerId);
				if (request4 != null && request4.Type == 1)
				{
					AcademyMgr.RemoveRequest(request4);
					WorldMgr.GetPlayerById(num8)?.Out.SendAcademySystemNotice(LanguageMgr.GetTranslation("Game.Server.AppSystem.MasterRefuse", client.Player.PlayerCharacter.NickName), isAlert: false);
				}
				break;
			}
			case 9:
			{
				int num6 = packet.ReadInt();
				AcademyRequestInfo request2 = AcademyMgr.GetRequest(num6, client.Player.PlayerId);
				if (request2 != null && request2.Type == 0)
				{
					AcademyMgr.RemoveRequest(request2);
					WorldMgr.GetPlayerById(num6)?.Out.SendAcademySystemNotice(LanguageMgr.GetTranslation("Game.Server.AppSystem.ApprenticeRefuse", client.Player.PlayerCharacter.NickName), isAlert: false);
				}
				break;
			}
			case 12:
			{
				int num2 = packet.ReadInt();
				if (client.Player.RemoveGold(10000) > 0)
				{
					if (client.Player.PlayerCharacter.masterID == num2 && AcademyMgr.FireMaster(client.Player, isComplete: false))
					{
						client.Player.PlayerCharacter.freezesDate = DateTime.Now.AddHours(GameProperties.AcademyApprenticeFreezeHours);
						using (PlayerBussiness playerBussiness2 = new PlayerBussiness())
						{
							playerBussiness2.UpdateAcademyPlayer(client.Player.PlayerCharacter);
						}
						client.Player.Out.SendAcademyAppState(client.Player.PlayerCharacter, num2);
					}
					else
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.AppSystem.BreakApprentice.FireApprenticeCD"));
					}
				}
				else
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.AppSystem.BreakApprentice.NotEnoughGold"));
				}
				break;
			}
			case 13:
			{
				int num = packet.ReadInt();
				if (client.Player.RemoveGold(20000) > 0)
				{
					if (client.Player.PlayerCharacter.apprenticeshipState >= AcademyMgr.MASTER_STATE && AcademyMgr.FireApprentice(client.Player, num, isSilent: false))
					{
						client.Player.PlayerCharacter.freezesDate = DateTime.Now.AddHours(GameProperties.AcademyMasterFreezeHours);
						using (PlayerBussiness playerBussiness = new PlayerBussiness())
						{
							playerBussiness.UpdateAcademyPlayer(client.Player.PlayerCharacter);
						}
						client.Player.Out.SendAcademyAppState(client.Player.PlayerCharacter, num);
					}
					else
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.AppSystem.BreakApprentice.FireApprenticeCD"));
					}
				}
				else
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.AppSystem.BreakApprentice.NotEnoughGold"));
				}
				break;
			}
			}
			return 0;
        }

        private int checkDate(DateTime dateTime)
        {
			if (dateTime > DateTime.Now)
			{
				return (int)Math.Ceiling((dateTime - DateTime.Now).TotalHours);
			}
			return 0;
        }
    }
}
