using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using log4net;
using SqlDataProvider.Data;
using Bussiness;
using Bussiness.Managers;
using Game.Server.GameUtils;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.NEWCHICKENBOX_SYS, "客户端日记")]
    public class ChickenBoxHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int cmd = packet.ReadInt();
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.NEWCHICKENBOX_SYS);
            ActiveSystemInfo ChickenBox = client.Player.Actives.Info;
            //Console.WriteLine("NewChickenBoxPackageType." + (NewChickenBoxPackageType)cmd);
            switch (cmd)
            {
                case (int)NewChickenBoxPackageType.TAKEOVERCARD:
                    {
                        int position = packet.ReadInt();
                        if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
                        {
                            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                            return 1;
                        }
                        int OpenCounts = ChickenBox.canOpenCounts;
                        if (OpenCounts > 0)
                        {
                            NewChickenBoxItemInfo item = client.Player.Actives.GetAward(position);
                            if (item != null)
                            {
                                item.IsBinds = true;
                                item.IsSelected = true;
                                if (OpenCounts > client.Player.Actives.openCardPrice.Length)
                                    OpenCounts = client.Player.Actives.openCardPrice.Length;

                                int needMoney = client.Player.Actives.openCardPrice[OpenCounts - 1];
                                if (client.Player.MoneyDirect(needMoney, IsAntiMult: false, false))
                                {
                                    //Console.WriteLine(string.Format("position {0} item.Position {1}", position, item.Position));
                                    pkg.WriteInt((int)NewChickenBoxPackageType.TACKOVERCARD);
                                    pkg.WriteInt(item.TemplateID);//_loc_4.TemplateID = _loc_2.readInt();
                                    pkg.WriteInt(item.StrengthenLevel);//_loc_4.StrengthenLevel = _loc_2.readInt();
                                    pkg.WriteInt(item.Count);//_loc_4.Count = _loc_2.readInt();
                                    pkg.WriteInt(item.ValidDate);//_loc_4.ValidDate = _loc_2.readInt();
                                    pkg.WriteInt(item.AttackCompose);//_loc_4.AttackCompose = _loc_2.readInt();
                                    pkg.WriteInt(item.DefendCompose);//_loc_4.DefendCompose = _loc_2.readInt();
                                    pkg.WriteInt(item.AgilityCompose);//_loc_4.AgilityCompose = _loc_2.readInt();
                                    pkg.WriteInt(item.LuckCompose);//_loc_4.LuckCompose = _loc_2.readInt();
                                    pkg.WriteInt(item.Position);//_loc_4.Position = _loc_2.readInt();
                                    pkg.WriteBoolean(item.IsSelected);//_loc_4.IsSelected = _loc_2.readBoolean();
                                    pkg.WriteBoolean(item.IsSeeded);//_loc_4.IsSeeded = _loc_2.readBoolean();
                                    pkg.WriteBoolean(item.IsBinds);//_loc_4.IsBinds = _loc_2.readBoolean();
                                    pkg.WriteInt(client.Player.Actives.freeOpenCardCount);//_model.freeOpenCardCount = _loc_2.readInt();
                                    client.Out.SendTCP(pkg);
                                    client.Player.Actives.UpdateChickenBoxAward(item);
                                    ItemInfo itemAward = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(item.TemplateID), 1, 105);
                                    itemAward.IsBinds = item.IsBinds;
                                    itemAward.ValidDate = item.ValidDate;
                                    client.Player.AddTemplate(itemAward, LanguageMgr.GetTranslation("ChickenBoxHandler.Msg7"));
                                    client.Player.SendMessage(LanguageMgr.GetTranslation("ChickenBoxHandler.Msg8", itemAward.Template.Name, item.Count));
                                    ChickenBox.canOpenCounts--;
                                    if (ChickenBox.canOpenCounts == 0)
                                    {
                                        GSPacketIn spkg = new GSPacketIn((byte)ePackageType.NEWCHICKENBOX_SYS);
                                        spkg.WriteInt((byte)NewChickenBoxPackageType.OVERSHOWITEMS);
                                        client.Player.SendTCP(spkg);
                                    }
                                }
                            }
                            else
                            {
                                client.Player.SendMessage(LanguageMgr.GetTranslation("ChickenBoxHandler.Msg1"));
                            }
                        }
                        else
                        {
                            client.Player.SendMessage(LanguageMgr.GetTranslation("ChickenBoxHandler.Msg9"));

                        }
                        break;
                    }
                case (int)NewChickenBoxPackageType.USEEAGLEEYE:
                    {
                        int position = packet.ReadInt();
                        int EagleEyeCounts = ChickenBox.canEagleEyeCounts;
                        if (EagleEyeCounts > 0)
                        {
                            NewChickenBoxItemInfo item = client.Player.Actives.ViewAward(position);
                            if (item != null)
                            {
                                if (EagleEyeCounts > client.Player.Actives.eagleEyePrice.Length)
                                    EagleEyeCounts = client.Player.Actives.eagleEyePrice.Length;

                                int needMoney = client.Player.Actives.eagleEyePrice[EagleEyeCounts - 1];
                                if (client.Player.MoneyDirect(needMoney, IsAntiMult: false, false))
                                {
                                    item.IsSeeded = true;
                                    //Console.WriteLine(string.Format("position {0} item.Position {1}", position, item.Position));
                                    pkg.WriteInt((int)NewChickenBoxPackageType.EAGLEEYE);
                                    pkg.WriteInt(item.TemplateID);//_loc_4.TemplateID = _loc_2.readInt();
                                    pkg.WriteInt(item.StrengthenLevel);//_loc_4.StrengthenLevel = _loc_2.readInt();
                                    pkg.WriteInt(item.Count);//_loc_4.Count = _loc_2.readInt();
                                    pkg.WriteInt(item.ValidDate);//_loc_4.ValidDate = _loc_2.readInt();
                                    pkg.WriteInt(item.AttackCompose);//_loc_4.AttackCompose = _loc_2.readInt();
                                    pkg.WriteInt(item.DefendCompose);//_loc_4.DefendCompose = _loc_2.readInt();
                                    pkg.WriteInt(item.AgilityCompose);//_loc_4.AgilityCompose = _loc_2.readInt();
                                    pkg.WriteInt(item.LuckCompose);//_loc_4.LuckCompose = _loc_2.readInt();
                                    pkg.WriteInt(item.Position);//_loc_4.Position = _loc_2.readInt();
                                    pkg.WriteBoolean(item.IsSelected);//_loc_4.IsSelected = _loc_2.readBoolean();
                                    pkg.WriteBoolean(item.IsSeeded);//_loc_4.IsSeeded = _loc_2.readBoolean();
                                    pkg.WriteBoolean(item.IsBinds);//_loc_4.IsBinds = _loc_2.readBoolean();
                                    pkg.WriteInt(client.Player.Actives.freeEyeCount);// _model.freeEyeCount = _loc_2.readInt();
                                    client.Player.SendTCP(pkg);
                                    client.Player.Actives.UpdateChickenBoxAward(item);
                                    ChickenBox.canEagleEyeCounts--;
                                }
                            }
                            else
                            {
                                client.Player.SendMessage(LanguageMgr.GetTranslation("ChickenBoxHandler.Msg1"));
                            }
                        }
                        else
                        {
                            client.Player.SendMessage(LanguageMgr.GetTranslation("ChickenBoxHandler.Msg2"));

                        }
                        break;
                    }
                case (int)NewChickenBoxPackageType.FLUSHCHICKENVIEW:
                    {
                        int needMoney = client.Player.Actives.flushPrice;
                        if (client.Player.Actives.IsFreeFlushTime())
                        {
                            if (client.Player.MoneyDirect(needMoney, IsAntiMult: false, false))
                            {
                                client.Player.Actives.PayFlushView();
                                client.Player.Actives.SendChickenBoxItemList();
                                client.Player.SendMessage(LanguageMgr.GetTranslation("ChickenBoxHandler.Msg3"));
                            }
                        }
                        else
                        {
                            client.Player.Actives.PayFlushView();
                            client.Player.Actives.SendChickenBoxItemList();
                            client.Player.SendMessage(LanguageMgr.GetTranslation("ChickenBoxHandler.Msg4"));
                        }
                        break;
                    }
                case (int)NewChickenBoxPackageType.AllITEMSHOW:
                    {
                        client.Player.Actives.SendChickenBoxItemList();
                        client.Player.Actives.PayFlushView();
                        break;
                    }
                case (int)NewChickenBoxPackageType.CLICKSTARTBNT:
                    {
                        ChickenBox.isShowAll = false;
                        client.Player.Actives.RandomPosition();
                        pkg.WriteInt((int)NewChickenBoxPackageType.CANCLICKCARD);
                        pkg.WriteBoolean(true);//_model.canclickEnable = _loc_2.readBoolean();
                        client.Player.SendTCP(pkg);
                        break;
                    }
                case (int)NewChickenBoxPackageType.ENTERCHICKENVIEW:
                    {
                        client.Player.Actives.EnterChickenBox();
                        client.Player.Actives.SendChickenBoxItemList();
                    }
                    break;
                case (int)NewChickenBoxPackageType.ENTER_GAME:
                    {
                        int Money = 2500;
                        if (client.Player.PlayerCharacter.Money < Money)
                        {
                            client.Player.Out.SendAcademySystemNotice(LanguageMgr.GetTranslation($"Cần {Money} xu để sử dụng tính năng!"), isAlert: true);
                            return 0;
                        }
                        else
                        {
                            client.Player.SendMessage(LanguageMgr.GetTranslation($"Đã trừ {Money} xu khi bắt đầu mở tính năng!"));
                            client.Player.RemoveMoney(Money);
                            client.Player.SavePlayerInfo();
                            client.Player.Actives.CreateLuckyStartAward();
                            client.Player.Actives.SendLuckStarAllGoodsInfo();
                            client.Player.Actives.SendLuckStarRewardRank();
                            client.Player.Actives.SendLuckStarRewardRecord();
                        }
                    }
                    break;
                case (int)NewChickenBoxPackageType.CLOSE_GAME:
                    {
                    }
                    break;
                case (int)NewChickenBoxPackageType.START_TURN://10s/round
                    {
                        int timeLeft = DateTime.Compare(client.Player.Actives.LuckyStartStartTurn.AddSeconds(7.0), DateTime.Now);
                        if (timeLeft <= 0)
                        {
                            int luckystarID = (int)EquipType.LUCKYSTAR_ID;
                            ItemTemplateInfo templateInfo = ItemMgr.FindItemTemplate(luckystarID);
                            if (templateInfo != null)
                            {
                                PlayerInventory bag = client.Player.GetInventory(templateInfo.BagType);
                                ItemInfo luckystarItem = bag.GetItemByTemplateID(0, luckystarID);
                                if (luckystarItem != null && luckystarItem.Count > 0)
                                {
                                    bag.RemoveTemplate(luckystarID, 1);
                                    client.Player.Actives.ChangeLuckyStartAwardPlace();
                                    client.Player.Actives.SendLuckStarTurnGoodsInfo();
                                }
                                else
                                {
                                    client.Player.SendMessage(LanguageMgr.GetTranslation("ChickenBoxHandler.Msg5", templateInfo.Name));
                                }
                            }
                            client.Player.Actives.LuckyStartStartTurn = DateTime.Now;
                        }
                        else
                        {
                            client.Player.SendMessage(LanguageMgr.GetTranslation("ChickenBoxHandler.Msg6"));
                        }
                    }
                    break;
                case (int)NewChickenBoxPackageType.TURN_COMPLETE:
                    {
                        client.Player.Actives.SendUpdateReward();
                        NewChickenBoxItemInfo award = client.Player.Actives.Award;
                        ItemTemplateInfo template = ItemMgr.FindItemTemplate(award.TemplateID);
                        if (template != null && template.CategoryID != client.Player.Actives.coinTemplateID)
                        {
                            ItemInfo item = ItemInfo.CreateFromTemplate(template, award.Count, 105);
                            client.Player.AddTemplate(item, LanguageMgr.GetTranslation("ChickenBoxHandler.Msg10"));
                        }
                    }
                    break;
                default:
                    {
                        NewChickenBoxPackageType newChickenBoxPackageType = (NewChickenBoxPackageType)cmd;
                        Console.WriteLine("NewChickenBoxPackageType." + newChickenBoxPackageType);
                    }
                    break;
            }
            return 0;
        }
    }
}
