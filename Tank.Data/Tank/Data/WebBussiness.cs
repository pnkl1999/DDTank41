using Helpers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Tank.Data
{
    public class WebBussiness : BaseBussiness
    {
        public CombineTableInfo[] GetAllCombineTable()
        {
            List<CombineTableInfo> combineTableInfoList = new List<CombineTableInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Combine_Table]");
                while (Sdr.Read())
                    combineTableInfoList.Add(this.InitCombineTableInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllCombineTable " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return combineTableInfoList.ToArray();
        }

        public CombineTableInfo[] GetAllCombineTableBy(int type)
        {
            List<CombineTableInfo> combineTableInfoList = new List<CombineTableInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Combine_Table] WHERE Type = 0 OR Type = " + type.ToString());
                while (Sdr.Read())
                    combineTableInfoList.Add(this.InitCombineTableInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllCombineTableBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return combineTableInfoList.ToArray();
        }

        public CombineTableInfo InitCombineTableInfo(SqlDataReader reader) => new CombineTableInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Type = (int)reader["Type"],
            IdEntityColumn = reader["IdEntityColumn"] == null ? "" : reader["IdEntityColumn"].ToString(),
            ConditionColumn1 = reader["ConditionColumn1"] == null ? "" : reader["ConditionColumn1"].ToString(),
            ConditionColumn2 = reader["ConditionColumn2"] == null ? "" : reader["ConditionColumn2"].ToString(),
            ConditionColumn3 = reader["ConditionColumn3"] == null ? "" : reader["ConditionColumn3"].ToString(),
            ConditionColumn4 = reader["ConditionColumn4"] == null ? "" : reader["ConditionColumn4"].ToString(),
            ConditionColumn5 = reader["ConditionColumn5"] == null ? "" : reader["ConditionColumn5"].ToString(),
            ConditionColumn6 = reader["ConditionColumn6"] == null ? "" : reader["ConditionColumn6"].ToString(),
            ConditionColumn7 = reader["ConditionColumn7"] == null ? "" : reader["ConditionColumn7"].ToString(),
            ConditionColumn8 = reader["ConditionColumn8"] == null ? "" : reader["ConditionColumn8"].ToString()
        };

        public bool AddCombineTable(CombineTableInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Combine_Table]\r\n                                   ([Name]\r\n                                   ,[Type]\r\n                                   ,[IdEntityColumn]\r\n                                   ,[ConditionColumn1]\r\n                                   ,[ConditionColumn2]\r\n                                   ,[ConditionColumn3]\r\n                                   ,[ConditionColumn4])\r\n                               VALUES\r\n                                   (@Name\r\n                                   ,@Type\r\n                                   ,@IdEntityColumn\r\n                                   ,@ConditionColumn1\r\n                                   ,@ConditionColumn2\r\n                                   ,@ConditionColumn3\r\n                                   ,@ConditionColumn4)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[8];
                SqlParameters[0] = new SqlParameter("@ID", (object)item.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Name", (object)item.Name);
                SqlParameters[2] = new SqlParameter("@Type", (object)item.Type);
                SqlParameters[3] = new SqlParameter("@IdEntityColumn", (object)item.IdEntityColumn);
                SqlParameters[4] = new SqlParameter("@ConditionColumn1", (object)item.ConditionColumn1);
                SqlParameters[5] = new SqlParameter("@ConditionColumn2", (object)item.ConditionColumn2);
                SqlParameters[6] = new SqlParameter("@ConditionColumn3", (object)item.ConditionColumn3);
                SqlParameters[7] = new SqlParameter("@ConditionColumn4", (object)item.ConditionColumn4);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddCombineTable: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateCombineTable(CombineTableInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Combine_Table]\r\n                               SET [Name] = @Name\r\n                                  ,[Type] = @Type\r\n                                  ,[IdEntityColumn] = @IdEntityColumn\r\n                                  ,[ConditionColumn1] = @ConditionColumn1\r\n                                  ,[ConditionColumn2] = @ConditionColumn2\r\n                                  ,[ConditionColumn3] = @ConditionColumn3\r\n                                  ,[ConditionColumn4] = @ConditionColumn4\r\n                            WHERE [ID] = @ID", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@IdEntityColumn", (object) item.IdEntityColumn),
          new SqlParameter("@ConditionColumn1", (object) item.ConditionColumn1),
          new SqlParameter("@ConditionColumn2", (object) item.ConditionColumn2),
          new SqlParameter("@ConditionColumn3", (object) item.ConditionColumn3),
          new SqlParameter("@ConditionColumn4", (object) item.ConditionColumn4)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateCombineTable: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteCombineTable(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Combine_Table] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteCombineTable: " + ex.ToString());
            }
            return flag;
        }

        public LanguageInfo[] GetAllLanguage()
        {
            List<LanguageInfo> languageInfoList = new List<LanguageInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Languages]");
                while (Sdr.Read())
                    languageInfoList.Add(this.InitLanguageInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllLanguage " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return languageInfoList.ToArray();
        }

        public LanguageInfo InitLanguageInfo(SqlDataReader reader) => new LanguageInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            ShortName = reader["ShortName"] == null ? "" : reader["ShortName"].ToString()
        };

        public bool AddLanguage(LanguageInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Languages]\r\n                                   ([Name]\r\n                                   ,[ShortName])\r\n                               VALUES\r\n                                   (@Name\r\n                                   ,@ShortName)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
          new SqlParameter("@ID", (object) item.ID),
          null,
          null
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Name", (object)item.Name);
                SqlParameters[2] = new SqlParameter("@ShortName", (object)item.ShortName);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddLanguage: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateLanguage(LanguageInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Languages]\r\n                               SET [Name] = @Name\r\n                                  ,[ShortName] = @ShortName\r\n                            WHERE [ID] = @ID", new SqlParameter[3]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@ShortName", (object) item.ShortName)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateLanguage: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteLanguage(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Languages] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteLanguage: " + ex.ToString());
            }
            return flag;
        }

        public UrlTankInfo[] GetAllUrlTank()
        {
            List<UrlTankInfo> urlTankInfoList = new List<UrlTankInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Url_Tank]");
                while (Sdr.Read())
                    urlTankInfoList.Add(this.InitUrlTankInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllUrlTank " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return urlTankInfoList.ToArray();
        }

        public UrlTankInfo GetSigleUrlTank(int id)
        {
            List<UrlTankInfo> urlTankInfoList = new List<UrlTankInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Url_Tank] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    urlTankInfoList.Add(this.InitUrlTankInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSigleUrlTank " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return urlTankInfoList.Count > 0 ? urlTankInfoList[0] : (UrlTankInfo)null;
        }

        public UrlTankInfo InitUrlTankInfo(SqlDataReader reader) => new UrlTankInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Detail = reader["Detail"] == null ? "" : reader["Detail"].ToString(),
            Resource = reader["Resource"] == null ? "" : reader["Resource"].ToString()
        };

        public bool AddUrlTank(UrlTankInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Url_Tank]\r\n                                   ([Name]\r\n                                   ,[Detail]\r\n                                   ,[Resource])\r\n                               VALUES\r\n                                   (@Name\r\n                                   ,@Detail\r\n                                   ,@Resource)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.ID),
          null,
          null,
          null
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Name", (object)item.Name);
                SqlParameters[2] = new SqlParameter("@Detail", (object)item.Detail);
                SqlParameters[3] = new SqlParameter("@Resource", (object)item.Resource);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddUrlTank: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateUrlTank(UrlTankInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Url_Tank]\r\n                               SET [Name] = @Name\r\n                                  ,[Detail] = @Detail\r\n                                  ,[Resource] = @Resource\r\n                            WHERE [ID] = @ID", new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Detail", (object) item.Detail),
          new SqlParameter("@Resource", (object) item.Resource)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateUrlTank: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteUrlTank(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Url_Tank] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteUrlTank: " + ex.ToString());
            }
            return flag;
        }

        public CategoryInfo[] GetAllCategory()
        {
            List<CategoryInfo> categoryInfoList = new List<CategoryInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Category]");
                while (Sdr.Read())
                    categoryInfoList.Add(this.InitCategoryInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllCategory " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return categoryInfoList.ToArray();
        }

        public CategoryInfo GetSigleCategory(int id)
        {
            List<CategoryInfo> categoryInfoList = new List<CategoryInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Category] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    categoryInfoList.Add(this.InitCategoryInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSigleCategory " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return categoryInfoList.Count > 0 ? categoryInfoList[0] : (CategoryInfo)null;
        }

        public CategoryInfo InitCategoryInfo(SqlDataReader reader) => new CategoryInfo()
        {
            ID = (int)reader["ID"],
            CategoryID = (int)reader["CategoryID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString()
        };

        public bool AddCategory(CategoryInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Category]\n                                   ([CategoryID]\n                                   ,[Name])\n                               VALUES\n                                   (@CategoryID\n                                   ,@Name)\n                            SELECT @@IDENTITY AS 'IDENTITY'\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
          new SqlParameter("@ID", (object) item.ID),
          null,
          null
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@CategoryID", (object)item.CategoryID);
                SqlParameters[2] = new SqlParameter("@Name", (object)item.Name);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddCategory: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateCategory(CategoryInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Category]\n                               SET [CategoryID] = @CategoryID\n                                  ,[Name] = @Name\n                            WHERE [ID] = @ID", new SqlParameter[3]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@CategoryID", (object) item.CategoryID),
          new SqlParameter("@Name", (object) item.Name)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateCategory: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteCategory(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Category] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteCategory: " + ex.ToString());
            }
            return flag;
        }

        public TableInfo[] GetAllTables()
        {
            List<TableInfo> tableInfoList = new List<TableInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Table_Games] ORDER BY Type,ID");
                while (Sdr.Read())
                    tableInfoList.Add(this.InitTableInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("Init TableInfo " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return tableInfoList.ToArray();
        }

        public TableInfo GetTableByName(string name)
        {
            List<TableInfo> tableInfoList = new List<TableInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Table_Games] WHERE [Name] LIKE N'" + name + "'");
                while (Sdr.Read())
                    tableInfoList.Add(this.InitTableInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("Init TableInfo " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return tableInfoList.Count > 0 ? tableInfoList[0] : (TableInfo)null;
        }

        public TableInfo InitTableInfo(SqlDataReader dr) => new TableInfo()
        {
            ID = (int)dr["ID"],
            Name = dr["Name"] == null ? "" : dr["Name"].ToString(),
            Type = (int)dr["Type"],
            Class = dr["Class"] == null ? "" : dr["Class"].ToString(),
            Keys = dr["Keys"] == null ? "" : dr["Keys"].ToString(),
            XmlName = dr["XmlName"] == null ? "" : dr["XmlName"].ToString()
        };

        public bool AddTableGames(TableInfo info)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Table_Games]\r\n                                        ([Name]\r\n                                        ,[Type]\r\n                                        ,[Class]\r\n                                        ,[Keys]\r\n                                        ,[XmlName])\r\n                                    VALUES\r\n                                        (@Name\r\n                                        ,@Type\r\n                                        ,@Class\r\n                                        ,@Keys\r\n                                        ,@XmlName)\r\n                                    SELECT @@IDENTITY AS 'IDENTITY'\r\n                                    SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[6];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Name", (object)info.Name);
                SqlParameters[2] = new SqlParameter("@Type", (object)info.Type);
                SqlParameters[3] = new SqlParameter("@Class", (object)info.Class);
                SqlParameters[4] = new SqlParameter("@Keys", (object)info.Keys);
                SqlParameters[5] = new SqlParameter("@XmlName", (object)info.XmlName);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public bool UpdateTableGames(TableInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Table_Games]\r\n                                    SET [Name] = @Name\r\n                                        ,[Type] = @Type\r\n                                        ,[Class] = @Class\r\n                                        ,[Keys] = @Keys\r\n                                        ,[XmlName] = @XmlName\r\n                                    WHERE [ID] = @ID", new SqlParameter[6]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@Name", (object) info.Name),
          new SqlParameter("@Type", (object) info.Type),
          new SqlParameter("@Class", (object) info.Class),
          new SqlParameter("@Keys", (object) info.Keys),
          new SqlParameter("@XmlName", (object) info.XmlName)
                });
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public bool DeleteTableGames(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Table_Games]  WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public TableDesignInfo[] GetAllTableDesign()
        {
            List<TableDesignInfo> tableDesignInfoList = new List<TableDesignInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Table_Games_Design] ORDER BY ID");
                while (Sdr.Read())
                    tableDesignInfoList.Add(this.InitTableDesignInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("Init TableDesignInfo " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return tableDesignInfoList.ToArray();
        }

        public TableDesignInfo GetSingleTableDesignBy(int tid, string name)
        {
            List<TableDesignInfo> tableDesignInfoList = new List<TableDesignInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, string.Format("SELECT * FROM [dbo].[Table_Games_Design] WHERE [TableID] = {0} AND [Name] LIKE N'{1}'", (object)tid, (object)name));
                while (Sdr.Read())
                    tableDesignInfoList.Add(this.InitTableDesignInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("Init TableDesignInfo " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return tableDesignInfoList.Count > 0 ? tableDesignInfoList[0] : (TableDesignInfo)null;
        }

        public TableDesignInfo GetSingleTableDesign(int id)
        {
            List<TableDesignInfo> tableDesignInfoList = new List<TableDesignInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, string.Format("SELECT * FROM [dbo].[Table_Games_Design] WHERE [ID] = {0}", (object)id));
                while (Sdr.Read())
                    tableDesignInfoList.Add(this.InitTableDesignInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("Init TableDesignInfo " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return tableDesignInfoList.Count > 0 ? tableDesignInfoList[0] : (TableDesignInfo)null;
        }

        public TableDesignInfo InitTableDesignInfo(SqlDataReader dr) => new TableDesignInfo()
        {
            ID = (int)dr["ID"],
            TableID = (int)dr["TableID"],
            Name = dr["Name"] == null ? "" : dr["Name"].ToString(),
            Type = dr["Type"] == null ? "" : dr["Type"].ToString(),
            IdEntity = (bool)dr["IdEntity"],
            IsPrimary = (bool)dr["IsPrimary"],
            IsNotNull = (bool)dr["IsNotNull"],
            IsShowHide = (bool)dr["IsShowHide"],
            TableGetMax = dr["TableGetMax"] == null ? "" : dr["TableGetMax"].ToString(),
            ColGetMax = dr["ColGetMax"] == null ? "" : dr["ColGetMax"].ToString(),
            Conditon = dr["Conditon"] == null ? "" : dr["Conditon"].ToString(),
            IntParse = (bool)dr["IntParse"]
        };

        public bool AddTableDesign(TableDesignInfo info)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Table_Games_Design]\r\n           ([TableID]\r\n           ,[Name]\r\n           ,[Type]\r\n           ,[IdEntity]\r\n           ,[IsPrimary]\r\n           ,[IsNotNull]\r\n           ,[IsShowHide]\r\n           ,[TableGetMax]\r\n           ,[ColGetMax]\r\n           ,[Conditon]\r\n           ,[IntParse])\r\n     VALUES\r\n           (@TableID\r\n           ,@Name\r\n           ,@Type\r\n           ,@IdEntity\r\n           ,@IsPrimary\r\n           ,@IsNotNull\r\n           ,@IsShowHide\r\n           ,@TableGetMax\r\n           ,@ColGetMax\r\n           ,@Conditon\r\n           ,@IntParse)\r\n    SELECT @@IDENTITY AS 'IDENTITY'\r\n    SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[12];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@TableID", (object)info.TableID);
                SqlParameters[2] = new SqlParameter("@Name", (object)info.Name);
                SqlParameters[3] = new SqlParameter("@Type", (object)info.Type);
                SqlParameters[4] = new SqlParameter("@IdEntity", (object)info.IdEntity);
                SqlParameters[5] = new SqlParameter("@IsPrimary", (object)info.IsPrimary);
                SqlParameters[6] = new SqlParameter("@IsNotNull", (object)info.IsNotNull);
                SqlParameters[7] = new SqlParameter("@IsShowHide", (object)info.IsShowHide);
                SqlParameters[8] = new SqlParameter("@TableGetMax", info.TableGetMax == null ? (object)"" : (object)info.TableGetMax);
                SqlParameters[9] = new SqlParameter("@ColGetMax", info.ColGetMax == null ? (object)"" : (object)info.ColGetMax);
                SqlParameters[10] = new SqlParameter("@Conditon", info.Conditon == null ? (object)"" : (object)info.Conditon);
                SqlParameters[11] = new SqlParameter("@IntParse", (object)info.IntParse);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public bool UpdateTableDesign(TableDesignInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Table_Games_Design]\r\n   SET [TableID] = @TableID\r\n      ,[Name] = @Name\r\n      ,[Type] = @Type\r\n      ,[IdEntity] = @IdEntity\r\n      ,[IsPrimary] = @IsPrimary\r\n      ,[IsNotNull] = @IsNotNull\r\n      ,[IsShowHide] = @IsShowHide\r\n      ,[TableGetMax] = @TableGetMax\r\n      ,[ColGetMax] = @ColGetMax\r\n      ,[Conditon] = @Conditon\r\n      ,[IntParse] = @IntParse\r\n WHERE [ID] = @ID", new SqlParameter[12]
                {
          new SqlParameter("@TableID", (object) info.TableID),
          new SqlParameter("@Name", (object) info.Name),
          new SqlParameter("@Type", (object) info.Type),
          new SqlParameter("@IdEntity", (object) info.IdEntity),
          new SqlParameter("@IsPrimary", (object) info.IsPrimary),
          new SqlParameter("@IsNotNull", (object) info.IsNotNull),
          new SqlParameter("@IsShowHide", (object) info.IsShowHide),
          new SqlParameter("@TableGetMax", (object) info.TableGetMax),
          new SqlParameter("@ColGetMax", (object) info.ColGetMax),
          new SqlParameter("@Conditon", (object) info.Conditon),
          new SqlParameter("@IntParse", (object) info.IntParse),
          new SqlParameter("@ID", (object) info.ID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public bool DeleteTableDesignByTableID(int tableID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Table_Games_Design]  WHERE [TableID] = @TableID", new SqlParameter[1]
                {
          new SqlParameter("@TableID", (object) tableID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public bool DeleteTableDesign(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Table_Games_Design]  WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public TopInfo[] GetAllTop()
        {
            List<TopInfo> topInfoList = new List<TopInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Top] WHERE ZoneID > 0 ORDER BY ZoneID");
                while (Sdr.Read())
                    topInfoList.Add(this.InitTopInfo(Sdr));
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
            return topInfoList.ToArray();
        }

        public TopInfo[] GetTopTemplate()
        {
            List<TopInfo> topInfoList = new List<TopInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Top] WHERE ZoneID = -1");
                while (Sdr.Read())
                    topInfoList.Add(this.InitTopInfo(Sdr));
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
            return topInfoList.ToArray();
        }

        public TopInfo GetSingleTop(int id)
        {
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Top] WHERE ID = " + (object)id);
                if (Sdr.Read())
                    return this.InitTopInfo(Sdr);
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
            return (TopInfo)null;
        }

        public TopInfo GetTopBy(int id, int type)
        {
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Top] WHERE ZoneID = " + (object)id + " AND Type = " + (object)type);
                if (Sdr.Read())
                    return this.InitTopInfo(Sdr);
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
            return (TopInfo)null;
        }

        public bool AddTop(TopInfo info)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Top]\r\n           ([ZoneID]\r\n           ,[Type]\r\n           ,[Name]\r\n           ,[Detail]\r\n           ,[Condition1]\r\n           ,[Condition2]\r\n           ,[GetTable])\r\n     VALUES\r\n           (@ZoneID\r\n           ,@Type\r\n           ,@Name\r\n           ,@Detail\r\n           ,@Condition1\r\n           ,@Condition2\r\n           ,@GetTable)\r\n    SELECT @@IDENTITY AS 'IDENTITY'\r\n    SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[8];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@ZoneID", (object)info.ZoneID);
                SqlParameters[2] = new SqlParameter("@Type", (object)info.Type);
                SqlParameters[3] = new SqlParameter("@Name", (object)info.Name);
                SqlParameters[4] = new SqlParameter("@Detail", (object)info.Detail);
                SqlParameters[5] = new SqlParameter("@Condition1", (object)info.Condition1);
                SqlParameters[6] = new SqlParameter("@Condition2", (object)info.Condition2);
                SqlParameters[7] = new SqlParameter("@GetTable", (object)info.GetTable);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public bool UpdateTop(TopInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Top]\r\n   SET [ZoneID] = @ZoneID\r\n      ,[Type] = @Type\r\n      ,[Name] = @Name\r\n      ,[Detail] = @Detail\r\n      ,[Condition1] = @Condition1\r\n      ,[Condition2] = @Condition2\r\n      ,[GetTable] = @GetTable\r\n WHERE [ID] = @ID", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@ZoneID", (object) info.ZoneID),
          new SqlParameter("@Type", (object) info.Type),
          new SqlParameter("@Name", (object) info.Name),
          new SqlParameter("@Detail", (object) info.Detail),
          new SqlParameter("@Condition1", (object) info.Condition1),
          new SqlParameter("@Condition2", (object) info.Condition2),
          new SqlParameter("@GetTable", (object) info.GetTable)
                });
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public bool DeleteTop(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Top]  WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public TopInfo InitTopInfo(SqlDataReader dr) => new TopInfo()
        {
            ID = (int)dr["ID"],
            ZoneID = (int)dr["ZoneID"],
            Type = (int)dr["Type"],
            Name = dr["Name"] == null ? "" : dr["Name"].ToString(),
            Detail = dr["Detail"] == null ? "" : dr["Detail"].ToString(),
            Condition1 = dr["Condition1"] == null ? "" : dr["Condition1"].ToString(),
            Condition2 = dr["Condition2"] == null ? "" : dr["Condition2"].ToString(),
            GetTable = dr["GetTable"] == null ? "" : dr["GetTable"].ToString()
        };

        public TopAwardInfo[] GetAllTopAward()
        {
            List<TopAwardInfo> topAwardInfoList = new List<TopAwardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Top_Award]");
                while (Sdr.Read())
                {
                    TopAwardInfo topAwardInfo = this.InitTopAwardInfo(Sdr);
                    ItemTemplateInfo itemTemplate = ItemTemplateMgr.FindItemTemplate(topAwardInfo.TemplateID);
                    if (itemTemplate != null)
                    {
                        topAwardInfo.Type = AppSettings.GetItemsType(itemTemplate.CategoryID);
                        topAwardInfo.Name = itemTemplate.Name;
                        topAwardInfo.Sex = itemTemplate.NeedSex == 1;
                    }
                    topAwardInfoList.Add(topAwardInfo);
                }
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
            return topAwardInfoList.ToArray();
        }

        public TopAwardInfo GetSingleTopAward(int id, int rank, int topid)
        {
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Top_Award] WHERE [TopID] = " + (object)topid + " AND [Rank] = " + (object)rank + " AND [TemplateID] = " + (object)id);
                if (Sdr.Read())
                {
                    TopAwardInfo topAwardInfo = this.InitTopAwardInfo(Sdr);
                    ItemTemplateInfo itemTemplate = ItemTemplateMgr.FindItemTemplate(topAwardInfo.TemplateID);
                    if (itemTemplate != null)
                    {
                        topAwardInfo.Type = AppSettings.GetItemsType(itemTemplate.CategoryID);
                        topAwardInfo.Name = itemTemplate.Name;
                    }
                    return topAwardInfo;
                }
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
            return (TopAwardInfo)null;
        }

        public bool AddTopAward(TopAwardInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm(string.Format("INSERT INTO [dbo].[Top_Award]\r\n           ([TopID]\r\n           ,[Rank]\r\n           ,[TemplateID]\r\n           ,[Count]\r\n           ,[ValidDate]\r\n           ,[IsBinds]\r\n           ,[StrengthenLevel]\r\n           ,[AttackCompose]\r\n           ,[DefendCompose]\r\n           ,[AgilityCompose]\r\n           ,[LuckCompose]\r\n           ,[MagicAttack]\r\n           ,[MagicDefend]\r\n           ,[IsGold]\r\n           ,[GoldValidate])\r\n     VALUES\r\n           ({0}\r\n           ,{1}\r\n           ,{2}\r\n           ,{3}\r\n           ,{4}\r\n           ,{5}\r\n           ,{6}\r\n           ,{7}\r\n           ,{8}\r\n           ,{9}\r\n           ,{10}\r\n           ,{11}\r\n           ,{12}\r\n           ,{13}\r\n           ,{14}) ", (object)info.TopID, (object)info.Rank, (object)info.TemplateID, (object)info.Count, (object)info.ValidDate, (object)(info.IsBinds ? 1 : 0), (object)info.StrengthenLevel, (object)info.AttackCompose, (object)info.DefendCompose, (object)info.AgilityCompose, (object)info.LuckCompose, (object)info.MagicAttack, (object)info.MagicDefend, (object)(info.IsGold ? 1 : 0), (object)info.GoldValidate));
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public bool UpdateTopAward(TopAwardInfo info, int id, int rank, int topid)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm(string.Format("UPDATE [dbo].[Top_Award]\r\n   SET [TopID] = {0}\r\n      ,[Rank] = {1}\r\n      ,[TemplateID] = {2}\r\n      ,[Count] = {3}\r\n      ,[ValidDate] = {4}\r\n      ,[IsBinds] = {5}\r\n      ,[StrengthenLevel] = {6}\r\n      ,[AttackCompose] = {7}\r\n      ,[DefendCompose] = {8}\r\n      ,[AgilityCompose] = {9}\r\n      ,[LuckCompose] = {10}\r\n      ,[MagicAttack] = {11}\r\n      ,[MagicDefend] = {12}\r\n      ,[IsGold] = {13}\r\n      ,[GoldValidate] = {14}\r\n   WHERE [TopID] = {15} AND [Rank] = {16} AND [TemplateID] = {17}", (object)info.TopID, (object)info.Rank, (object)info.TemplateID, (object)info.Count, (object)info.ValidDate, (object)(info.IsBinds ? 1 : 0), (object)info.StrengthenLevel, (object)info.AttackCompose, (object)info.DefendCompose, (object)info.AgilityCompose, (object)info.LuckCompose, (object)info.MagicAttack, (object)info.MagicDefend, (object)(info.IsGold ? 1 : 0), (object)info.GoldValidate, (object)topid, (object)rank, (object)id));
            }
            catch (Exception ex)
            {
                Logger.Error(ex.ToString());
            }
            return flag;
        }

        public bool DeleteTopAward(int topID, int rank, int templateID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Top_Award] WHERE [TopID] = @TopID AND [Rank] = @Rank AND [TemplateID] = @TemplateID", new SqlParameter[3]
                {
          new SqlParameter("@TopID", (object) topID),
          new SqlParameter("@Rank", (object) rank),
          new SqlParameter("@TemplateID", (object) templateID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteTopAward: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteTopAward(int topID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Top_Award] WHERE [TopID] = @TopID", new SqlParameter[1]
                {
          new SqlParameter("@TopID", (object) topID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteTopAward: " + ex.ToString());
            }
            return flag;
        }

        public TopAwardInfo InitTopAwardInfo(SqlDataReader dr) => new TopAwardInfo()
        {
            TopID = (int)dr["TopID"],
            Rank = (int)dr["Rank"],
            TemplateID = (int)dr["TemplateID"],
            Count = (int)dr["Count"],
            ValidDate = (int)dr["ValidDate"],
            IsBinds = (bool)dr["IsBinds"],
            StrengthenLevel = (int)dr["StrengthenLevel"],
            AttackCompose = (int)dr["AttackCompose"],
            DefendCompose = (int)dr["DefendCompose"],
            AgilityCompose = (int)dr["AgilityCompose"],
            LuckCompose = (int)dr["LuckCompose"],
            MagicAttack = (int)dr["MagicAttack"],
            MagicDefend = (int)dr["MagicDefend"],
            IsGold = (bool)dr["IsGold"],
            GoldValidate = (int)dr["GoldValidate"]
        };
    }
}
