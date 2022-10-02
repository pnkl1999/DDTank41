using Helpers;
using SqlDataProvider.BaseClass;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace Tank.Data
{
    public class ServerBussiness : BaseBussiness
    {
        public ServerBussiness() => this.db = new Sql_DbObject("WebConfig", "crosszoneString");

        public SqlDataProvider.Data.ServerInfo[] GetAllServer()
        {
            List<SqlDataProvider.Data.ServerInfo> serverInfoList = new List<SqlDataProvider.Data.ServerInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Server_List]");
                while (Sdr.Read())
                    serverInfoList.Add(this.InitServerInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllServer " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return serverInfoList.ToArray();
        }

        public SqlDataProvider.Data.ServerInfo[] GetAllServerByZone(int id)
        {
            List<SqlDataProvider.Data.ServerInfo> serverInfoList = new List<SqlDataProvider.Data.ServerInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Server_List] WHERE [ZoneId] = " + id.ToString());
                while (Sdr.Read())
                    serverInfoList.Add(this.InitServerInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllServerBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return serverInfoList.ToArray();
        }

        public SqlDataProvider.Data.ServerInfo GetSingleServer(int id, int port)
        {
            List<SqlDataProvider.Data.ServerInfo> serverInfoList = new List<SqlDataProvider.Data.ServerInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Server_List] WHERE ID = " + (object)id + " OR Port = " + (object)port);
                while (Sdr.Read())
                    serverInfoList.Add(this.InitServerInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleServer " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return serverInfoList.Count > 0 ? serverInfoList[0] : (SqlDataProvider.Data.ServerInfo)null;
        }

        public SqlDataProvider.Data.ServerInfo InitServerInfo(SqlDataReader reader) => new SqlDataProvider.Data.ServerInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            IP = reader["IP"] == null ? "" : reader["IP"].ToString(),
            Port = (int)reader["Port"],
            State = (int)reader["State"],
            Online = (int)reader["Online"],
            Total = (int)reader["Total"],
            Room = (int)reader["Room"],
            Remark = reader["Remark"] == null ? "" : reader["Remark"].ToString(),
            RSA = reader["RSA"] == null ? "" : reader["RSA"].ToString(),
            MustLevel = (int)reader["MustLevel"],
            LowestLevel = (int)reader["LowestLevel"],
            NewerServer = (bool)reader["NewerServer"],
            ZoneId = (int)reader["ZoneId"]
        };

        public bool AddServer(SqlDataProvider.Data.ServerInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Server_List]\n                                   ([ID]\n                                   ,[Name]\n                                   ,[IP]\n                                   ,[Port]\n                                   ,[State]\n                                   ,[Online]\n                                   ,[Total]\n                                   ,[Room]\n                                   ,[Remark]\n                                   ,[RSA]\n                                   ,[MustLevel]\n                                   ,[LowestLevel]\n                                   ,[NewerServer]\n                                   ,[ZoneId])\n                               VALUES\n                                   (@ID\n                                   ,@Name\n                                   ,@IP\n                                   ,@Port\n                                   ,@State\n                                   ,@Online\n                                   ,@Total\n                                   ,@Room\n                                   ,@Remark\n                                   ,@RSA\n                                   ,@MustLevel\n                                   ,@LowestLevel\n                                   ,@NewerServer\n                                   ,@ZoneId)", new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@IP", (object) item.IP),
          new SqlParameter("@Port", (object) item.Port),
          new SqlParameter("@State", (object) item.State),
          new SqlParameter("@Online", (object) item.Online),
          new SqlParameter("@Total", (object) item.Total),
          new SqlParameter("@Room", (object) item.Room),
          new SqlParameter("@Remark", (object) item.Remark),
          new SqlParameter("@RSA", (object) item.RSA),
          new SqlParameter("@MustLevel", (object) item.MustLevel),
          new SqlParameter("@LowestLevel", (object) item.LowestLevel),
          new SqlParameter("@NewerServer", (object) item.NewerServer),
          new SqlParameter("@ZoneId", (object) item.ZoneId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddServer: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateServer(SqlDataProvider.Data.ServerInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Server_List]\n                               SET [ID] = @ID\n                                  ,[Name] = @Name\n                                  ,[IP] = @IP\n                                  ,[Port] = @Port\n                                  ,[State] = @State\n                                  ,[Online] = @Online\n                                  ,[Total] = @Total\n                                  ,[Room] = @Room\n                                  ,[Remark] = @Remark\n                                  ,[RSA] = @RSA\n                                  ,[MustLevel] = @MustLevel\n                                  ,[LowestLevel] = @LowestLevel\n                                  ,[NewerServer] = @NewerServer\n                                  ,[ZoneId] = @ZoneId\n                            WHERE [ID] = @ID", new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@IP", (object) item.IP),
          new SqlParameter("@Port", (object) item.Port),
          new SqlParameter("@State", (object) item.State),
          new SqlParameter("@Online", (object) item.Online),
          new SqlParameter("@Total", (object) item.Total),
          new SqlParameter("@Room", (object) item.Room),
          new SqlParameter("@Remark", (object) item.Remark),
          new SqlParameter("@RSA", (object) item.RSA),
          new SqlParameter("@MustLevel", (object) item.MustLevel),
          new SqlParameter("@LowestLevel", (object) item.LowestLevel),
          new SqlParameter("@NewerServer", (object) item.NewerServer),
          new SqlParameter("@ZoneId", (object) item.ZoneId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateServer: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteServer(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Server_List] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteServer: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteServerByZone(int ZoneId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Server_List] WHERE [ZoneId] = @ZoneId", new SqlParameter[1]
                {
          new SqlParameter("@ZoneId", (object) ZoneId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteServer: " + ex.ToString());
            }
            return flag;
        }

        public AreaConfigInfo[] GetAllAreaConfig()
        {
            List<AreaConfigInfo> areaConfigInfoList = new List<AreaConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[AreaConfig]");
                while (Sdr.Read())
                    areaConfigInfoList.Add(this.InitDataReader<AreaConfigInfo>(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllAreaConfig " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return areaConfigInfoList.ToArray();
        }

        public AreaConfigInfo GetAreaConfig(int id)
        {
            AreaConfigInfo areaConfigInfo = (AreaConfigInfo)null;
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[AreaConfig] WHERE AreaID = " + (object)id);
                while (Sdr.Read())
                    areaConfigInfo = this.InitDataReader<AreaConfigInfo>(Sdr);
            }
            catch (Exception ex)
            {
                Logger.Error("Init " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return areaConfigInfo;
        }

        public bool AddAreaConfig(AreaConfigInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[AreaConfig]\r\n                                   ([AreaID]\r\n                                   ,[AreaServer]\r\n                                   ,[AreaName]\r\n                                   ,[DataSource]\r\n                                   ,[Catalog]\r\n                                   ,[UserID]\r\n                                   ,[Password]\r\n                                   ,[CrossChatAllow]\r\n                                   ,[CrossPrivateChat]\r\n                                   ,[RequestUrl]\r\n                                   ,[Version])\r\n                               VALUES\r\n                                   (@AreaID\r\n                                   ,@AreaServer\r\n                                   ,@AreaName\r\n                                   ,@DataSource\r\n                                   ,@Catalog\r\n                                   ,@UserID\r\n                                   ,@Password\r\n                                   ,@CrossChatAllow\r\n                                   ,@CrossPrivateChat\r\n                                   ,@RequestUrl\r\n                                   ,@Version)", new SqlParameter[11]
                {
          new SqlParameter("@AreaID", (object) item.AreaID),
          new SqlParameter("@AreaServer", (object) item.AreaServer),
          new SqlParameter("@AreaName", (object) item.AreaName),
          new SqlParameter("@DataSource", (object) item.DataSource),
          new SqlParameter("@Catalog", (object) item.Catalog),
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@Password", (object) item.Password),
          new SqlParameter("@CrossChatAllow", (object) item.CrossChatAllow),
          new SqlParameter("@CrossPrivateChat", (object) item.CrossPrivateChat),
          new SqlParameter("@RequestUrl", (object) item.RequestUrl),
          new SqlParameter("@Version", (object) item.Version)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddAreaConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateAreaConfig(AreaConfigInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[AreaConfig]\r\n                               SET [AreaID] = @AreaID\r\n                                  ,[AreaServer] = @AreaServer\r\n                                  ,[AreaName] = @AreaName\r\n                                  ,[DataSource] = @DataSource\r\n                                  ,[Catalog] = @Catalog\r\n                                  ,[UserID] = @UserID\r\n                                  ,[Password] = @Password                                  \r\n                                  ,[RequestUrl] = @RequestUrl\r\n                                  ,[CrossChatAllow] = @CrossChatAllow\r\n                                  ,[CrossPrivateChat] = @CrossPrivateChat\r\n                                  ,[Version] = @Version\r\n                            WHERE [AreaID] = @AreaID", new SqlParameter[11]
                {
          new SqlParameter("@AreaID", (object) item.AreaID),
          new SqlParameter("@AreaServer", (object) item.AreaServer),
          new SqlParameter("@AreaName", (object) item.AreaName),
          new SqlParameter("@DataSource", (object) item.DataSource),
          new SqlParameter("@Catalog", (object) item.Catalog),
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@Password", (object) item.Password),
          new SqlParameter("@RequestUrl", (object) item.RequestUrl),
          new SqlParameter("@CrossChatAllow", (object) item.CrossChatAllow),
          new SqlParameter("@CrossPrivateChat", (object) item.CrossPrivateChat),
          new SqlParameter("@Version", (object) item.Version)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateAreaConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAreaConfig(int areaId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[AreaConfig] WHERE [AreaID] = @AreaID", new SqlParameter[1]
                {
          new SqlParameter("@AreaID", (object) areaId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteAreaConfig: " + ex.ToString());
            }
            return flag;
        }
    }
}
