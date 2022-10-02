// Decompiled with JetBrains decompiler
// Type: Tank.Data.ConsortiaBussiness
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using Helpers;
using SqlDataProvider.BaseClass;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace Tank.Data
{
  public class ConsortiaBussiness : BaseBussiness
  {
    private string m_areaName = "Area 1";
    private int m_areaID = 1;

    public ConsortiaBussiness() => this.db = new Sql_DbObject("WebConfig", "crosszoneString");

    public ConsortiaBussiness(AreaConfigInfo config)
    {
      this.m_areaName = config.AreaName;
      this.m_areaID = config.AreaID;
      StringBuilder stringBuilder = new StringBuilder();
      stringBuilder.Append("Data Source=");
      stringBuilder.Append(config.DataSource);
      stringBuilder.Append("; Initial Catalog=");
      stringBuilder.Append(config.Catalog);
      stringBuilder.Append("; Persist Security Info=True;User ID=");
      stringBuilder.Append(config.UserID);
      stringBuilder.Append("; Password=");
      stringBuilder.Append(config.Password);
      stringBuilder.Append(";");
      this.db = new Sql_DbObject("AreaConfig", stringBuilder.ToString());
    }

    public ConsortiaUserInfo[] GetConsortiaUsersPage(
      int page,
      int size,
      ref int total,
      int order,
      int consortiaID,
      int userID,
      int state)
    {
      List<ConsortiaUserInfo> consortiaUserInfoList = new List<ConsortiaUserInfo>();
      try
      {
        string queryWhere = " IsExist=1 ";
        if (consortiaID != -1)
          queryWhere = queryWhere + " and ConsortiaID =" + (object) consortiaID + " ";
        if (userID != -1)
          queryWhere = queryWhere + " and UserID =" + (object) userID + " ";
        if (state != -1)
          queryWhere = queryWhere + " and State =" + (object) state + " ";
        string str = "UserName";
        switch (order)
        {
          case 1:
            str = "DutyID";
            break;
          case 2:
            str = "Grade";
            break;
          case 3:
            str = "Repute";
            break;
          case 4:
            str = "GP";
            break;
          case 5:
            str = "State";
            break;
          case 6:
            str = "Offer";
            break;
        }
        string fdOreder = str + ",ID ";
        foreach (DataRow row in (InternalDataCollectionBase) this.GetPage("V_Consortia_Users", queryWhere, page, size, "*", fdOreder, "ID", ref total).Rows)
        {
          ConsortiaUserInfo consortiaUserInfo = new ConsortiaUserInfo()
          {
            ID = (int) row["ID"],
            ConsortiaID = (int) row["ConsortiaID"],
            DutyID = (int) row["DutyID"],
            DutyName = row["DutyName"].ToString(),
            IsExist = (bool) row["IsExist"],
            RatifierID = (int) row["RatifierID"],
            RatifierName = row["RatifierName"].ToString(),
            Remark = row["Remark"].ToString(),
            UserID = (int) row["UserID"],
            UserName = row["UserName"].ToString(),
            Grade = (int) row["Grade"],
            GP = (int) row["GP"],
            Repute = (int) row["Repute"],
            State = (int) row["State"],
            Right = (int) row["Right"],
            Offer = (int) row["Offer"],
            Colors = row["Colors"].ToString(),
            Style = row["Style"].ToString(),
            Hide = (int) row["Hide"]
          };
          consortiaUserInfo.Skin = row["Skin"] == null ? "" : consortiaUserInfo.Skin;
          consortiaUserInfo.Level = (int) row["Level"];
          consortiaUserInfo.LastDate = (DateTime) row["LastDate"];
          consortiaUserInfo.Sex = (bool) row["Sex"];
          consortiaUserInfo.IsBanChat = (bool) row["IsBanChat"];
          consortiaUserInfo.Win = (int) row["Win"];
          consortiaUserInfo.Total = (int) row["Total"];
          consortiaUserInfo.Escape = (int) row["Escape"];
          consortiaUserInfo.RichesOffer = (int) row["RichesOffer"];
          consortiaUserInfo.RichesRob = (int) row["RichesRob"];
          consortiaUserInfo.LoginName = row["LoginName"] == null ? "" : row["LoginName"].ToString();
          consortiaUserInfo.Nimbus = (int) row["Nimbus"];
          consortiaUserInfo.FightPower = (int) row["FightPower"];
          consortiaUserInfo.typeVIP = Convert.ToByte(row["typeVIP"]);
          consortiaUserInfo.VIPLevel = (int) row["VIPLevel"];
          consortiaUserInfoList.Add(consortiaUserInfo);
        }
      }
      catch (Exception ex)
      {
        Logger.Error("GetConsortiaUsersPage " + ex.ToString());
      }
      finally
      {
      }
      return consortiaUserInfoList.ToArray();
    }

    public ConsortiaUserInfo[] GetConsortiaUsersByconsortiaID(int consortiaID)
    {
      int total = 0;
      return this.GetConsortiaUsersPage(1, 250, ref total, -1, consortiaID, -1, -1);
    }

    public ConsortiaUserInfo GetConsortiaUsersByUserID(int userID)
    {
      int total = 0;
      ConsortiaUserInfo[] consortiaUsersPage = this.GetConsortiaUsersPage(1, 1, ref total, -1, -1, userID, -1);
      return consortiaUsersPage.Length == 1 ? consortiaUsersPage[0] : (ConsortiaUserInfo) null;
    }
  }
}
