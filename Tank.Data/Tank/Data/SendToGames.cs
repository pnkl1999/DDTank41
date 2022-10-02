using Helpers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Text;

namespace Tank.Data
{
    public static class SendToGames
    {
        public static bool SendItemsToMail(
          List<SqlDataProvider.Data.ItemInfo> infos,
          int PlayerId,
          string Nickname,
          AreaConfigInfo area,
          string title,
          int type,
          string sender)
        {
            bool flag = false;
            using (PlayerBussiness playerBussiness = new PlayerBussiness(area))
            {
                int num1 = 0;
                int num2 = 0;
                int num3 = 0;
                List<SqlDataProvider.Data.ItemInfo> itemInfoList = new List<SqlDataProvider.Data.ItemInfo>();
                foreach (SqlDataProvider.Data.ItemInfo info in infos)
                {
                    //info.latentEnergyCurStr = "0,0,0,0";
                    //info.latentEnergyNewStr = "0,0,0,0";
                    //info.latentEnergyEndTime = DateTime.Now;
                    if (info.Template == null || info.Template.TemplateID < 0)
                    {
                        if (info.Template.TemplateID == -100)
                            num3 = info.Count;
                        if (info.Template.TemplateID == -200)
                            num1 = info.Count;
                        if (info.Template.TemplateID == -1100)
                            num2 = info.Count;
                    }
                    else if (info.Template.MaxCount == 1)
                    {
                        for (int index = 0; index < info.Count; ++index)
                        {
                            SqlDataProvider.Data.ItemInfo itemInfo = SqlDataProvider.Data.ItemInfo.CloneFromTemplate(info.Template, info);
                            itemInfo.Count = 1;
                            itemInfoList.Add(itemInfo);
                        }
                    }
                    else
                        itemInfoList.Add(info);
                }
                for (int index1 = 0; index1 < itemInfoList.Count; index1 += 5)
                {
                    MailInfo mail = new MailInfo()
                    {
                        Title = title,
                        Gold = 0,
                        IsExist = true,
                        Money = 0,
                        Receiver = Nickname,
                        ReceiverID = PlayerId,
                        Sender = string.IsNullOrEmpty(sender) ? LanguageMgr.GetTranslation("SystermSender.Msg") : sender,
                        SenderID = 0,
                        Type = type,
                        GiftToken = 0
                    };
                    StringBuilder stringBuilder1 = new StringBuilder();
                    StringBuilder stringBuilder2 = new StringBuilder();
                    stringBuilder1.Append(LanguageMgr.GetTranslation("Game.Server.GameUtils.CommonBag.AnnexRemark"));
                    int index2 = index1;
                    if (itemInfoList.Count > index2)
                    {
                        SqlDataProvider.Data.ItemInfo itemInfo = itemInfoList[index2];
                        if (itemInfo.ItemID == 0)
                            playerBussiness.AddGoods(itemInfo);
                        mail.Annex1 = itemInfo.ItemID.ToString();
                        mail.Annex1Name = itemInfo.Template.Name;
                        stringBuilder1.Append("1、" + mail.Annex1Name + "x" + (object)itemInfo.Count + ";");
                        stringBuilder2.Append("1、" + mail.Annex1Name + "x" + (object)itemInfo.Count + ";");
                    }
                    int index3 = index1 + 1;
                    if (itemInfoList.Count > index3)
                    {
                        SqlDataProvider.Data.ItemInfo itemInfo = itemInfoList[index3];
                        if (itemInfo.ItemID == 0)
                            playerBussiness.AddGoods(itemInfo);
                        mail.Annex2 = itemInfo.ItemID.ToString();
                        mail.Annex2Name = itemInfo.Template.Name;
                        stringBuilder1.Append("2、" + mail.Annex2Name + "x" + (object)itemInfo.Count + ";");
                        stringBuilder2.Append("2、" + mail.Annex2Name + "x" + (object)itemInfo.Count + ";");
                    }
                    int index4 = index1 + 2;
                    if (itemInfoList.Count > index4)
                    {
                        SqlDataProvider.Data.ItemInfo itemInfo = itemInfoList[index4];
                        if (itemInfo.ItemID == 0)
                            playerBussiness.AddGoods(itemInfo);
                        mail.Annex3 = itemInfo.ItemID.ToString();
                        mail.Annex3Name = itemInfo.Template.Name;
                        stringBuilder1.Append("3、" + mail.Annex3Name + "x" + (object)itemInfo.Count + ";");
                        stringBuilder2.Append("3、" + mail.Annex3Name + "x" + (object)itemInfo.Count + ";");
                    }
                    int index5 = index1 + 3;
                    if (itemInfoList.Count > index5)
                    {
                        SqlDataProvider.Data.ItemInfo itemInfo = itemInfoList[index5];
                        if (itemInfo.ItemID == 0)
                            playerBussiness.AddGoods(itemInfo);
                        mail.Annex4 = itemInfo.ItemID.ToString();
                        mail.Annex4Name = itemInfo.Template.Name;
                        stringBuilder1.Append("4、" + mail.Annex4Name + "x" + (object)itemInfo.Count + ";");
                        stringBuilder2.Append("4、" + mail.Annex4Name + "x" + (object)itemInfo.Count + ";");
                    }
                    int index6 = index1 + 4;
                    if (itemInfoList.Count > index6)
                    {
                        SqlDataProvider.Data.ItemInfo itemInfo = itemInfoList[index6];
                        if (itemInfo.ItemID == 0)
                            playerBussiness.AddGoods(itemInfo);
                        mail.Annex5 = itemInfo.ItemID.ToString();
                        mail.Annex5Name = itemInfo.Template.Name;
                        stringBuilder1.Append("5、" + mail.Annex5Name + "x" + (object)itemInfo.Count + ";");
                        stringBuilder2.Append("5、" + mail.Annex5Name + "x" + (object)itemInfo.Count + ";");
                    }
                    mail.AnnexRemark = stringBuilder1.ToString();
                    mail.Content = stringBuilder2.ToString();
                    flag = playerBussiness.SendMail(mail, area.AreaID);
                }
                if (num3 + num1 + num2 > 0)
                {
                    MailInfo mail = new MailInfo()
                    {
                        Title = title,
                        Gold = num3,
                        IsExist = true,
                        Money = num1,
                        Receiver = Nickname,
                        ReceiverID = PlayerId,
                        Sender = string.IsNullOrEmpty(sender) ? LanguageMgr.GetTranslation("SystermSender.Msg") : sender,
                        SenderID = 0,
                        GiftToken = num2
                    };
                    flag = playerBussiness.SendMail(mail, area.AreaID);
                }
            }
            return flag;
        }
    }
}
