using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Text;

namespace Game.Server.Packets.Client
{
    [PacketHandler(13, "场景用户离开")]
    public class DailyAwardHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int num = packet.ReadInt();
            int point = 0;
            int gold = 0;
            int giftToken = 0;
            int medal = 0;
            int exp = 0;
            StringBuilder stringBuilder = new StringBuilder();
            List<ItemInfo> list = new List<ItemInfo>();
            string text = "";
            switch (num)
            {
                case 0:
                    if (AwardMgr.AddDailyAward(client.Player))
                    {
                        using PlayerBussiness playerBussiness3 = new PlayerBussiness();
                        if (playerBussiness3.UpdatePlayerLastAward(client.Player.PlayerCharacter.ID, num))
                        {
                            stringBuilder.Append(LanguageMgr.GetTranslation("GameUserDailyAward.Success"));
                        }
                        else
                        {
                            stringBuilder.Append(LanguageMgr.GetTranslation("GameUserDailyAward.Fail"));
                        }
                    }
                    else
                    {
                        stringBuilder.Append(LanguageMgr.GetTranslation("GameUserDailyAward.Fail1"));
                    }
                    break;
                case 2:
                    {
                        if (DateTime.Now.Date == client.Player.PlayerCharacter.LastGetEgg.Date)
                        {
                            stringBuilder.Append($"Bạn đã nhận 1 lần hôm nay!");
                            break;
                        }
                        AwardMgr.AddEggAward(client.Player);
                        ItemInfo cloneItem = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(112059), 1, 113);
                        client.Player.PropBag.AddTemplate(cloneItem, 1);
                        stringBuilder.Append(LanguageMgr.GetTranslation("GameServer.DailyEggReceive.Success"));
                        string translation = LanguageMgr.GetTranslation("GameServer.DailyEgg.Notice.Msg", client.Player.PlayerCharacter.NickName, 112059);
                        //GSPacketIn packet2 = WorldMgr.SendSysNotice(eMessageType.ChatNormal, translation, 0, 112059, null);
                        //GameServer.Instance.LoginServer.SendPacket(packet2);
                        break;
                    }
                case 3:
                    if (client.Player.PlayerCharacter.CanTakeVipReward)
                    {
                        int vIPLevel = client.Player.PlayerCharacter.VIPLevel;
                        client.Player.LastVIPPackTime();
                        if (!ItemBoxMgr.CreateItemBox(ItemMgr.FindItemTemplate(ItemMgr.FindItemBoxTypeAndLv(2, vIPLevel).TemplateID).TemplateID, list, ref gold, ref point, ref giftToken, ref medal, ref exp))
                        {
                            client.Player.SendMessage(LanguageMgr.GetTranslation("Error.ChangeChannel"));
                            return 0;
                        }
                        using PlayerBussiness playerBussiness2 = new PlayerBussiness();
                        playerBussiness2.UpdateLastVIPPackTime(client.Player.PlayerCharacter.ID);
                    }
                    else
                    {
                        stringBuilder.Append("Bạn đã nhận được phần thưởng hôm nay!");
                    }
                    break;
                case 5:
                    {
                        using (PlayerBussiness playerBussiness = new PlayerBussiness())
                        {
                            DailyLogListInfo dailyLogListInfo = playerBussiness.GetDailyLogListSingle(client.Player.PlayerCharacter.ID);
                            if (dailyLogListInfo == null)
                            {
                                dailyLogListInfo = new DailyLogListInfo
                                {
                                    UserID = client.Player.PlayerCharacter.ID,
                                    DayLog = "",
                                    UserAwardLog = 0,
                                    LastDate = DateTime.Now
                                };
                            }
                            string dayLog = dailyLogListInfo.DayLog;
                            dayLog.Split(',');
                            if (string.IsNullOrEmpty(dayLog))
                            {
                                dayLog = "True";
                                dailyLogListInfo.UserAwardLog = 0;
                            }
                            else
                            {
                                dayLog += ",True";
                            }
                            dailyLogListInfo.DayLog = dayLog;
                            dailyLogListInfo.UserAwardLog++;
                            playerBussiness.UpdateDailyLogList(dailyLogListInfo);
                        }
                        break;
                    }
            }
            if (point != 0)
            {
                stringBuilder.Append(point + LanguageMgr.GetTranslation("OpenUpArkHandler.Money"));
                client.Player.AddMoney(point);
            }
            if (gold != 0)
            {
                stringBuilder.Append(gold + LanguageMgr.GetTranslation("OpenUpArkHandler.Gold"));
                client.Player.AddGold(gold);
            }
            if (giftToken != 0)
            {
                stringBuilder.Append(giftToken + LanguageMgr.GetTranslation("OpenUpArkHandler.GiftToken"));
                client.Player.AddGiftToken(giftToken);
            }
            if (medal != 0)
            {
                stringBuilder.Append(medal + LanguageMgr.GetTranslation("OpenUpArkHandler.Medal"));
                client.Player.AddMedal(medal);
            }
            StringBuilder stringBuilder2 = new StringBuilder();
            foreach (ItemInfo item in list)
            {
                stringBuilder2.Append(item.Template.Name + "x" + item.Count + ",");
                if (!client.Player.AddTemplate(item, item.Template.BagType, item.Count, eGameView.RouletteTypeGet))
                {
                    using PlayerBussiness playerBussiness4 = new PlayerBussiness();
                    item.UserID = 0;
                    playerBussiness4.AddGoods(item);
                    MailInfo mail = new MailInfo
                    {
                        Annex1 = item.ItemID.ToString(),
                        Content = LanguageMgr.GetTranslation("OpenUpArkHandler.Content1") + item.Template.Name + LanguageMgr.GetTranslation("OpenUpArkHandler.Content2"),
                        Gold = 0,
                        Money = 0,
                        Receiver = client.Player.PlayerCharacter.NickName,
                        ReceiverID = client.Player.PlayerCharacter.ID,
                        Sender = "Admin",
                        SenderID = 1,
                        Title = LanguageMgr.GetTranslation("OpenUpArkHandler.Title") + item.Template.Name + "]",
                        Type = 12
                    };
                    playerBussiness4.SendMail(mail);
                    text = LanguageMgr.GetTranslation("OpenUpArkHandler.Mail");
                }
            }
            if (stringBuilder2.Length > 0)
            {
                stringBuilder2.Remove(stringBuilder2.Length - 1, 1);
                string[] array = stringBuilder2.ToString().Split(',');
                for (int i = 0; i < array.Length; i++)
                {
                    int num2 = 1;
                    for (int j = i + 1; j < array.Length; j++)
                    {
                        if (array[i].Contains(array[j]) && array[j].Length == array[i].Length)
                        {
                            num2++;
                            array[j] = j.ToString();
                        }
                    }
                    if (num2 > 1)
                    {
                        array[i] = array[i].Remove(array[i].Length - 1, 1);
                        string[] array2;
                        IntPtr value;
                        (array2 = array)[(int)(value = (IntPtr)i)] = array2[(int)value] + num2;
                    }
                    if (array[i] != i.ToString())
                    {
                        string[] array3;
                        IntPtr value2;
                        (array3 = array)[(int)(value2 = (IntPtr)i)] = array3[(int)value2] + ",";
                        stringBuilder.Append(array[i]);
                    }
                }
            }
            if (stringBuilder.Length - 1 > 0)
            {
                stringBuilder.Remove(stringBuilder.Length - 1, 1);
                stringBuilder.Append(".");
            }
            client.Out.SendMessage(eMessageType.GM_NOTICE, text + stringBuilder.ToString());
            if (!string.IsNullOrEmpty(text))
            {
                client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
            }
            return 2;
        }
    }
}
