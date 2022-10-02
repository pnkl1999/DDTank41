using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.GameObjects;
using Game.Server.Packets;
//using Game.Server.Packets.Package;
using Game.Server.Rooms;
using SqlDataProvider.Data;
using Bussiness.Managers;
using Bussiness;
using Newtonsoft.Json;
//using Game.Server.LotteryTicket;
using Bussiness.Protocol;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.ACTIVITY_PACKAGE, "场景用户离开")]
    public class ActivityPackageHandler : IPacketHandler
    {
        private readonly int[] m_gradeList = new int[] { 10, 20, 30, 40, 45, 50, 55, 60, 65 };
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int cmd = packet.ReadInt();
            int ID = client.Player.PlayerCharacter.ID;
            ActiveSystemInfo ActivityPackage = client.Player.Actives.Info;
            switch (cmd)
            {
                #region GROWTHPACKAGE
                //case (int)GrowthPackageType.GROWTHPACKAGE:
                //    {
                //        if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
                //        {
                //            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                //            return 0;
                //        }
                //        if (DateTime.Compare(client.Player.LastOpenGrowthPackage.AddMilliseconds(500), DateTime.Now) > 0)
                //        {
                //            client.Player.Out.SendGrowthPackageUpdate(client.Player.PlayerCharacter.ID, ActivityPackage.AvailTime);
                //            return 0;
                //        }
                //        int index = ActivityPackage.AvailTime;
                //        int needMoney = GameProperties.PromotePackagePrice;
                //        string msg = LanguageMgr.GetTranslation("UserBuyItemHandler.Success");
                //        List<ItemInfo> awards = new List<ItemInfo>();
                //        int sex = client.Player.PlayerCharacter.Sex == true ? 1 : 2;
                //        int type = packet.ReadInt();
                //        switch (type)
                //        {
                //            case (int)GrowthPackageType.GROWTHPACKAGE_OPEN:
                //                {
                //                    if (client.Player.MoneyDirect(needMoney))
                //                    {
                //                        if (CanGetAward(client.Player.PlayerCharacter.Grade, index))
                //                        {
                //                            List<ActivitySystemItemInfo> lists = ActiveMgr.GetGrowthPackage(index);
                //                            foreach (ActivitySystemItemInfo info in lists)
                //                            {
                //                                ItemTemplateInfo temp = ItemMgr.FindItemTemplate(info.TemplateID);
                //                                if (temp != null && (temp.NeedSex == 0 || temp.NeedSex == sex))
                //                                {
                //                                    ItemInfo item = ItemInfo.CreateFromTemplate(temp, info.Count, (int)eItemAddType.Buy);
                //                                    item.Count = info.Count;
                //                                    item.IsBinds = info.IsBind;
                //                                    item.ValidDate = info.ValidDate;
                //                                    item.StrengthenLevel = info.StrengthLevel;
                //                                    item.AttackCompose = info.AttackCompose;
                //                                    item.DefendCompose = info.DefendCompose;
                //                                    item.AgilityCompose = info.AgilityCompose;
                //                                    item.LuckCompose = info.LuckCompose;
                //                                    awards.Add(item);
                //                                }
                //                            }
                //                        }
                //                        else
                //                        {
                //                            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ActivityPackageHandler.Msg1"));
                //                            return 0;
                //                        }
                //                    }
                //                    break;
                //                }
                //            case (int)GrowthPackageType.GROWTHPACKAGE_UPDATEDATA:
                //                {
                //                    if (CanGetAward(client.Player.PlayerCharacter.Grade, index))
                //                    {
                //                        msg = LanguageMgr.GetTranslation("ActivityPackageHandler.Msg3");
                //                        List<ActivitySystemItemInfo> lists = ActiveMgr.GetGrowthPackage(index);
                //                        foreach (ActivitySystemItemInfo info in lists)
                //                        {
                //                            ItemTemplateInfo temp = ItemMgr.FindItemTemplate(info.TemplateID);
                //                            if (temp != null && (temp.NeedSex == 0 || temp.NeedSex == sex))
                //                            {
                //                                ItemInfo item = ItemInfo.CreateFromTemplate(temp, info.Count, (int)eItemAddType.Buy);
                //                                item.Count = info.Count;
                //                                item.IsBinds = info.IsBind;
                //                                item.ValidDate = info.ValidDate;
                //                                item.StrengthenLevel = info.StrengthLevel;
                //                                item.AttackCompose = info.AttackCompose;
                //                                item.DefendCompose = info.DefendCompose;
                //                                item.AgilityCompose = info.AgilityCompose;
                //                                item.LuckCompose = info.LuckCompose;
                //                                awards.Add(item);
                //                            }
                //                        }
                //                    }
                //                    else
                //                    {
                //                        client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ActivityPackageHandler.Msg1"));
                //                        return 0;
                //                    }
                //                }
                //                break;
                //            default:
                //                Console.WriteLine("GrowthPackageType.{0}", (GrowthPackageType)type);
                //                break;
                //        }
                //        if (awards.Count > 0)
                //        {
                //            ActivityPackage.AvailTime++;
                //            WorldEventMgr.SendItemsToMails(awards, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, client.Player.ZoneId, string.Format("Qùa trưởng thành cấp {0} ", m_gradeList[index]));
                //        }
                //        else
                //        {
                //            msg = LanguageMgr.GetTranslation("ActivityPackageHandler.Msg2");
                //        }
                //        client.Player.Out.SendGrowthPackageUpdate(client.Player.PlayerCharacter.ID, ActivityPackage.AvailTime);
                //        client.Out.SendMessage(eMessageType.Normal, msg);
                //        client.Player.LastOpenGrowthPackage = DateTime.Now;
                //        break;
                //    }
                #endregion
                case (int)ChickActivationType.CHICKACTIVATION:
                    {
                        UserChickActiveInfo chickInfo = client.Player.Actives.GetChickActiveData();
                        int[] gradeVal = { 1, 2, 4, 8, 16, 32, 64, 128, 256, 512 };
                        int[] levelNeed = { 5, 10, 25, 30, 40, 45, 48, 50, 55, 60 };
                        int type = packet.ReadInt();
                        GSPacketIn pkg = new GSPacketIn((byte)ePackageType.ACTIVITY_PACKAGE, client.Player.PlayerCharacter.ID);
                        pkg.WriteInt((int)ChickActivationType.CHICKACTIVATION);
                        switch (type)
                        {
                            case (int)ChickActivationType.CHICKACTIVATION_QUERY:
                                {
                                    if (chickInfo != null)
                                    {
                                        pkg.WriteInt((int)ChickActivationType.CHICKACTIVATION_LOGIN);
                                        pkg.WriteInt(chickInfo.IsKeyOpened);
                                        pkg.WriteInt(1);
                                        pkg.WriteDateTime(chickInfo.KeyOpenedTime);
                                        pkg.WriteInt(chickInfo.KeyOpenedType);

                                        pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Monday) ? 0 : 1);
                                        pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Tuesday) ? 0 : 1);
                                        pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Wednesday) ? 0 : 1);
                                        pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Thursday) ? 0 : 1);
                                        pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Friday) ? 0 : 1);
                                        pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Saturday) ? 0 : 1);
                                        pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Sunday) ? 0 : 1);
                                        pkg.WriteInt((chickInfo.AfterThreeDays.Day < DateTime.Now.Day && chickInfo.OnThreeDay(DateTime.Now)) ? 0 : 1);
                                        pkg.WriteInt((chickInfo.AfterThreeDays.Day < DateTime.Now.Day && chickInfo.OnThreeDay(DateTime.Now)) ? 0 : 1);
                                        pkg.WriteInt((chickInfo.AfterThreeDays.Day < DateTime.Now.Day && chickInfo.OnThreeDay(DateTime.Now)) ? 0 : 1);
                                        pkg.WriteInt((chickInfo.Weekly < chickInfo.StartOfWeek(DateTime.Now, DayOfWeek.Saturday) && DateTime.Now.DayOfWeek == DayOfWeek.Saturday) ? 0 : 1);
                                        pkg.WriteInt(chickInfo.CurrentLvAward);
                                        client.Player.SendTCP(pkg);
                                    }
                                }
                                break;
                            case (int)ChickActivationType.CHICKACTIVATION_OPENKEY:
                                string codeEnter = packet.ReadString();
                                if (codeEnter.Length == 14 && chickInfo.IsKeyOpened == 0)
                                {
                                    // check code
                                    using (PlayerBussiness pb = new PlayerBussiness())
                                    {
                                        int result = pb.ActiveChickCode(client.Player.PlayerCharacter.ID, codeEnter);
                                        switch (result)
                                        {
                                            case 0:
                                                // complete
                                                chickInfo.Active((client.Player.PlayerCharacter.Grade > 15) ? 2 : 1);
                                                client.Player.Actives.SaveChickActiveData(chickInfo);
                                                client.Player.Actives.SendUpdateChickActivation();
                                                client.Player.SendMessage(LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.Success"));
                                                break;
                                            case 1:
                                                client.Player.SendMessage(LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.NotExit"));
                                                break;
                                            case 2:
                                                client.Player.SendMessage(LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.IsUsed"));
                                                break;
                                        }
                                    }
                                }
                                break;
                            case (int)ChickActivationType.CHICKACTIVATION_GETAWARD:
                                int AwardType = packet.ReadInt();
                                int AwardIndex = packet.ReadInt();
                                if (chickInfo.IsKeyOpened == 1 && chickInfo.KeyOpenedTime.AddDays(60).Date >= DateTime.Now.Date)
                                {
                                    List<ActivitySystemItemInfo> lists = null;
                                    int mySex = client.Player.PlayerCharacter.Sex == true ? 1 : 2;
                                    string title = "";
                                    string msg = "";
                                    if (AwardType <= 7 && chickInfo.EveryDay.Day < DateTime.Now.Day)//EveryDay
                                    {
                                        chickInfo.EveryDay = DateTime.Now;
                                        lists = ActiveMgr.FindChickActivePakage((chickInfo.KeyOpenedType == 2) ? 101 : 1);
                                        title = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.DaylyAward.Title");
                                        msg = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.DaylyAward.Msg");
                                    }
                                    else if (AwardType <= 10 && chickInfo.AfterThreeDays.Day < DateTime.Now.Day && chickInfo.OnThreeDay(DateTime.Now))//AfterThreeDays
                                    {
                                        chickInfo.AfterThreeDays = DateTime.Now;
                                        lists = ActiveMgr.FindChickActivePakage((chickInfo.KeyOpenedType == 2) ? 102 : 2);
                                        title = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.WeekenAward.Title");
                                        msg = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.WeekenAward.Msg");
                                    }
                                    else if (AwardType == 11 && chickInfo.Weekly < chickInfo.StartOfWeek(DateTime.Now, DayOfWeek.Saturday) && DateTime.Now.DayOfWeek == DayOfWeek.Saturday)//Weekly
                                    {
                                        chickInfo.Weekly = chickInfo.StartOfWeek(DateTime.Now, DayOfWeek.Saturday);
                                        lists = ActiveMgr.FindChickActivePakage((chickInfo.KeyOpenedType == 2) ? 103 : 3);
                                        title = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.WeeklyAward.Title");
                                        msg = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.WeeklyAward.Msg");
                                    }
                                    else if (AwardType == 12 && gradeVal[AwardIndex - 1] > chickInfo.CurrentLvAward && client.Player.PlayerCharacter.Grade >= levelNeed[AwardIndex - 1] && chickInfo.KeyOpenedType == 1)
                                    {
                                        int[] qualityArr = { 10001, 10002, 10003, 10004, 10005, 10006, 10007, 10000, 10009, 10010 };
                                        chickInfo.CurrentLvAward = chickInfo.CurrentLvAward + gradeVal[AwardIndex - 1];
                                        lists = ActiveMgr.FindChickActivePakage(qualityArr[AwardIndex - 1]);
                                        title = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.LevelAward.Title", levelNeed[AwardIndex - 1]);
                                        msg = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.LevelAward.Msg", levelNeed[AwardIndex - 1]);
                                    }

                                    // send item
                                    if (lists != null)
                                    {
                                        List<ItemInfo> awards = new List<ItemInfo>();
                                        foreach (ActivitySystemItemInfo info in lists)
                                        {
                                            ItemTemplateInfo temp = ItemMgr.FindItemTemplate(info.TemplateID);
                                            if (temp != null && (temp.NeedSex == 0 || temp.NeedSex == mySex))
                                            {
                                                ItemInfo item = ItemInfo.CreateFromTemplate(temp, info.Count, (int)eItemAddType.Buy);
                                                item.Count = info.Count;
                                                item.IsBinds = info.IsBind;
                                                item.ValidDate = info.ValidDate;
                                                item.StrengthenLevel = info.StrengthLevel;
                                                item.AttackCompose = info.AttackCompose;
                                                item.DefendCompose = info.DefendCompose;
                                                item.AgilityCompose = info.AgilityCompose;
                                                item.LuckCompose = info.LuckCompose;
                                                awards.Add(item);
                                            }
                                        }
                                        if (awards.Count > 0)
                                        {
                                            WorldEventMgr.SendItemsToMails(awards, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, client.Player.ZoneId, null, title);
                                            client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
                                        }
                                        client.Player.Actives.SaveChickActiveData(chickInfo);
                                        client.Player.Actives.SendUpdateChickActivation();
                                        client.Out.SendMessage(eMessageType.Normal, msg);

                                    }
                                    else
                                    {
                                        client.Player.SendMessage(LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.NotFoundAward"));
                                    }
                                }
                                else
                                {
                                    client.Player.SendMessage(LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.NotActive"));
                                }
                                break;
                            default:
                                Console.WriteLine("ChickActivationType.{0}", (ChickActivationType)type);
                                break;
                        }
                    }
                    break;
                #region Orther
                //case (int)MagicHousePackageType.MAGICHOUSE:
                //    {
                //        if (client.Player.MagicHouseHandler != null)
                //            client.Player.MagicHouseHandler.ProcessData(client.Player, packet);
                //    }
                //    break;
                //case (int)ZodiacPackageType.ZODIAC:
                //    {
                //        if (client.Player.ZodiacHandler != null)
                //            client.Player.ZodiacHandler.ProcessData(client.Player, packet);
                //    }
                //    break;
                //case (int)AnotherDimensionPackageType.ANOTHERDIMENSION:
                //    {
                //        if (client.Player.AnotherDimensionHandler != null)
                //            client.Player.AnotherDimensionHandler.ProcessData(client.Player, packet);
                //    }
                //    break;
                //case (int)LoginDevicePackageType.LOGINDEVICE_PACKAGETYPE:
                //    {
                //        LoginDevicePackageType type = (LoginDevicePackageType)packet.ReadInt();
                //        switch (type)
                //        {
                //            case LoginDevicePackageType.LOGINDEVICE_UA_CHECK:
                //                {
                //                    bool isCheck = packet.ReadBoolean();
                //                    client.Player.IsLoginDevice = isCheck;
                //                    client.Out.SendLoginDeviceCheck(client.Player, client.Player.IsLoginDevice);
                //                }
                //                break;

                //            case LoginDevicePackageType.LOGINDEVICE_GET_DOWNREWARD:
                //                {
                //                    if (!client.Player.Extra.Info.loginDeviceDownAward)
                //                    {
                //                        List<ActivitySystemItemInfo> lists = ActiveMgr.FindLoginDevicePackage(1);
                //                        if (lists.Count > 0)
                //                        {
                //                            client.Player.Extra.Info.loginDeviceDownAward = true;
                //                            List<ItemInfo> awards = new List<ItemInfo>();
                //                            foreach (ActivitySystemItemInfo info in lists)
                //                            {
                //                                ItemTemplateInfo temp = ItemMgr.FindItemTemplate(info.TemplateID);
                //                                if (temp != null)
                //                                {
                //                                    ItemInfo item = ItemInfo.CreateFromTemplate(temp, info.Count, (int)eItemAddType.Buy);
                //                                    item.Count = info.Count;
                //                                    item.IsBinds = info.IsBind;
                //                                    item.ValidDate = info.ValidDate;
                //                                    item.StrengthenLevel = info.StrengthLevel;
                //                                    item.AttackCompose = info.AttackCompose;
                //                                    item.DefendCompose = info.DefendCompose;
                //                                    item.AgilityCompose = info.AgilityCompose;
                //                                    item.LuckCompose = info.LuckCompose;
                //                                    awards.Add(item);
                //                                }
                //                            }
                //                            if (awards.Count > 0)
                //                            {
                //                                WorldEventMgr.SendItemsToMails(awards, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, client.Player.ZoneId, LanguageMgr.GetTranslation("GameServer.LoginDevice.AwardTitleMail"));
                //                                client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
                //                            }
                //                            client.Out.SendLoginDeviceCheck(client.Player, client.Player.IsLoginDevice);
                //                        }
                //                    }
                //                }
                //                break;

                //            case LoginDevicePackageType.LOGINDEVICE_GET_DAILYREWARD:
                //                {
                //                    if (!client.Player.Extra.Info.loginDeviceDailyAward)
                //                    {
                //                        List<ActivitySystemItemInfo> lists = ActiveMgr.FindLoginDevicePackage(2);
                //                        if (lists.Count > 0)
                //                        {
                //                            client.Player.Extra.Info.loginDeviceDailyAward = true;
                //                            List<ItemInfo> awards = new List<ItemInfo>();
                //                            foreach (ActivitySystemItemInfo info in lists)
                //                            {
                //                                ItemTemplateInfo temp = ItemMgr.FindItemTemplate(info.TemplateID);
                //                                if (temp != null)
                //                                {
                //                                    ItemInfo item = ItemInfo.CreateFromTemplate(temp, info.Count, (int)eItemAddType.Buy);
                //                                    item.Count = info.Count;
                //                                    item.IsBinds = info.IsBind;
                //                                    item.ValidDate = info.ValidDate;
                //                                    item.StrengthenLevel = info.StrengthLevel;
                //                                    item.AttackCompose = info.AttackCompose;
                //                                    item.DefendCompose = info.DefendCompose;
                //                                    item.AgilityCompose = info.AgilityCompose;
                //                                    item.LuckCompose = info.LuckCompose;
                //                                    awards.Add(item);
                //                                }
                //                            }
                //                            if (awards.Count > 0)
                //                            {
                //                                WorldEventMgr.SendItemsToMails(awards, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, client.Player.ZoneId, LanguageMgr.GetTranslation("GameServer.LoginDevice.AwardTitleMail"));
                //                                client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
                //                            }
                //                            client.Out.SendLoginDeviceCheck(client.Player, client.Player.IsLoginDevice);
                //                        }
                //                    }
                //                }
                //                break;
                //        }
                //    }
                //    break;
                //case (int)ActiveSystemPackageType.SIGNBUFF_MESSAGE:
                //    {
                //        packet.ReadInt();
                //        int quaity = packet.ReadInt();
                //        List<ActivitySystemItemInfo> lists = ActiveMgr.FindSignBuffPackage(quaity);
                //        if (lists.Count <= 0)
                //        {
                //            client.Player.SendMessage(LanguageMgr.GetTranslation("SignBuffFightPower.NoAward"));
                //            return 0;
                //        }
                //        // check can received
                //        client.Player.Actives.SynFightPowerSign();

                //        List<int> fightPowerList = GameProperties.getProp(GameProperties.FightPowerSignData);
                //        int[] fightData = JsonConvert.DeserializeObject<int[]>(client.Player.Actives.Info.fightPowerSignData);

                //        int index = fightPowerList.IndexOf(quaity * 10000);

                //        if (index != -1 && index < fightData.Length && fightData[index] == 1)
                //        {
                //            fightData[index] = 2;
                //            client.Player.Actives.Info.fightPowerSignData = JsonConvert.SerializeObject(fightData);

                //            // received award
                //            List<ItemInfo> awards = new List<ItemInfo>();
                //            foreach (ActivitySystemItemInfo info in lists)
                //            {
                //                ItemTemplateInfo temp = ItemMgr.FindItemTemplate(info.TemplateID);
                //                if (temp != null)
                //                {
                //                    ItemInfo item = ItemInfo.CreateFromTemplate(temp, info.Count, (int)eItemAddType.Buy);
                //                    item.Count = info.Count;
                //                    item.IsBinds = info.IsBind;
                //                    item.ValidDate = info.ValidDate;
                //                    item.StrengthenLevel = info.StrengthLevel;
                //                    item.AttackCompose = info.AttackCompose;
                //                    item.DefendCompose = info.DefendCompose;
                //                    item.AgilityCompose = info.AgilityCompose;
                //                    item.LuckCompose = info.LuckCompose;
                //                    awards.Add(item);
                //                }
                //            }
                //            if (awards.Count > 0)
                //            {
                //                WorldEventMgr.SendItemsToMails(awards, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, client.Player.ZoneId, LanguageMgr.GetTranslation("SignBuffFightPower.Mail.Title", fightPowerList[index]));
                //                client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
                //            }

                //            client.Out.SendSignBuffInfo(client.Player.Actives.Info);
                //        }
                //        else
                //        {
                //            client.Player.SendMessage(LanguageMgr.GetTranslation("SignBuffFightPower.Error"));
                //        }
                //    }
                //    break;
                /*case (int)LotteryPackageType.MESSAGE:
                    {
                        int type = packet.ReadInt();
                        
                        switch(type)
                        {
                            case 1: // buy ticket
                                int gmId = packet.ReadInt();
                                int total = packet.ReadInt();

                                if (total <= 0 || total > 8)
                                    break;

                                if (ActiveSystemMgr.LotteryTicket.Data.Status != LotteryTicketStatus.OPEN)
                                {
                                    client.Player.SendMessage(LanguageMgr.GetTranslation("LotteryTicket.Event.IsClosed"));
                                    break;
                                }

                                UserLotteryTicketInfo player = ActiveSystemMgr.LotteryTicket.FindPlayer(client.Player.PlayerId);
                                
                                if(player != null && player.PoolList.Count + total > 8)
                                {
                                    client.Player.SendMessage(LanguageMgr.GetTranslation("LotteryTicket.LimitPoolCount"));
                                    break;
                                }

                                int totalPay = GameProperties.LotteryTicketPrice * total;

                                if(client.Player.PlayerCharacter.Money < totalPay)
                                {
                                    client.Player.SendMessage(LanguageMgr.GetTranslation("LotteryTicket.NotEnouchMoney"));
                                    break;
                                }

                                client.Player.RemoveMoney(totalPay);

                                for (int i = 0; i < total; i++)
                                {
                                    string val = packet.ReadString();
                                    if(val.Length == 4)
                                    {
                                        ActiveSystemMgr.LotteryTicket.AddPool(client.Player, val);
                                    }
                                }

                                client.Out.SendLotteryTicketInfo(client.Player.PlayerId, ActiveSystemMgr.LotteryTicket);
                                client.Player.SendMessage(LanguageMgr.GetTranslation("LotteryTicket.BuyTicket.Success", total));

                                break;

                            case 2: // get prizeinfo
                            case 3:
                                {
                                    GSPacketIn pkg = new GSPacketIn((byte)ePackageType.ACTIVITY_PACKAGE);
                                    pkg.WriteInt((int)LotteryPackageType.MESSAGE);
                                    pkg.WriteInt(2);
                                    pkg.WriteInt(ActiveSystemMgr.LotteryTicket.Data.PoolCountCurrent); //pool count
                                    pkg.WriteString(ActiveSystemMgr.LotteryTicket.Data.PoolWinner); // display
                                    pkg.WriteInt(ActiveSystemMgr.LotteryTicket.Data.FirstCount); //firstCount
                                    pkg.WriteInt(ActiveSystemMgr.LotteryTicket.Data.FirstMoney); // firstMoney
                                    pkg.WriteString(ActiveSystemMgr.LotteryTicket.Data.PlayerLastAward);// firstPlayerInfo
                                    pkg.WriteInt(ActiveSystemMgr.LotteryTicket.Data.SecondCount); //secondCount
                                    pkg.WriteInt(ActiveSystemMgr.LotteryTicket.Data.SecondMoney); // secondMoney
                                    pkg.WriteInt(ActiveSystemMgr.LotteryTicket.Data.ThirdCount); //thirdCount
                                    pkg.WriteInt(ActiveSystemMgr.LotteryTicket.Data.ThirdMoney); // thirdMoney
                                    pkg.WriteInt(ActiveSystemMgr.LotteryTicket.Data.FourCount); //fourthCount
                                    pkg.WriteInt(ActiveSystemMgr.LotteryTicket.Data.FourMoney); // fourthMoney
                                    client.Player.SendTCP(pkg);
                                }
                                
                                break;
                        }
                    }
                    break;*/
                #endregion
                #region PvePowerBuff
                //case (int)PvePowerBuffPackageType.PVEPOWERBUFF_MESSAGE:
                //    {
                //        int type = packet.ReadInt();

                //        Console.WriteLine("//type: " + (PvePowerBuffPackageType)type);
                //        switch (type)
                //        {
                //            case (int)PvePowerBuffPackageType.PVEPOWERBUFF_REFRESH:
                //                {
                //                    bool canRef = false;
                //                    if (client.Player.Extra.PvePowerBuff.refreshCount <= 1)
                //                    {
                //                        canRef = true;
                //                    }
                //                    else if (client.Player.RemoveMoney(GameProperties.BlessBuffRefreshPrice) > 0)
                //                    {
                //                        canRef = true;
                //                    }
                //                    else
                //                    {
                //                        client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.ActivityPackage.PvePowerBuff.Msg1"));
                //                    }

                //                    if (canRef)
                //                    {
                //                        client.Player.Extra.PvePowerBuff.refreshCount++;
                //                        client.Player.Extra.RefershPvePowerData();
                //                        client.Out.SendPvePowerBuffRefresh(client.Player.Extra.PvePowerBuff);
                //                    }
                //                }
                //                break;

                //            case (int)PvePowerBuffPackageType.PVEPOWERBUFF_GETBUFF:
                //                {
                //                    int place = packet.ReadInt();

                //                    bool canRef = false;

                //                    if (client.Player.Extra.PvePowerBuff.ListIndexBuff.Count <= place)
                //                    {
                //                        client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.ActivityPackage.PvePowerBuff.Msg2"));
                //                        return 0;
                //                    }

                //                    if (client.Player.Extra.PvePowerBuff.getBuffCount == 0)
                //                    {
                //                        canRef = true;
                //                    }
                //                    else if (client.Player.RemoveMoney(GameProperties.BlessBuffAddBuffPrice) > 0)
                //                    {
                //                        canRef = true;
                //                    }
                //                    else
                //                    {
                //                        client.Player.SendMessage(LanguageMgr.GetTranslation("GameServer.ActivityPackage.PvePowerBuff.Msg1"));
                //                    }

                //                    if (canRef)
                //                    {
                //                        client.Player.Extra.PvePowerBuff.getBuffCount++;
                //                        client.Player.Extra.PvePowerBuff.getBuffIndex = place;
                //                        client.Player.Extra.PvePowerBuff.getBuffDate = DateTime.Now;

                //                        UserPvePowerBuffTempInfo temp = client.Player.Extra.PvePowerBuff.ListIndexBuff[place];

                //                        client.Player.Extra.PvePowerBuff.getBuffAtk = temp.Attack;
                //                        client.Player.Extra.PvePowerBuff.getBuffDef = temp.Defence;
                //                        client.Player.Extra.PvePowerBuff.getBuffAgl = temp.Agility;
                //                        client.Player.Extra.PvePowerBuff.getBuffLuck = temp.Luck;
                //                        client.Player.Extra.PvePowerBuff.getBuffDmg = temp.Damage;
                //                        client.Player.Extra.PvePowerBuff.getBuffAr = temp.Guard;
                //                        client.Player.Extra.PvePowerBuff.getBuffHp = temp.HP;
                //                        client.Player.Extra.PvePowerBuff.getBuffMAtk = temp.MagicAttack;
                //                        client.Player.Extra.PvePowerBuff.getBuffMDef = temp.MagicDefence;

                //                        /*client.Player.Extra.PvePowerBuff.getBuffAtk = (int)Math.Floor((double)temp.Attack / 100 * GameProperties.BlessBuffAddRate);
                //                        client.Player.Extra.PvePowerBuff.getBuffDef = (int)Math.Floor((double)temp.Defence / 100 * GameProperties.BlessBuffAddRate);
                //                        client.Player.Extra.PvePowerBuff.getBuffAgl = (int)Math.Floor((double)temp.Agility / 100 * GameProperties.BlessBuffAddRate);
                //                        client.Player.Extra.PvePowerBuff.getBuffLuck = (int)Math.Floor((double)temp.Luck / 100 * GameProperties.BlessBuffAddRate);
                //                        client.Player.Extra.PvePowerBuff.getBuffDmg = (int)Math.Floor((double)temp.Damage / 100 * GameProperties.BlessBuffAddRate);
                //                        client.Player.Extra.PvePowerBuff.getBuffAr = (int)Math.Floor((double)temp.Guard / 100 * GameProperties.BlessBuffAddRate);
                //                        client.Player.Extra.PvePowerBuff.getBuffHp = (int)Math.Floor((double)temp.HP / 100 * GameProperties.BlessBuffAddRate);
                //                        client.Player.Extra.PvePowerBuff.getBuffMAtk = (int)Math.Floor((double)temp.MagicAttack / 100 * GameProperties.BlessBuffAddRate);
                //                        client.Player.Extra.PvePowerBuff.getBuffMDef = (int)Math.Floor((double)temp.MagicDefence / 100 * GameProperties.BlessBuffAddRate);*/

                //                        client.Out.SendPvePowerGetBuff(client.Player.Extra.PvePowerBuff);
                //                    }
                //                }
                //                break;
                //        }
                //    }
                //    break;
                #endregion
                default:
                    Console.WriteLine("ACTIVITY_PACKAGE not found Cmd {0}", cmd);
                    break;
            }
            return 0;
        }
        //private bool CanGetAward(int grace, int index)
        //{
        //    switch (index)
        //    {
        //        case 0:
        //            if (m_gradeList[index] <= grace)
        //                return true;
        //            break;
        //        case 1:
        //            if (m_gradeList[index] <= grace)
        //                return true;
        //            break;
        //        case 2:
        //            if (m_gradeList[index] <= grace)
        //                return true;
        //            break;
        //        case 3:
        //            if (m_gradeList[index] <= grace)
        //                return true;
        //            break;
        //        case 4:
        //            if (m_gradeList[index] <= grace)
        //                return true;
        //            break;
        //        case 5:
        //            if (m_gradeList[index] <= grace)
        //                return true;
        //            break;
        //        case 6:
        //            if (m_gradeList[index] <= grace)
        //                return true;
        //            break;
        //        case 7:
        //            if (m_gradeList[index] <= grace)
        //                return true;
        //            break;
        //        case 8:
        //            if (m_gradeList[index] <= grace)
        //                return true;
        //            break;
        //    }
        //    return false;
        //}
    }
}
