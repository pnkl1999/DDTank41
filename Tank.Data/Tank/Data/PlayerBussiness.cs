// Decompiled with JetBrains decompiler
// Type: Tank.Data.PlayerBussiness
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using Helpers;
using SqlDataProvider.BaseClass;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;
using System.Text;

namespace Tank.Data
{
    public class PlayerBussiness : BaseBussiness
    {
        public PlayerBussiness() => this.db = new Sql_DbObject("WebConfig", "crosszoneString");

        public PlayerBussiness(AreaConfigInfo config)
        {
            if (config == null)
            {
                this.db = new Sql_DbObject("WebConfig", "crosszoneString");
            }
            else
            {
                this.AreaName = config.AreaName;
                this.AreaId = config.AreaID;
                this.Version = config.Version;
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
        }

        public bool FillSqlReader(ref SqlDataReader sdr, string sqlComm) => this.db.FillSqlDataReader(ref sdr, sqlComm);

        public int GetMaxIdByTable(string tablename, string columnName)
        {
            List<ActiveNumberInfo> activeNumberInfoList = new List<ActiveNumberInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT MaxID = ISNULL(MAX(" + columnName + "),1)  FROM [dbo].[" + tablename + "]");
                if (Sdr.Read())
                    return int.Parse(Sdr["MaxID"].ToString());
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllActiveNumberBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return 0;
        }

        public ActiveNumberInfo[] GetAllActiveNumber()
        {
            List<ActiveNumberInfo> activeNumberInfoList = new List<ActiveNumberInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Active_Number]");
                while (Sdr.Read())
                    activeNumberInfoList.Add(this.InitActiveNumberInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllActiveNumber " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeNumberInfoList.ToArray();
        }

        public ActiveNumberInfo[] GetAllActiveNumberBy(int activeID)
        {
            List<ActiveNumberInfo> activeNumberInfoList = new List<ActiveNumberInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Active_Number] WHERE ActiveID = " + activeID.ToString());
                while (Sdr.Read())
                    activeNumberInfoList.Add(this.InitActiveNumberInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllActiveNumberBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeNumberInfoList.ToArray();
        }

        public ActiveNumberInfo InitActiveNumberInfo(SqlDataReader reader) => new ActiveNumberInfo()
        {
            AwardID = reader["AwardID"] == null ? "" : reader["AwardID"].ToString(),
            ActiveID = (int)reader["ActiveID"],
            PullDown = (bool)reader["PullDown"],
            GetDate = (DateTime)reader["GetDate"],
            UserID = (int)reader["UserID"],
            Mark = (int)reader["Mark"]
        };

        public bool AddActiveNumber(ActiveNumberInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Active_Number]\r\n                                   ([AwardID]\r\n                                   ,[ActiveID]\r\n                                   ,[PullDown]\r\n                                   ,[GetDate]\r\n                                   ,[UserID]\r\n                                   ,[Mark])\r\n                               VALUES\r\n                                   (@AwardID\r\n                                   ,@ActiveID\r\n                                   ,@PullDown\r\n                                   ,@GetDate\r\n                                   ,@UserID\r\n                                   ,@Mark)", new SqlParameter[6]
                {
          new SqlParameter("@AwardID", (object) item.AwardID),
          new SqlParameter("@ActiveID", (object) item.ActiveID),
          new SqlParameter("@PullDown", (object) item.PullDown),
          new SqlParameter("@GetDate", (object) item.GetDate),
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@Mark", (object) item.Mark)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddActiveNumber: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteActiveNumber(int activeID, string awardID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Active_Number] WHERE [AwardID] = @AwardID AND [ActiveID] = @ActiveID", new SqlParameter[2]
                {
          new SqlParameter("@ActiveID", (object) activeID),
          new SqlParameter("@AwardID", (object) awardID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteActiveNumber: " + ex.ToString());
            }
            return flag;
        }

        public TexpInfo GetSingleTexp(string where)
        {
            List<TexpInfo> texpInfoList = new List<TexpInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Sys_Users_Texp] WHERE " + where);
                while (Sdr.Read())
                    texpInfoList.Add(this.InitDataReader<TexpInfo>(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllTexpBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return texpInfoList.Count > 0 ? texpInfoList[0] : (TexpInfo)null;
        }

        public bool UpdateTexp(TexpInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Sys_Users_Texp]\r\n                               SET [UserID] = @UserID\r\n                                  ,[spdTexpExp] = @spdTexpExp\r\n                                  ,[attTexpExp] = @attTexpExp\r\n                                  ,[defTexpExp] = @defTexpExp\r\n                                  ,[hpTexpExp] = @hpTexpExp\r\n                                  ,[lukTexpExp] = @lukTexpExp\r\n                                  ,[texpTaskCount] = @texpTaskCount\r\n                                  ,[texpCount] = @texpCount\r\n                                  ,[texpTaskDate] = @texpTaskDate\r\n                                  ,[magicAtkTexpExp] = @magicAtkTexpExp\r\n                                  ,[magicDefTexpExp] = @magicDefTexpExp\r\n                                  ,[magicTexpCount] = @magicTexpCount\r\n                            WHERE [ID] = @ID", new SqlParameter[13]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@spdTexpExp", (object) item.spdTexpExp),
          new SqlParameter("@attTexpExp", (object) item.attTexpExp),
          new SqlParameter("@defTexpExp", (object) item.defTexpExp),
          new SqlParameter("@hpTexpExp", (object) item.hpTexpExp),
          new SqlParameter("@lukTexpExp", (object) item.lukTexpExp),
          new SqlParameter("@texpTaskCount", (object) item.texpTaskCount),
          new SqlParameter("@texpCount", (object) item.texpCount),
          new SqlParameter("@texpTaskDate", (object) item.texpTaskDate),
          new SqlParameter("@magicAtkTexpExp", (object) item.magicAtkTexpExp),
          new SqlParameter("@magicDefTexpExp", (object) item.magicDefTexpExp),
          new SqlParameter("@magicTexpCount", (object) item.magicTexpCount)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateTexp: " + ex.ToString());
            }
            return flag;
        }

        public UsersPetInfo[] GetAllUserPet(
          string swhere,
          int currentPageIndex,
          int pagesize,
          ref int totalCount)
        {
            List<UsersPetInfo> usersPetInfoList = new List<UsersPetInfo>();
            try
            {
                foreach (DataRow row in (InternalDataCollectionBase)this.GetPage("Sys_Users_Pet", swhere, currentPageIndex + 1, pagesize, "*", "ID", "ID", ref totalCount).Rows)
                    usersPetInfoList.Add(this.InitDataRow<UsersPetInfo>(row));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllUserPet " + ex.ToString());
            }
            return usersPetInfoList.ToArray();
        }

        public SqlDataProvider.Data.ItemInfo[] GetAllItem(
          string swhere,
          int currentPageIndex,
          int pagesize,
          ref int totalCount)
        {
            List<SqlDataProvider.Data.ItemInfo> itemInfoList = new List<SqlDataProvider.Data.ItemInfo>();
            try
            {
                foreach (DataRow row in (InternalDataCollectionBase)this.GetPage("Sys_Users_Goods", swhere, currentPageIndex + 1, pagesize, "*", "ItemID", "ItemID", ref totalCount).Rows)
                {
                    SqlDataProvider.Data.ItemInfo itemInfo = new SqlDataProvider.Data.ItemInfo(ItemTemplateMgr.FindItemTemplate((int)row["TemplateID"]))
                    {
                        ZoneID = this.AreaId
                    };
                    for (int index = 0; index < row.Table.Columns.Count; ++index)
                    {
                        string columnName = row.Table.Columns[index].ColumnName;
                        PropertyInfo property = itemInfo.GetType().GetProperty(columnName, BindingFlags.Instance | BindingFlags.Public);
                        if ((PropertyInfo)null != property && property.CanWrite)
                            property.SetValue((object)itemInfo, Convert.ChangeType(row[columnName], property.PropertyType), (object[])null);
                    }
                    itemInfoList.Add(itemInfo);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllConsortia " + ex.ToString());
            }
            return itemInfoList.ToArray();
        }

        public SqlDataProvider.Data.ItemInfo GetSigleItem(string where)
        {
            List<SqlDataProvider.Data.ItemInfo> itemInfoList = new List<SqlDataProvider.Data.ItemInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Sys_Users_Goods] WHERE  " + where);
                while (Sdr.Read())
                    itemInfoList.Add(this.InitItemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleItem " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemInfoList.Count > 0 ? itemInfoList[0] : (SqlDataProvider.Data.ItemInfo)null;
        }

        public SqlDataProvider.Data.ItemInfo InitItemInfo(SqlDataReader reader)
        {
            SqlDataProvider.Data.ItemInfo itemInfo = new SqlDataProvider.Data.ItemInfo(ItemTemplateMgr.FindItemTemplate((int)reader["TemplateID"]));
            itemInfo.ZoneID = this.AreaId;
            for (int ordinal = 0; ordinal < reader.FieldCount; ++ordinal)
            {
                string name = reader.GetName(ordinal);
                PropertyInfo property = itemInfo.GetType().GetProperty(name, BindingFlags.Instance | BindingFlags.Public);
                if ((PropertyInfo)null != property && property.CanWrite)
                    property.SetValue((object)itemInfo, Convert.ChangeType(reader[name], property.PropertyType), (object[])null);
            }
            return itemInfo;
        }

        public bool AddGoods(SqlDataProvider.Data.ItemInfo item)
        {
            bool flag = false;
            SqlParameter[] sqlParameterArray = new SqlParameter[55];
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[55];
                Logger.Error("Version " + this.Version);
                if (this.Version == "3.6")
                {
                    SqlParameters = new SqlParameter[36];
                    SqlParameters[0] = new SqlParameter("@ItemID", (object)item.ItemID);
                    SqlParameters[0].Direction = ParameterDirection.Output;
                    SqlParameters[1] = new SqlParameter("@UserID", (object)item.UserID);
                    SqlParameters[2] = new SqlParameter("@TemplateID", (object)item.TemplateID);
                    SqlParameters[3] = new SqlParameter("@Place", (object)item.Place);
                    SqlParameters[4] = new SqlParameter("@AgilityCompose", (object)item.AgilityCompose);
                    SqlParameters[5] = new SqlParameter("@AttackCompose", (object)item.AttackCompose);
                    SqlParameters[6] = new SqlParameter("@BeginDate", (object)item.BeginDate);
                    SqlParameters[7] = new SqlParameter("@Color", item.Color == null ? (object)"" : (object)item.Color);
                    SqlParameters[8] = new SqlParameter("@Count", (object)item.Count);
                    SqlParameters[9] = new SqlParameter("@DefendCompose", (object)item.DefendCompose);
                    SqlParameters[10] = new SqlParameter("@IsBinds", (object)item.IsBinds);
                    SqlParameters[11] = new SqlParameter("@IsExist", (object)item.IsExist);
                    SqlParameters[12] = new SqlParameter("@IsJudge", (object)item.IsJudge);
                    SqlParameters[13] = new SqlParameter("@LuckCompose", (object)item.LuckCompose);
                    SqlParameters[14] = new SqlParameter("@StrengthenLevel", (object)item.StrengthenLevel);
                    SqlParameters[15] = new SqlParameter("@ValidDate", (object)item.ValidDate);
                    SqlParameters[16] = new SqlParameter("@BagType", (object)item.BagType);
                    SqlParameters[17] = new SqlParameter("@Skin", item.Skin == null ? (object)"" : (object)item.Skin);
                    SqlParameters[18] = new SqlParameter("@IsUsed", (object)item.IsUsed);
                    SqlParameters[19] = new SqlParameter("@RemoveType", (object)item.RemoveType);
                    SqlParameters[20] = new SqlParameter("@Hole1", (object)item.Hole1);
                    SqlParameters[21] = new SqlParameter("@Hole2", (object)item.Hole2);
                    SqlParameters[22] = new SqlParameter("@Hole3", (object)item.Hole3);
                    SqlParameters[23] = new SqlParameter("@Hole4", (object)item.Hole4);
                    SqlParameters[24] = new SqlParameter("@Hole5", (object)item.Hole5);
                    SqlParameters[25] = new SqlParameter("@Hole6", (object)item.Hole6);
                    SqlParameters[26] = new SqlParameter("@StrengthenTimes", (object)item.StrengthenTimes);
                    SqlParameters[27] = new SqlParameter("@isGold", (object)item.IsGold);
                    SqlParameters[28] = new SqlParameter("@Hole5Level", (object)item.Hole5Level);
                    SqlParameters[29] = new SqlParameter("@Hole5Exp", (object)item.Hole5Exp);
                    SqlParameters[30] = new SqlParameter("@Hole6Level", (object)item.Hole6Level);
                    SqlParameters[31] = new SqlParameter("@Hole6Exp", (object)item.Hole6Exp);
                    SqlParameters[32] = new SqlParameter("@goldBeginTime", (object)item.goldBeginTime);
                    SqlParameters[33] = new SqlParameter("@goldValidDate", (object)item.goldValidDate);
                    SqlParameters[34] = new SqlParameter("@StrengthenExp", (object)item.StrengthenExp);
                    SqlParameters[35] = new SqlParameter("@Blood", (object)int.Parse("0"));
                }
                else if (this.Version == "3.4")
                {
                    SqlParameters = new SqlParameter[28];
                    SqlParameters[0] = new SqlParameter("@ItemID", (object)item.ItemID);
                    SqlParameters[0].Direction = ParameterDirection.Output;
                    SqlParameters[1] = new SqlParameter("@UserID", (object)item.UserID);
                    SqlParameters[2] = new SqlParameter("@TemplateID", (object)item.TemplateID);
                    SqlParameters[3] = new SqlParameter("@Place", (object)item.Place);
                    SqlParameters[4] = new SqlParameter("@AgilityCompose", (object)item.AgilityCompose);
                    SqlParameters[5] = new SqlParameter("@AttackCompose", (object)item.AttackCompose);
                    SqlParameters[6] = new SqlParameter("@BeginDate", (object)item.BeginDate);
                    SqlParameters[7] = new SqlParameter("@Color", item.Color == null ? (object)"" : (object)item.Color);
                    SqlParameters[8] = new SqlParameter("@Count", (object)item.Count);
                    SqlParameters[9] = new SqlParameter("@DefendCompose", (object)item.DefendCompose);
                    SqlParameters[10] = new SqlParameter("@IsBinds", (object)item.IsBinds);
                    SqlParameters[11] = new SqlParameter("@IsExist", (object)item.IsExist);
                    SqlParameters[12] = new SqlParameter("@IsJudge", (object)item.IsJudge);
                    SqlParameters[13] = new SqlParameter("@LuckCompose", (object)item.LuckCompose);
                    SqlParameters[14] = new SqlParameter("@StrengthenLevel", (object)item.StrengthenLevel);
                    SqlParameters[15] = new SqlParameter("@ValidDate", (object)item.ValidDate);
                    SqlParameters[16] = new SqlParameter("@BagType", (object)item.BagType);
                    SqlParameters[17] = new SqlParameter("@Skin", item.Skin == null ? (object)"" : (object)item.Skin);
                    SqlParameters[18] = new SqlParameter("@IsUsed", (object)item.IsUsed);
                    SqlParameters[19] = new SqlParameter("@RemoveType", (object)item.RemoveType);
                    SqlParameters[20] = new SqlParameter("@Hole1", (object)item.Hole1);
                    SqlParameters[21] = new SqlParameter("@Hole2", (object)item.Hole2);
                    SqlParameters[22] = new SqlParameter("@Hole3", (object)item.Hole3);
                    SqlParameters[23] = new SqlParameter("@Hole4", (object)item.Hole4);
                    SqlParameters[24] = new SqlParameter("@Hole5", (object)item.Hole5);
                    SqlParameters[25] = new SqlParameter("@Hole6", (object)item.Hole6);
                    SqlParameters[26] = new SqlParameter("@LianGrade", (object)item.LianGrade);
                    SqlParameters[27] = new SqlParameter("@LianExp", (object)item.LianExp);
                }
                else
                {
                    SqlParameters[0] = new SqlParameter("@ItemID", (object)item.ItemID);
                    SqlParameters[0].Direction = ParameterDirection.Output;
                    SqlParameters[1] = new SqlParameter("@UserID", (object)item.UserID);
                    SqlParameters[2] = new SqlParameter("@TemplateID", (object)item.Template.TemplateID);
                    SqlParameters[3] = new SqlParameter("@Place", (object)item.Place);
                    SqlParameters[4] = new SqlParameter("@AgilityCompose", (object)item.AgilityCompose);
                    SqlParameters[5] = new SqlParameter("@AttackCompose", (object)item.AttackCompose);
                    SqlParameters[6] = new SqlParameter("@BeginDate", (object)item.BeginDate);
                    SqlParameters[7] = new SqlParameter("@Color", item.Color == null ? (object)"" : (object)item.Color);
                    SqlParameters[8] = new SqlParameter("@Count", (object)item.Count);
                    SqlParameters[9] = new SqlParameter("@DefendCompose", (object)item.DefendCompose);
                    SqlParameters[10] = new SqlParameter("@IsBinds", (object)item.IsBinds);
                    SqlParameters[11] = new SqlParameter("@IsExist", (object)item.IsExist);
                    SqlParameters[12] = new SqlParameter("@IsJudge", (object)item.IsJudge);
                    SqlParameters[13] = new SqlParameter("@LuckCompose", (object)item.LuckCompose);
                    SqlParameters[14] = new SqlParameter("@StrengthenLevel", (object)item.StrengthenLevel);
                    SqlParameters[15] = new SqlParameter("@ValidDate", (object)item.ValidDate);
                    SqlParameters[16] = new SqlParameter("@BagType", (object)item.BagType);
                    SqlParameters[17] = new SqlParameter("@Skin", item.Skin == null ? (object)"" : (object)item.Skin);
                    SqlParameters[18] = new SqlParameter("@IsUsed", (object)item.IsUsed);
                    SqlParameters[19] = new SqlParameter("@RemoveType", (object)item.RemoveType);
                    SqlParameters[20] = new SqlParameter("@Hole1", (object)item.Hole1);
                    SqlParameters[21] = new SqlParameter("@Hole2", (object)item.Hole2);
                    SqlParameters[22] = new SqlParameter("@Hole3", (object)item.Hole3);
                    SqlParameters[23] = new SqlParameter("@Hole4", (object)item.Hole4);
                    SqlParameters[24] = new SqlParameter("@Hole5", (object)item.Hole5);
                    SqlParameters[25] = new SqlParameter("@Hole6", (object)item.Hole6);
                    SqlParameters[26] = new SqlParameter("@StrengthenTimes", (object)item.StrengthenTimes);
                    SqlParameters[27] = new SqlParameter("@Hole5Level", (object)item.Hole5Level);
                    SqlParameters[28] = new SqlParameter("@Hole5Exp", (object)item.Hole5Exp);
                    SqlParameters[29] = new SqlParameter("@Hole6Level", (object)item.Hole6Level);
                    SqlParameters[30] = new SqlParameter("@Hole6Exp", (object)item.Hole6Exp);
                    SqlParameters[31] = new SqlParameter("@IsGold", (object)item.IsGold);
                    SqlParameters[32] = new SqlParameter("@goldValidDate", (object)item.goldValidDate);
                    SqlParameters[33] = new SqlParameter("@StrengthenExp", (object)item.StrengthenExp);
                    SqlParameters[34] = new SqlParameter("@beadExp", (object)item.beadExp);
                    SqlParameters[35] = new SqlParameter("@beadLevel", (object)item.beadLevel);
                    SqlParameters[36] = new SqlParameter("@beadIsLock", (object)item.beadIsLock);
                    SqlParameters[37] = new SqlParameter("@isShowBind", (object)item.isShowBind);
                    SqlParameters[38] = new SqlParameter("@Damage", (object)item.Damage);
                    SqlParameters[39] = new SqlParameter("@Guard", (object)item.Guard);
                    SqlParameters[40] = new SqlParameter("@Blood", (object)item.Blood);
                    SqlParameters[41] = new SqlParameter("@Bless", (object)item.Bless);
                    SqlParameters[42] = new SqlParameter("@goldBeginTime", (object)item.goldBeginTime);
                    SqlParameters[43] = new SqlParameter("@latentEnergyEndTime", (object)item.latentEnergyEndTime);
                    SqlParameters[44] = new SqlParameter("@latentEnergyCurStr", (object)item.latentEnergyCurStr);
                    SqlParameters[45] = new SqlParameter("@latentEnergyNewStr", (object)item.latentEnergyNewStr);
                    SqlParameters[46] = new SqlParameter("@AdvanceDate", (object)item.AdvanceDate);
                    SqlParameters[47] = new SqlParameter("@AvatarActivity", (object)item.AvatarActivity);
                    SqlParameters[48] = new SqlParameter("@goodsLock", (object)item.goodsLock);
                    SqlParameters[49] = new SqlParameter("@MagicAttack", (object)item.MagicAttack);
                    SqlParameters[50] = new SqlParameter("@MagicDefence", (object)item.MagicDefence);
                    SqlParameters[51] = new SqlParameter("@MagicExp", (object)item.MagicExp);
                    SqlParameters[52] = new SqlParameter("@MagicLevel", (object)item.MagicLevel);
                    SqlParameters[53] = new SqlParameter("@curExp", (object)item.curExp);
                    SqlParameters[54] = new SqlParameter("@cellLocked", (object)item.cellLocked);
                }
                sqlParameterArray = SqlParameters;
                flag = this.db.RunProcedure("SP_Users_Items_Add", SqlParameters);
                sqlParameterArray = SqlParameters;
                item.ItemID = (int)SqlParameters[0].Value;
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                string str = "";
                foreach (SqlParameter sqlParameter in sqlParameterArray)
                    str = str + string.Format("@{0} = '{1}',", (object)sqlParameter.ParameterName, sqlParameter.Value) + "\r\n";
                Logger.Error("query " + str);
                Logger.Error("AddGoods " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateGoods(SqlDataProvider.Data.ItemInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[56];
                if (this.Version == "3.6")
                    SqlParameters = new SqlParameter[35]
                    {
            new SqlParameter("@ItemID", (object) item.ItemID),
            new SqlParameter("@UserID", (object) item.UserID),
            new SqlParameter("@TemplateID", (object) item.TemplateID),
            new SqlParameter("@Place", (object) item.Place),
            new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
            new SqlParameter("@AttackCompose", (object) item.AttackCompose),
            new SqlParameter("@BeginDate", (object) item.BeginDate),
            new SqlParameter("@Color", item.Color == null ? (object) "" : (object) item.Color),
            new SqlParameter("@Count", (object) item.Count),
            new SqlParameter("@DefendCompose", (object) item.DefendCompose),
            new SqlParameter("@IsBinds", (object) item.IsBinds),
            new SqlParameter("@IsExist", (object) item.IsExist),
            new SqlParameter("@IsJudge", (object) item.IsJudge),
            new SqlParameter("@LuckCompose", (object) item.LuckCompose),
            new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
            new SqlParameter("@ValidDate", (object) item.ValidDate),
            new SqlParameter("@BagType", (object) item.BagType),
            new SqlParameter("@Skin", (object) item.Skin),
            new SqlParameter("@IsUsed", (object) item.IsUsed),
            new SqlParameter("@RemoveDate", (object) item.RemoveDate),
            new SqlParameter("@RemoveType", (object) item.RemoveType),
            new SqlParameter("@Hole1", (object) item.Hole1),
            new SqlParameter("@Hole2", (object) item.Hole2),
            new SqlParameter("@Hole3", (object) item.Hole3),
            new SqlParameter("@Hole4", (object) item.Hole4),
            new SqlParameter("@Hole5", (object) item.Hole5),
            new SqlParameter("@Hole6", (object) item.Hole6),
            new SqlParameter("@LianGrade", (object) item.goldValidDate),
            new SqlParameter("@LianExp", (object) item.goldValidDate),
            new SqlParameter("@Hole5Level", (object) item.Hole5Level),
            new SqlParameter("@Hole5Exp", (object) item.Hole5Exp),
            new SqlParameter("@Hole6Level", (object) item.Hole6Level),
            new SqlParameter("@Hole6Exp", (object) item.Hole6Exp),
            new SqlParameter("@goldBeginTime", (object) item.goldBeginTime),
            new SqlParameter("@goldValidDate", (object) item.goldValidDate)
                    };
                if (this.Version == "3.4")
                {
                    SqlParameters = new SqlParameter[29]
                    {
            new SqlParameter("@ItemID", (object) item.ItemID),
            new SqlParameter("@UserID", (object) item.UserID),
            new SqlParameter("@TemplateID", (object) item.TemplateID),
            new SqlParameter("@Place", (object) item.Place),
            new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
            new SqlParameter("@AttackCompose", (object) item.AttackCompose),
            new SqlParameter("@BeginDate", (object) item.BeginDate),
            new SqlParameter("@Color", item.Color == null ? (object) "" : (object) item.Color),
            new SqlParameter("@Count", (object) item.Count),
            new SqlParameter("@DefendCompose", (object) item.DefendCompose),
            new SqlParameter("@IsBinds", (object) item.IsBinds),
            new SqlParameter("@IsExist", (object) item.IsExist),
            new SqlParameter("@IsJudge", (object) item.IsJudge),
            new SqlParameter("@LuckCompose", (object) item.LuckCompose),
            new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
            new SqlParameter("@ValidDate", (object) item.ValidDate),
            new SqlParameter("@BagType", (object) item.BagType),
            new SqlParameter("@Skin", (object) item.Skin),
            new SqlParameter("@IsUsed", (object) item.IsUsed),
            new SqlParameter("@RemoveDate", (object) item.RemoveDate),
            new SqlParameter("@RemoveType", (object) item.RemoveType),
            new SqlParameter("@Hole1", (object) item.Hole1),
            new SqlParameter("@Hole2", (object) item.Hole2),
            new SqlParameter("@Hole3", (object) item.Hole3),
            new SqlParameter("@Hole4", (object) item.Hole4),
            new SqlParameter("@Hole5", (object) item.Hole5),
            new SqlParameter("@Hole6", (object) item.Hole6),
            new SqlParameter("@LianGrade", (object) item.LianGrade),
            new SqlParameter("@LianExp", (object) item.LianExp)
                    };
                }
                else
                {
                    SqlParameters[0] = new SqlParameter("@ItemID", (object)item.ItemID);
                    SqlParameters[1] = new SqlParameter("@UserID", (object)item.UserID);
                    SqlParameters[2] = new SqlParameter("@TemplateID", (object)item.TemplateID);
                    SqlParameters[3] = new SqlParameter("@Place", (object)item.Place);
                    SqlParameters[4] = new SqlParameter("@AgilityCompose", (object)item.AgilityCompose);
                    SqlParameters[5] = new SqlParameter("@AttackCompose", (object)item.AttackCompose);
                    SqlParameters[6] = new SqlParameter("@BeginDate", (object)item.BeginDate);
                    SqlParameters[7] = new SqlParameter("@Color", item.Color == null ? (object)"" : (object)item.Color);
                    SqlParameters[8] = new SqlParameter("@Count", (object)item.Count);
                    SqlParameters[9] = new SqlParameter("@DefendCompose", (object)item.DefendCompose);
                    SqlParameters[10] = new SqlParameter("@IsBinds", (object)item.IsBinds);
                    SqlParameters[11] = new SqlParameter("@IsExist", (object)item.IsExist);
                    SqlParameters[12] = new SqlParameter("@IsJudge", (object)item.IsJudge);
                    SqlParameters[13] = new SqlParameter("@LuckCompose", (object)item.LuckCompose);
                    SqlParameters[14] = new SqlParameter("@StrengthenLevel", (object)item.StrengthenLevel);
                    SqlParameters[15] = new SqlParameter("@ValidDate", (object)item.ValidDate);
                    SqlParameters[16] = new SqlParameter("@BagType", (object)item.BagType);
                    SqlParameters[17] = new SqlParameter("@Skin", (object)item.Skin);
                    SqlParameters[18] = new SqlParameter("@IsUsed", (object)item.IsUsed);
                    SqlParameters[19] = new SqlParameter("@RemoveDate", (object)item.RemoveDate);
                    SqlParameters[20] = new SqlParameter("@RemoveType", (object)item.RemoveType);
                    SqlParameters[21] = new SqlParameter("@Hole1", (object)item.Hole1);
                    SqlParameters[22] = new SqlParameter("@Hole2", (object)item.Hole2);
                    SqlParameters[23] = new SqlParameter("@Hole3", (object)item.Hole3);
                    SqlParameters[24] = new SqlParameter("@Hole4", (object)item.Hole4);
                    SqlParameters[25] = new SqlParameter("@Hole5", (object)item.Hole5);
                    SqlParameters[26] = new SqlParameter("@Hole6", (object)item.Hole6);
                    SqlParameters[27] = new SqlParameter("@StrengthenTimes", (object)item.StrengthenTimes);
                    SqlParameters[28] = new SqlParameter("@Hole5Level", (object)item.Hole5Level);
                    SqlParameters[29] = new SqlParameter("@Hole5Exp", (object)item.Hole5Exp);
                    SqlParameters[30] = new SqlParameter("@Hole6Level", (object)item.Hole6Level);
                    SqlParameters[31] = new SqlParameter("@Hole6Exp", (object)item.Hole6Exp);
                    SqlParameters[32] = new SqlParameter("@IsGold", (object)item.IsGold);
                    SqlParameters[33] = new SqlParameter("@goldBeginTime", (object)item.goldBeginTime.ToString());
                    SqlParameters[34] = new SqlParameter("@goldValidDate", (object)item.goldValidDate);
                    SqlParameters[35] = new SqlParameter("@StrengthenExp", (object)item.StrengthenExp);
                    SqlParameters[36] = new SqlParameter("@beadExp", (object)item.beadExp);
                    SqlParameters[37] = new SqlParameter("@beadLevel", (object)item.beadLevel);
                    SqlParameters[38] = new SqlParameter("@beadIsLock", (object)item.beadIsLock);
                    SqlParameters[39] = new SqlParameter("@isShowBind", (object)item.isShowBind);
                    SqlParameters[40] = new SqlParameter("@latentEnergyCurStr", (object)item.latentEnergyCurStr);
                    SqlParameters[41] = new SqlParameter("@latentEnergyNewStr", (object)item.latentEnergyNewStr);
                    SqlParameters[42] = new SqlParameter("@latentEnergyEndTime", (object)item.latentEnergyEndTime.ToString());
                    SqlParameters[43] = new SqlParameter("@Damage", (object)item.Damage);
                    SqlParameters[44] = new SqlParameter("@Guard", (object)item.Guard);
                    SqlParameters[45] = new SqlParameter("@Blood", (object)item.Blood);
                    SqlParameters[46] = new SqlParameter("@Bless", (object)item.Bless);
                    SqlParameters[47] = new SqlParameter("@AdvanceDate", (object)item.AdvanceDate);
                    SqlParameters[48] = new SqlParameter("@AvatarActivity", (object)item.AvatarActivity);
                    SqlParameters[49] = new SqlParameter("@goodsLock", (object)item.goodsLock);
                    SqlParameters[50] = new SqlParameter("@MagicAttack", (object)item.MagicAttack);
                    SqlParameters[51] = new SqlParameter("@MagicDefence", (object)item.MagicDefence);
                    SqlParameters[52] = new SqlParameter("@MagicExp", (object)item.MagicExp);
                    SqlParameters[53] = new SqlParameter("@MagicLevel", (object)item.MagicLevel);
                    SqlParameters[54] = new SqlParameter("@curExp", (object)item.curExp);
                    SqlParameters[55] = new SqlParameter("@cellLocked", (object)item.cellLocked);
                }
                flag = this.db.RunProcedure("SP_Users_Items_Update", SqlParameters);
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllConsortia " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteGoods(int itemID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE dbo.[Sys_Users_Goods] WHERE ItemID = " + itemID.ToString());
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteGoods " + ex.ToString());
            }
            return flag;
        }

        public ConsortiaInfo[] GetAllConsortia(
          string swhere,
          int currentPageIndex,
          int pagesize,
          ref int totalCount)
        {
            List<ConsortiaInfo> consortiaInfoList = new List<ConsortiaInfo>();
            try
            {
                foreach (DataRow row in (InternalDataCollectionBase)this.GetPage("Consortia", swhere, currentPageIndex + 1, pagesize, "*", " ConsortiaID ", "ConsortiaID", ref totalCount).Rows)
                    consortiaInfoList.Add(this.InitDataRow<ConsortiaInfo>(row));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllConsortia " + ex.ToString());
            }
            return consortiaInfoList.ToArray();
        }

        public ConsortiaInfo InitConsortia(DataRow reader) => new ConsortiaInfo()
        {
            ConsortiaID = (int)reader["ConsortiaID"],
            ConsortiaName = reader["ConsortiaName"] == null ? "" : reader["ConsortiaName"].ToString(),
            Honor = (int)reader["Honor"],
            CreatorID = (int)reader["CreatorID"],
            CreatorName = reader["CreatorName"] == null ? "" : reader["CreatorName"].ToString(),
            ChairmanID = (int)reader["ChairmanID"],
            ChairmanName = reader["ChairmanName"] == null ? "" : reader["ChairmanName"].ToString(),
            Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
            Placard = reader["Placard"] == null ? "" : reader["Placard"].ToString(),
            Level = (int)reader["Level"],
            MaxCount = (int)reader["MaxCount"],
            CelebCount = (int)reader["CelebCount"],
            BuildDate = (DateTime)reader["BuildDate"],
            Repute = (int)reader["Repute"],
            Count = (int)reader["Count"],
            IP = reader["IP"] == null ? "" : reader["IP"].ToString(),
            Port = (int)reader["Port"],
            IsExist = (bool)reader["IsExist"],
            Riches = (int)reader["Riches"],
            DeductDate = (DateTime)reader["DeductDate"],
            LastDayRiches = (int)reader["LastDayRiches"],
            AddDayRiches = (int)reader["AddDayRiches"],
            AddWeekRiches = (int)reader["AddWeekRiches"],
            AddDayHonor = (int)reader["AddDayHonor"],
            AddWeekHonor = (int)reader["AddWeekHonor"],
            OpenApply = (bool)reader["OpenApply"],
            StoreLevel = (int)reader["StoreLevel"],
            SmithLevel = (int)reader["SmithLevel"],
            ShopLevel = (int)reader["ShopLevel"],
            SkillLevel = (int)reader["SkillLevel"],
            FightPower = Convert.ToInt64(reader["FightPower"]),
            BadgeType = (int)reader["BadgeType"],
            BadgeName = reader["BadgeName"] == null ? "" : reader["BadgeName"].ToString(),
            BadgeID = (int)reader["BadgeID"],
            BadgeBuyTime = reader["BadgeBuyTime"] == null ? "" : reader["BadgeBuyTime"].ToString(),
            ValidDate = (int)reader["ValidDate"],
            IsVoting = (bool)reader["IsVoting"],
            VoteRemainDay = (int)reader["VoteRemainDay"],
            LastOpenBoss = (DateTime)reader["LastOpenBoss"],
            extendAvailableNum = (int)reader["extendAvailableNum"]
        };

        public PlayerInfo GetUserSingleByUserID(int UserID)
        {
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[V_Sys_Users_Detail] WHERE  UserID = " + (object)UserID);
                if (Sdr.Read())
                    return this.InitDataReader<PlayerInfo>(Sdr);
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPlayer " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return (PlayerInfo)null;
        }

        public MinorPlayerInfo[] GetAllPlayer(
          int currentPageIndex,
          int pagesize,
          string keys,
          ref int totalCount)
        {
            List<MinorPlayerInfo> minorPlayerInfoList = new List<MinorPlayerInfo>();
            try
            {
                string fdShow = "[UserID],[UserName],[NickName]";
                string queryWhere = "IsExist = 1";
                if (!string.IsNullOrWhiteSpace(keys))
                    queryWhere = "IsExist = 1 AND (CAST (UserID AS NVARCHAR(150)) LIKE N'%" + keys + "%' OR NickName LIKE N'%" + keys + "%' OR UserName LIKE N'%" + keys + "%')";
                foreach (DataRow row in (InternalDataCollectionBase)this.GetPage("V_Sys_Users_Detail", queryWhere, currentPageIndex, pagesize, fdShow, " UserID ", "UserID", ref totalCount).Rows)
                {
                    MinorPlayerInfo minorPlayerInfo = new MinorPlayerInfo()
                    {
                        ID = (int)row["UserID"],
                        UserName = row["UserName"] == null ? "" : row["UserName"].ToString(),
                        NickName = row["NickName"] == null ? "" : row["NickName"].ToString()
                    };
                    minorPlayerInfoList.Add(minorPlayerInfo);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPlayer " + ex.ToString());
            }
            return minorPlayerInfoList.ToArray();
        }

        public PlayerInfo[] GetAllPlayer(
          string swhere,
          int currentPageIndex,
          int pagesize,
          ref int totalCount)
        {
            List<PlayerInfo> playerInfoList = new List<PlayerInfo>();
            try
            {
                foreach (DataRow row in (InternalDataCollectionBase)this.GetPage("V_Sys_Users_Detail", swhere, currentPageIndex + 1, pagesize, "*", " UserID ", "UserID", ref totalCount).Rows)
                    playerInfoList.Add(this.InitDataRow<PlayerInfo>(row));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPlayer " + ex.ToString());
            }
            return playerInfoList.ToArray();
        }

        public bool UpdateEditable(string column, string val, int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Sys_Users_Detail] SET [" + column + "] = @" + column + " WHERE UserID = @UserID", new SqlParameter[2]
                {
          new SqlParameter("@UserID", (object) id),
          new SqlParameter("@" + column, (object) val)
                });
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message);
            }
            return flag;
        }

        public UsersExtraInfo GetSigleUsersExtra(string swhere)
        {
            List<UsersExtraInfo> usersExtraInfoList = new List<UsersExtraInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Sys_Users_Extra] WHERE " + swhere);
                while (Sdr.Read())
                    usersExtraInfoList.Add(this.InitUsersExtraInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleUsersExtra " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return usersExtraInfoList.Count > 0 ? usersExtraInfoList[0] : (UsersExtraInfo)null;
        }

        public UsersExtraInfo InitUsersExtraInfo(SqlDataReader reader) => new UsersExtraInfo()
        {
            ID = (int)reader["ID"],
            UserID = (int)reader["UserID"],
            starlevel = (int)reader["starlevel"],
            nowPosition = (int)reader["nowPosition"],
            FreeCount = (int)reader["FreeCount"],
            SearchGoodItems = reader["SearchGoodItems"] == null ? "" : reader["SearchGoodItems"].ToString(),
            FreeAddAutionCount = (int)reader["FreeAddAutionCount"],
            FreeSendMailCount = (int)reader["FreeSendMailCount"],
            KingBlessInfo = reader["KingBlessInfo"] == null ? "" : reader["KingBlessInfo"].ToString(),
            MissionEnergy = (int)reader["MissionEnergy"],
            buyEnergyCount = (int)reader["buyEnergyCount"],
            KingBlessEnddate = (DateTime)reader["KingBlessEnddate"],
            KingBlessIndex = (int)reader["KingBlessIndex"],
            DressModelArr = reader["DressModelArr"] == null ? "" : reader["DressModelArr"].ToString(),
            CurentDressModel = (int)reader["CurentDressModel"],
            ScoreMagicstone = (int)reader["ScoreMagicstone"],
            DeedInfo = reader["DeedInfo"] == null ? "" : reader["DeedInfo"].ToString(),
            DeedEnddate = (DateTime)reader["DeedEnddate"],
            DeedIndex = (int)reader["DeedIndex"],
            Score = (int)reader["Score"],
            SummerScore = (int)reader["SummerScore"],
            CatchInsectGetPrize = reader["CatchInsectGetPrize"] == null ? "" : reader["CatchInsectGetPrize"].ToString(),
            PrizeStatus = (int)reader["PrizeStatus"],
            CakeStatus = (bool)reader["CakeStatus"],
            NormalFightNum = (int)reader["NormalFightNum"],
            HardFightNum = (int)reader["HardFightNum"],
            IsDoubleScore = (bool)reader["IsDoubleScore"],
            MagpieBridgeItems = reader["MagpieBridgeItems"] == null ? "" : reader["MagpieBridgeItems"].ToString(),
            NowPositionMB = (int)reader["NowPositionMB"],
            LastNum = (int)reader["LastNum"],
            MagpieNum = (int)reader["MagpieNum"],
            FreePresentGoodsCount = (int)reader["FreePresentGoodsCount"]
        };

        public bool UpdateUsersExtra(UsersExtraInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Sys_Users_Extra]\r\n                               SET [UserID] = @UserID\r\n                                  ,[starlevel] = @starlevel\r\n                                  ,[nowPosition] = @nowPosition\r\n                                  ,[FreeCount] = @FreeCount\r\n                                  ,[SearchGoodItems] = @SearchGoodItems\r\n                                  ,[FreeAddAutionCount] = @FreeAddAutionCount\r\n                                  ,[FreeSendMailCount] = @FreeSendMailCount\r\n                                  ,[KingBlessInfo] = @KingBlessInfo\r\n                                  ,[MissionEnergy] = @MissionEnergy\r\n                                  ,[buyEnergyCount] = @buyEnergyCount\r\n                                  ,[KingBlessEnddate] = @KingBlessEnddate\r\n                                  ,[KingBlessIndex] = @KingBlessIndex\r\n                                  ,[DressModelArr] = @DressModelArr\r\n                                  ,[CurentDressModel] = @CurentDressModel\r\n                                  ,[ScoreMagicstone] = @ScoreMagicstone\r\n                                  ,[DeedInfo] = @DeedInfo\r\n                                  ,[DeedEnddate] = @DeedEnddate\r\n                                  ,[DeedIndex] = @DeedIndex\r\n                                  ,[Score] = @Score\r\n                                  ,[SummerScore] = @SummerScore\r\n                                  ,[CatchInsectGetPrize] = @CatchInsectGetPrize\r\n                                  ,[PrizeStatus] = @PrizeStatus\r\n                                  ,[CakeStatus] = @CakeStatus\r\n                                  ,[NormalFightNum] = @NormalFightNum\r\n                                  ,[HardFightNum] = @HardFightNum\r\n                                  ,[IsDoubleScore] = @IsDoubleScore\r\n                                  ,[MagpieBridgeItems] = @MagpieBridgeItems\r\n                                  ,[NowPositionMB] = @NowPositionMB\r\n                                  ,[LastNum] = @LastNum\r\n                                  ,[MagpieNum] = @MagpieNum\r\n                                  ,[FreePresentGoodsCount] = @FreePresentGoodsCount\r\n                            WHERE [ID] = @ID", new SqlParameter[32]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@starlevel", (object) item.starlevel),
          new SqlParameter("@nowPosition", (object) item.nowPosition),
          new SqlParameter("@FreeCount", (object) item.FreeCount),
          new SqlParameter("@SearchGoodItems", (object) item.SearchGoodItems),
          new SqlParameter("@FreeAddAutionCount", (object) item.FreeAddAutionCount),
          new SqlParameter("@FreeSendMailCount", (object) item.FreeSendMailCount),
          new SqlParameter("@KingBlessInfo", (object) item.KingBlessInfo),
          new SqlParameter("@MissionEnergy", (object) item.MissionEnergy),
          new SqlParameter("@buyEnergyCount", (object) item.buyEnergyCount),
          new SqlParameter("@KingBlessEnddate", (object) item.KingBlessEnddate),
          new SqlParameter("@KingBlessIndex", (object) item.KingBlessIndex),
          new SqlParameter("@DressModelArr", (object) item.DressModelArr),
          new SqlParameter("@CurentDressModel", (object) item.CurentDressModel),
          new SqlParameter("@ScoreMagicstone", (object) item.ScoreMagicstone),
          new SqlParameter("@DeedInfo", (object) item.DeedInfo),
          new SqlParameter("@DeedEnddate", (object) item.DeedEnddate),
          new SqlParameter("@DeedIndex", (object) item.DeedIndex),
          new SqlParameter("@Score", (object) item.Score),
          new SqlParameter("@SummerScore", (object) item.SummerScore),
          new SqlParameter("@CatchInsectGetPrize", (object) item.CatchInsectGetPrize),
          new SqlParameter("@PrizeStatus", (object) item.PrizeStatus),
          new SqlParameter("@CakeStatus", (object) item.CakeStatus),
          new SqlParameter("@NormalFightNum", (object) item.NormalFightNum),
          new SqlParameter("@HardFightNum", (object) item.HardFightNum),
          new SqlParameter("@IsDoubleScore", (object) item.IsDoubleScore),
          new SqlParameter("@MagpieBridgeItems", (object) item.MagpieBridgeItems),
          new SqlParameter("@NowPositionMB", (object) item.NowPositionMB),
          new SqlParameter("@LastNum", (object) item.LastNum),
          new SqlParameter("@MagpieNum", (object) item.MagpieNum),
          new SqlParameter("@FreePresentGoodsCount", (object) item.FreePresentGoodsCount)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateUsersExtra: " + ex.ToString());
            }
            return flag;
        }

        public ActiveSystemInfo GetSigleActiveSystem(string where)
        {
            List<ActiveSystemInfo> activeSystemInfoList = new List<ActiveSystemInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Sys_Active_System_Data] WHERE " + where);
                while (Sdr.Read())
                    activeSystemInfoList.Add(this.InitActiveSystemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleActiveSystem " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeSystemInfoList.Count > 0 ? activeSystemInfoList[0] : (ActiveSystemInfo)null;
        }

        public ActiveSystemInfo InitActiveSystemInfo(SqlDataReader reader) => new ActiveSystemInfo()
        {
            ID = (int)reader["ID"],
            UserID = (int)reader["UserID"],
            useableScore = (int)reader["useableScore"],
            totalScore = (int)reader["totalScore"],
            AvailTime = (int)reader["AvailTime"],
            NickName = reader["NickName"] == null ? "" : reader["NickName"].ToString(),
            dayScore = (int)reader["dayScore"],
            CanGetGift = (bool)reader["CanGetGift"],
            canOpenCounts = (int)reader["canOpenCounts"],
            canEagleEyeCounts = (int)reader["canEagleEyeCounts"],
            lastFlushTime = (DateTime)reader["lastFlushTime"],
            isShowAll = (bool)reader["isShowAll"],
            ActiveMoney = (int)reader["AvtiveMoney"],
            activityTanabataNum = (int)reader["activityTanabataNum"],
            ChallengeNum = (int)reader["ChallengeNum"],
            BuyBuffNum = (int)reader["BuyBuffNum"],
            lastEnterYearMonter = (DateTime)reader["lastEnterYearMonter"],
            DamageNum = (int)reader["DamageNum"],
            BoxState = reader["BoxState"] == null ? "" : reader["BoxState"].ToString(),
            LuckystarCoins = (int)reader["LuckystarCoins"],
            CryptBoss = reader["CryptBoss"] == null ? "" : reader["CryptBoss"].ToString(),
            DDPlayPoint = (int)reader["DDPlayPoint"],
            updateFreeCounts = (int)reader["updateFreeCounts"],
            updateWorshipedCounts = (int)reader["updateWorshipedCounts"],
            update200State = (int)reader["update200State"],
            lastEnterWorshiped = (DateTime)reader["lastEnterWorshiped"],
            luckCount = (int)reader["luckCount"],
            remainTimes = (int)reader["remainTimes"],
            LastRefresh = (DateTime)reader["LastRefresh"],
            CurRefreshedTimes = (int)reader["CurRefreshedTimes"],
            EntertamentPoint = (int)reader["EntertamentPoint"],
            ChickActiveData = reader["ChickActiveData"] == null ? "" : reader["ChickActiveData"].ToString()
        };

        public bool UpdateActiveSystem(ActiveSystemInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Sys_Active_System_Data]\r\n                               SET [UserID] = @UserID\r\n                                  ,[useableScore] = @useableScore\r\n                                  ,[totalScore] = @totalScore\r\n                                  ,[AvailTime] = @AvailTime\r\n                                  ,[NickName] = @NickName\r\n                                  ,[dayScore] = @dayScore\r\n                                  ,[CanGetGift] = @CanGetGift\r\n                                  ,[canOpenCounts] = @canOpenCounts\r\n                                  ,[canEagleEyeCounts] = @canEagleEyeCounts\r\n                                  ,[lastFlushTime] = @lastFlushTime\r\n                                  ,[isShowAll] = @isShowAll\r\n                                  ,[AvtiveMoney] = @AvtiveMoney\r\n                                  ,[activityTanabataNum] = @activityTanabataNum\r\n                                  ,[ChallengeNum] = @ChallengeNum\r\n                                  ,[BuyBuffNum] = @BuyBuffNum\r\n                                  ,[lastEnterYearMonter] = @lastEnterYearMonter\r\n                                  ,[DamageNum] = @DamageNum\r\n                                  ,[BoxState] = @BoxState\r\n                                  ,[LuckystarCoins] = @LuckystarCoins\r\n                                  ,[CryptBoss] = @CryptBoss\r\n                                  ,[DDPlayPoint] = @DDPlayPoint\r\n                                  ,[updateFreeCounts] = @updateFreeCounts\r\n                                  ,[updateWorshipedCounts] = @updateWorshipedCounts\r\n                                  ,[update200State] = @update200State\r\n                                  ,[lastEnterWorshiped] = @lastEnterWorshiped\r\n                                  ,[luckCount] = @luckCount\r\n                                  ,[remainTimes] = @remainTimes\r\n                                  ,[LastRefresh] = @LastRefresh\r\n                                  ,[CurRefreshedTimes] = @CurRefreshedTimes\r\n                                  ,[EntertamentPoint] = @EntertamentPoint\r\n                                  ,[ChickActiveData] = @ChickActiveData\r\n                            WHERE [ID] = @ID", new SqlParameter[32]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@useableScore", (object) item.useableScore),
          new SqlParameter("@totalScore", (object) item.totalScore),
          new SqlParameter("@AvailTime", (object) item.AvailTime),
          new SqlParameter("@NickName", (object) item.NickName),
          new SqlParameter("@dayScore", (object) item.dayScore),
          new SqlParameter("@CanGetGift", (object) item.CanGetGift),
          new SqlParameter("@canOpenCounts", (object) item.canOpenCounts),
          new SqlParameter("@canEagleEyeCounts", (object) item.canEagleEyeCounts),
          new SqlParameter("@lastFlushTime", (object) item.lastFlushTime),
          new SqlParameter("@isShowAll", (object) item.isShowAll),
          new SqlParameter("@AvtiveMoney", (object) item.ActiveMoney),
          new SqlParameter("@activityTanabataNum", (object) item.activityTanabataNum),
          new SqlParameter("@ChallengeNum", (object) item.ChallengeNum),
          new SqlParameter("@BuyBuffNum", (object) item.BuyBuffNum),
          new SqlParameter("@lastEnterYearMonter", (object) item.lastEnterYearMonter),
          new SqlParameter("@DamageNum", (object) item.DamageNum),
          new SqlParameter("@BoxState", (object) item.BoxState),
          new SqlParameter("@LuckystarCoins", (object) item.LuckystarCoins),
          new SqlParameter("@CryptBoss", (object) item.CryptBoss),
          new SqlParameter("@DDPlayPoint", (object) item.DDPlayPoint),
          new SqlParameter("@updateFreeCounts", (object) item.updateFreeCounts),
          new SqlParameter("@updateWorshipedCounts", (object) item.updateWorshipedCounts),
          new SqlParameter("@update200State", (object) item.update200State),
          new SqlParameter("@lastEnterWorshiped", (object) item.lastEnterWorshiped),
          new SqlParameter("@luckCount", (object) item.luckCount),
          new SqlParameter("@remainTimes", (object) item.remainTimes),
          new SqlParameter("@LastRefresh", (object) item.LastRefresh),
          new SqlParameter("@CurRefreshedTimes", (object) item.CurRefreshedTimes),
          new SqlParameter("@EntertamentPoint", (object) item.EntertamentPoint),
          new SqlParameter("@ChickActiveData", (object) item.ChickActiveData)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateActiveSystem: " + ex.ToString());
            }
            return flag;
        }

        private bool ForbidPlayer(
          string userName,
          string nickName,
          int userID,
          int zoneId,
          DateTime forbidDate,
          bool isExist)
        {
            return this.ForbidPlayer(userName, nickName, userID, zoneId, forbidDate, isExist, "");
        }

        private bool ForbidPlayer(
          string userName,
          string nickName,
          int userID,
          int zoneId,
          DateTime forbidDate,
          bool isExist,
          string ForbidReason)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[6]
                {
          new SqlParameter("@UserName", (object) userName),
          new SqlParameter("@NickName", (object) nickName),
          new SqlParameter("@UserID", (object) userID),
          null,
          null,
          null
                };
                SqlParameters[2].Direction = ParameterDirection.InputOutput;
                SqlParameters[3] = new SqlParameter("@ForbidDate", (object)forbidDate);
                SqlParameters[4] = new SqlParameter("@IsExist", (object)isExist);
                SqlParameters[5] = new SqlParameter("@ForbidReason", (object)ForbidReason);
                this.db.RunProcedure("SP_Admin_ForbidUser", SqlParameters);
                userID = (int)SqlParameters[2].Value;
                if (userID > 0)
                {
                    flag = true;
                    if (!isExist)
                        GameService.KickPlayer(userID, zoneId, "kick by GM!!");
                }
            }
            catch (Exception ex)
            {
                Logger.Error("ForbidPlayer: " + ex.ToString());
            }
            return flag;
        }

        public bool ForbidPlayerByUserName(string userName, int zoneId, DateTime date, bool isExist) => this.ForbidPlayer(userName, "", 0, zoneId, date, isExist);

        public bool ForbidPlayerByNickName(string nickName, int zoneId, DateTime date, bool isExist) => this.ForbidPlayer("", nickName, 0, zoneId, date, isExist);

        public bool ForbidPlayerByUserID(int userID, int zoneId, DateTime date, bool isExist) => this.ForbidPlayer("", "", userID, zoneId, date, isExist);

        public bool ForbidPlayerByUserName(
          string userName,
          int zoneId,
          DateTime date,
          bool isExist,
          string ForbidReason)
        {
            return this.ForbidPlayer(userName, "", 0, zoneId, date, isExist, ForbidReason);
        }

        public bool ForbidPlayerByNickName(
          string nickName,
          int zoneId,
          DateTime date,
          bool isExist,
          string ForbidReason)
        {
            return this.ForbidPlayer("", nickName, 0, zoneId, date, isExist, ForbidReason);
        }

        public bool ForbidPlayerByUserID(
          int userID,
          int zoneId,
          DateTime date,
          bool isExist,
          string ForbidReason)
        {
            return this.ForbidPlayer("", "", userID, zoneId, date, isExist, ForbidReason);
        }

        public bool SendMail(MailInfo mail, int zoneId)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[29];
                SqlParameters[0] = new SqlParameter("@ID", (object)mail.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Annex1", mail.Annex1 == null ? (object)"" : (object)mail.Annex1);
                SqlParameters[2] = new SqlParameter("@Annex2", mail.Annex2 == null ? (object)"" : (object)mail.Annex2);
                SqlParameters[3] = new SqlParameter("@Content", mail.Content == null ? (object)"" : (object)mail.Content);
                SqlParameters[4] = new SqlParameter("@Gold", (object)mail.Gold);
                SqlParameters[5] = new SqlParameter("@IsExist", (object)true);
                SqlParameters[6] = new SqlParameter("@Money", (object)mail.Money);
                SqlParameters[7] = new SqlParameter("@Receiver", mail.Receiver == null ? (object)"" : (object)mail.Receiver);
                SqlParameters[8] = new SqlParameter("@ReceiverID", (object)mail.ReceiverID);
                SqlParameters[9] = new SqlParameter("@Sender", mail.Sender == null ? (object)"" : (object)mail.Sender);
                SqlParameters[10] = new SqlParameter("@SenderID", (object)mail.SenderID);
                SqlParameters[11] = new SqlParameter("@Title", mail.Title == null ? (object)"" : (object)mail.Title);
                SqlParameters[12] = new SqlParameter("@IfDelS", (object)false);
                SqlParameters[13] = new SqlParameter("@IsDelete", (object)false);
                SqlParameters[14] = new SqlParameter("@IsDelR", (object)false);
                SqlParameters[15] = new SqlParameter("@IsRead", (object)false);
                SqlParameters[16] = new SqlParameter("@SendTime", (object)DateTime.Now);
                SqlParameters[17] = new SqlParameter("@Type", (object)mail.Type);
                SqlParameters[18] = new SqlParameter("@Annex1Name", mail.Annex1Name == null ? (object)"" : (object)mail.Annex1Name);
                SqlParameters[19] = new SqlParameter("@Annex2Name", mail.Annex2Name == null ? (object)"" : (object)mail.Annex2Name);
                SqlParameters[20] = new SqlParameter("@Annex3", mail.Annex3 == null ? (object)"" : (object)mail.Annex3);
                SqlParameters[21] = new SqlParameter("@Annex4", mail.Annex4 == null ? (object)"" : (object)mail.Annex4);
                SqlParameters[22] = new SqlParameter("@Annex5", mail.Annex5 == null ? (object)"" : (object)mail.Annex5);
                SqlParameters[23] = new SqlParameter("@Annex3Name", mail.Annex3Name == null ? (object)"" : (object)mail.Annex3Name);
                SqlParameters[24] = new SqlParameter("@Annex4Name", mail.Annex4Name == null ? (object)"" : (object)mail.Annex4Name);
                SqlParameters[25] = new SqlParameter("@Annex5Name", mail.Annex5Name == null ? (object)"" : (object)mail.Annex5Name);
                SqlParameters[26] = new SqlParameter("@ValidDate", (object)mail.ValidDate);
                SqlParameters[27] = new SqlParameter("@AnnexRemark", mail.AnnexRemark == null ? (object)"" : (object)mail.AnnexRemark);
                SqlParameters[28] = new SqlParameter("GiftToken", (object)mail.GiftToken);
                flag = this.db.RunProcedure("SP_Mail_Send", SqlParameters);
                mail.ID = (int)SqlParameters[0].Value;
                GameService.MailNotice(mail.ReceiverID, zoneId);
            }
            catch (Exception ex)
            {
                Logger.Error("SendMail: " + ex.ToString());
            }
            finally
            {
            }
            return flag;
        }
    }
}
