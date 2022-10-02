using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.GET_MAIL_ATTACHMENT, "获取邮件到背包")]
	public class MailGetAttachHandler : IPacketHandler
    {
		public bool GetAnnex(string value, GamePlayer player, ref string msg, ref bool result, ref eMessageType eMsg)
		{
			int gid = int.Parse(value);
			using (PlayerBussiness db = new PlayerBussiness())
			{
				ItemInfo goods = db.GetUserItemSingle(gid);
				if (goods != null)
				{
					if (player.AddTemplate(goods))
					{
						eMsg = eMessageType.GM_NOTICE;
						return true;
					}
				}
			}
			return false;
		}


		public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int id = packet.ReadInt();
			byte type = packet.ReadByte();
			List<int> types = new List<int>();
			List<string> annex = new List<string>();
			int money = 0;
			int gold = 0;
			int giftToken = 0;
			string msg = "";
			eMessageType eMsg = eMessageType.GM_NOTICE;
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GET_MAIL_ATTACHMENT, client.Player.PlayerCharacter.ID);
			using (PlayerBussiness db = new PlayerBussiness())
			{
				client.Player.LastAttachMail = DateTime.Now;
				MailInfo mes = db.GetMailSingle(client.Player.PlayerCharacter.ID, id);
				if (mes != null)
				{
					bool result = true;
					int oldMoney = mes.Money;
					// Chức năng của BAOLT - Lâm đừng copaste nha
					if (mes.Type > 100 && oldMoney > 0 && client.Player.isPlayerWarrior())
					{
						client.Out.SendMessage(eMessageType.GM_NOTICE, "Tài khoản không có quyền thực hiện chức năng này.");
						return 0;
					}
					if (mes.Type > 100 && !client.Player.MoneyDirect(oldMoney, IsAntiMult: true, true))
					{
						return 0;
					}
					GamePlayer player = WorldMgr.GetPlayerById(mes.ReceiverID);
					if (!mes.IsRead)
					{
						mes.IsRead = true;
						mes.ValidDate = 72;
						mes.SendTime = DateTime.Now;
					}
					if (result && (type == 0 || type == 1) && !string.IsNullOrEmpty(mes.Annex1))
					{
						types.Add(1);
						annex.Add(mes.Annex1);
						mes.Annex1 = null;
					}
					if (result && (type == 0 || type == 2) && !string.IsNullOrEmpty(mes.Annex2))
					{
						types.Add(2);
						annex.Add(mes.Annex2);
						mes.Annex2 = null;
					}
					if (result && (type == 0 || type == 3) && !string.IsNullOrEmpty(mes.Annex3))
					{
						types.Add(3);
						annex.Add(mes.Annex3);
						mes.Annex3 = null;
					}
					if (result && (type == 0 || type == 4) && !string.IsNullOrEmpty(mes.Annex4))
					{
						types.Add(4);
						annex.Add(mes.Annex4);
						mes.Annex4 = null;
					}
					if (result && (type == 0 || type == 5) && !string.IsNullOrEmpty(mes.Annex5))
					{
						types.Add(5);
						annex.Add(mes.Annex5);
						mes.Annex5 = null;
					}
					if ((type == 0 || type == 6) && mes.Gold > 0)
					{
						types.Add(6);
						gold = mes.Gold;
						mes.Gold = 0;
					}
					if ((type == 0 || type == 7) && mes.Type < 100 && mes.Money > 0)
					{
						types.Add(7);
						money = mes.Money;
						mes.Money = 0;
					}
					if (mes.Type > 100 && mes.GiftToken > 0)
					{
						types.Add(8);
						giftToken = mes.GiftToken;
						mes.GiftToken = 0;
					}
					if (mes.Type > 100 && mes.Money > 0)
					{
						mes.Money = 0;
						msg = LanguageMgr.GetTranslation("MailGetAttachHandler.Deduct") + (string.IsNullOrEmpty(msg) ? LanguageMgr.GetTranslation("MailGetAttachHandler.Success") : msg);
					}
					if (db.UpdateMail(mes, oldMoney))
					{
						if (mes.Type > 100 && oldMoney > 0)
						{
							client.Out.SendMailResponse(mes.SenderID, eMailRespose.Receiver);
							client.Out.SendMailResponse(mes.ReceiverID, eMailRespose.Send);
						}
						player.AddMoney(money);
						player.AddGold(gold);
						player.AddGiftToken(giftToken);
						foreach (string item in annex)
						{
							GetAnnex(item, client.Player, ref msg, ref result, ref eMsg);
						}
					}
					pkg.WriteInt(id);
					pkg.WriteInt(types.Count);
					foreach (int item in types)
					{
						pkg.WriteInt(item);
					}
					client.Out.SendTCP(pkg);
					client.Out.SendMessage(eMsg, string.IsNullOrEmpty(msg) ? LanguageMgr.GetTranslation("MailGetAttachHandler.Success") : msg);
				}
				else
				{
					client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("MailGetAttachHandler.Falied"));
				}
			}
			return 0;
        }
    }
}
