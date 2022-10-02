using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler(53, "获取箱子")]
	public class UserGetBoxHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			GamePlayer player = client.Player;
			int num = packet.ReadInt();
			LoadUserBoxInfo loadUserBoxInfo = null;
			if (num == 0)
			{
				int num2 = packet.ReadInt();
				int num3 = (int)DateTime.Now.Subtract(player.BoxBeginTime).TotalMinutes;
				loadUserBoxInfo = UserBoxMgr.FindTemplateByCondition(0, player.PlayerCharacter.Grade, player.PlayerCharacter.BoxProgression);
				if (loadUserBoxInfo != null && num3 >= num2 && loadUserBoxInfo.Condition == num2)
				{
					using PlayerBussiness playerBussiness = new PlayerBussiness();
					playerBussiness.UpdateBoxProgression(player.PlayerCharacter.ID, player.PlayerCharacter.BoxProgression, player.PlayerCharacter.GetBoxLevel, player.PlayerCharacter.AddGPLastDate, DateTime.Now, num2);
					player.PlayerCharacter.AlreadyGetBox = num2;
					player.PlayerCharacter.BoxGetDate = DateTime.Now;
				}
				return 0;
			}
			int num4 = packet.ReadInt();
			GSPacketIn gSPacketIn = packet.Clone();
			gSPacketIn.ClearContext();
			bool flag = false;
			bool val = true;
			if (num4 == 0)
			{
				int num5 = (int)DateTime.Now.Subtract(player.BoxBeginTime).TotalMinutes;
				loadUserBoxInfo = UserBoxMgr.FindTemplateByCondition(0, player.PlayerCharacter.Grade, player.PlayerCharacter.BoxProgression);
				if (loadUserBoxInfo != null && (num5 >= loadUserBoxInfo.Condition || player.PlayerCharacter.AlreadyGetBox == loadUserBoxInfo.Condition))
				{
					using PlayerBussiness playerBussiness2 = new PlayerBussiness();
					if (playerBussiness2.UpdateBoxProgression(player.PlayerCharacter.ID, loadUserBoxInfo.Condition, player.PlayerCharacter.GetBoxLevel, player.PlayerCharacter.AddGPLastDate, DateTime.Now.Date, 0))
					{
						player.PlayerCharacter.BoxProgression = loadUserBoxInfo.Condition;
						player.PlayerCharacter.BoxGetDate = DateTime.Now.Date;
						player.PlayerCharacter.AlreadyGetBox = 0;
						flag = true;
					}
				}
			}
			else
			{
				loadUserBoxInfo = UserBoxMgr.FindTemplateByCondition(1, player.PlayerCharacter.GetBoxLevel, Convert.ToInt32(player.PlayerCharacter.Sex));
				if (loadUserBoxInfo != null && player.PlayerCharacter.Grade >= loadUserBoxInfo.Level)
				{
					using PlayerBussiness playerBussiness3 = new PlayerBussiness();
					if (playerBussiness3.UpdateBoxProgression(player.PlayerCharacter.ID, player.PlayerCharacter.BoxProgression, loadUserBoxInfo.Level, player.PlayerCharacter.AddGPLastDate, player.PlayerCharacter.BoxGetDate, 0))
					{
						player.PlayerCharacter.GetBoxLevel = loadUserBoxInfo.Level;
						flag = true;
					}
				}
			}
			if (flag)
			{
				if (loadUserBoxInfo != null)
				{
					List<ItemInfo> list = new List<ItemInfo>();
					List<ItemInfo> list2 = new List<ItemInfo>();
					int gold = 0;
					int point = 0;
					int giftToken = 0;
					int exp = 0;
					int honor = 0;
					ItemBoxMgr.CreateItemBox(Convert.ToInt32(loadUserBoxInfo.TemplateID), list2, ref gold, ref point, ref giftToken, ref exp, ref honor);
					if (gold > 0)
					{
						player.AddGold(gold);
					}
					if (point > 0)
					{
						player.AddMoney(point);
					}
					if (giftToken > 0)
					{
						player.AddGiftToken(giftToken);
					}
					if (exp > 0)
					{
						player.AddGP(exp, false);
					}
					if (honor > 0)
					{
						player.AddHonor(honor);
					}
					foreach (ItemInfo item in list2)
					{
						item.RemoveType = 120;
						if (!player.AddItem(item))
						{
							list.Add(item);
						}
					}
					if (num4 == 0)
					{
						player.BoxBeginTime = DateTime.Now;
						loadUserBoxInfo = UserBoxMgr.FindTemplateByCondition(0, player.PlayerCharacter.Grade, player.PlayerCharacter.BoxProgression);
						if (loadUserBoxInfo != null)
						{
							player.Out.SendMessage(eMessageType.GM_NOTICE, $"Nhâ\u0323n qua\u0300 tư\u0300 rương thơ\u0300i gian {loadUserBoxInfo.Condition} phu\u0301t.");
						}
						else
						{
							player.Out.SendMessage(eMessageType.GM_NOTICE, $"Ba\u0323n đa\u0303 nhâ\u0323n hê\u0301t cu\u0309a nga\u0300y hôm nay");
						}
					}
					else
					{
						loadUserBoxInfo = UserBoxMgr.FindTemplateByCondition(1, player.PlayerCharacter.GetBoxLevel, Convert.ToInt32(player.PlayerCharacter.Sex));
						if (loadUserBoxInfo != null)
						{
							player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("UserGetTimeBoxHandler.level", loadUserBoxInfo.Level));
						}
						else
						{
							player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("UserGetTimeBoxHandler.over"));
						}
					}
					if (list.Count > 0 && player.SendItemsToMail(list, LanguageMgr.GetTranslation("UserGetTimeBoxHandler.mail"), LanguageMgr.GetTranslation("UserGetTimeBoxHandler.title"), eMailType.OpenUpArk))
					{
						player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("UserGetTimeBixHandler.full"));
						val = true;
						player.Out.SendMailResponse(player.PlayerCharacter.ID, eMailRespose.Receiver);
					}
				}
				else
				{
					val = false;
				}
			}
			else
			{
				player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("UserGetTimeBoxHandler.fail"));
			}
			if (num4 == 0)
			{
				gSPacketIn.WriteBoolean(val);
				gSPacketIn.WriteInt(player.PlayerCharacter.BoxProgression);
				player.SendTCP(gSPacketIn);
			}
			return 0;
        }
    }
}
