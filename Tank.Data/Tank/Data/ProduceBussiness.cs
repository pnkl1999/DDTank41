using Helpers;
using SqlDataProvider.BaseClass;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Tank.Data
{
    public class ProduceBussiness : BaseBussiness
    {
        public ProduceBussiness() => this.db = new Sql_DbObject("WebConfig", "crosszoneString");

        public bool UpdateEditable(string table, string column, string valueStr, string condition)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[" + table + "] SET [" + column + "] = @" + column + " WHERE " + condition, new SqlParameter[1]
                {
          new SqlParameter("@" + column, (object) valueStr)
                });
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message);
            }
            return flag;
        }

        public MaxLevelTemplateInfo[] GetAllMaxLevelTemplate()
        {
            List<MaxLevelTemplateInfo> levelTemplateInfoList = new List<MaxLevelTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Max_Level_Template]");
                while (Sdr.Read())
                    levelTemplateInfoList.Add(this.InitMaxLevelTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMaxLevelTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return levelTemplateInfoList.ToArray();
        }

        public MaxLevelTemplateInfo InitMaxLevelTemplateInfo(SqlDataReader reader) => new MaxLevelTemplateInfo()
        {
            Level = (int)reader["Level"],
            Attack = (int)reader["Attack"],
            Defence = (int)reader["Defence"],
            Agility = (int)reader["Agility"],
            Lucky = (int)reader["Lucky"],
            MagicAttack = (int)reader["MagicAttack"],
            MagicDefence = (int)reader["MagicDefence"],
            Cost = (int)reader["Cost"]
        };

        public bool AddMaxLevelTemplate(MaxLevelTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Max_Level_Template]\r\n                                   ([Level]\r\n                                   ,[Attack]\r\n                                   ,[Defence]\r\n                                   ,[Agility]\r\n                                   ,[Lucky]\r\n                                   ,[MagicAttack]\r\n                                   ,[MagicDefence]\r\n                                   ,[Cost])\r\n                               VALUES\r\n                                   (@Level\r\n                                   ,@Attack\r\n                                   ,@Defence\r\n                                   ,@Agility\r\n                                   ,@Lucky\r\n                                   ,@MagicAttack\r\n                                   ,@MagicDefence\r\n                                   ,@Cost)", new SqlParameter[8]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Lucky", (object) item.Lucky),
          new SqlParameter("@MagicAttack", (object) item.MagicAttack),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence),
          new SqlParameter("@Cost", (object) item.Cost)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddMaxLevelTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateMaxLevelTemplate(MaxLevelTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Max_Level_Template]\r\n                               SET [Attack] = @Attack\r\n                                  ,[Defence] = @Defence\r\n                                  ,[Agility] = @Agility\r\n                                  ,[Lucky] = @Lucky\r\n                                  ,[MagicAttack] = @MagicAttack\r\n                                  ,[MagicDefence] = @MagicDefence\r\n                                  ,[Cost] = @Cost\r\n                            WHERE [Level] = @Level", new SqlParameter[8]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Lucky", (object) item.Lucky),
          new SqlParameter("@MagicAttack", (object) item.MagicAttack),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence),
          new SqlParameter("@Cost", (object) item.Cost)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateMaxLevelTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteMaxLevelTemplate(int level)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Max_Level_Template] WHERE [Level] = @Level", new SqlParameter[1]
                {
          new SqlParameter("@Level", (object) level)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMaxLevelTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllMaxLevelTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Max_Level_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMaxLevelTemplate: " + ex.ToString());
            }
            return flag;
        }

        public CardAchievementInfo[] GetAllCardAchievement()
        {
            List<CardAchievementInfo> cardAchievementInfoList = new List<CardAchievementInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Card_Achievement]");
                while (Sdr.Read())
                    cardAchievementInfoList.Add(this.InitCardAchievementInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllCardAchievement " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return cardAchievementInfoList.ToArray();
        }

        public CardAchievementInfo InitCardAchievementInfo(SqlDataReader reader) => new CardAchievementInfo()
        {
            AchievementID = (int)reader["AchievementID"],
            AddAttack = (int)reader["AddAttack"],
            AddBlood = (int)reader["AddBlood"],
            AddDamage = (int)reader["AddDamage"],
            AddDefend = (int)reader["AddDefend"],
            AddGuard = (int)reader["AddGuard"],
            AddLucky = (int)reader["AddLucky"],
            AddMagicAttack = (int)reader["AddMagicAttack"],
            AddMagicDefend = (int)reader["AddMagicDefend"],
            Desc = reader["Desc"] == null ? "" : reader["Desc"].ToString(),
            Honor_id = (int)reader["Honor_id"],
            IsPrompt = (int)reader["IsPrompt"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            RequireGroupid = (int)reader["RequireGroupid"],
            RequireGroupNum = (int)reader["RequireGroupNum"],
            RequireNum = (int)reader["RequireNum"],
            RequireType = (int)reader["RequireType"],
            Type = (int)reader["Type"]
        };

        public bool AddCardAchievement(CardAchievementInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Card_Achievement]\r\n                                   ([AchievementID]\r\n                                   ,[AddAttack]\r\n                                   ,[AddBlood]\r\n                                   ,[AddDamage]\r\n                                   ,[AddDefend]\r\n                                   ,[AddGuard]\r\n                                   ,[AddLucky]\r\n                                   ,[AddMagicAttack]\r\n                                   ,[AddMagicDefend]\r\n                                   ,[Desc]\r\n                                   ,[Honor_id]\r\n                                   ,[IsPrompt]\r\n                                   ,[Name]\r\n                                   ,[RequireGroupid]\r\n                                   ,[RequireGroupNum]\r\n                                   ,[RequireNum]\r\n                                   ,[RequireType]\r\n                                   ,[Type])\r\n                               VALUES\r\n                                   (@AchievementID\r\n                                   ,@AddAttack\r\n                                   ,@AddBlood\r\n                                   ,@AddDamage\r\n                                   ,@AddDefend\r\n                                   ,@AddGuard\r\n                                   ,@AddLucky\r\n                                   ,@AddMagicAttack\r\n                                   ,@AddMagicDefend\r\n                                   ,@Desc\r\n                                   ,@Honor_id\r\n                                   ,@IsPrompt\r\n                                   ,@Name\r\n                                   ,@RequireGroupid\r\n                                   ,@RequireGroupNum\r\n                                   ,@RequireNum\r\n                                   ,@RequireType\r\n                                   ,@Type)", new SqlParameter[18]
                {
          new SqlParameter("@AchievementID", (object) item.AchievementID),
          new SqlParameter("@AddAttack", (object) item.AddAttack),
          new SqlParameter("@AddBlood", (object) item.AddBlood),
          new SqlParameter("@AddDamage", (object) item.AddDamage),
          new SqlParameter("@AddDefend", (object) item.AddDefend),
          new SqlParameter("@AddGuard", (object) item.AddGuard),
          new SqlParameter("@AddLucky", (object) item.AddLucky),
          new SqlParameter("@AddMagicAttack", (object) item.AddMagicAttack),
          new SqlParameter("@AddMagicDefend", (object) item.AddMagicDefend),
          new SqlParameter("@Desc", (object) item.Desc),
          new SqlParameter("@Honor_id", (object) item.Honor_id),
          new SqlParameter("@IsPrompt", (object) item.IsPrompt),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@RequireGroupid", (object) item.RequireGroupid),
          new SqlParameter("@RequireGroupNum", (object) item.RequireGroupNum),
          new SqlParameter("@RequireNum", (object) item.RequireNum),
          new SqlParameter("@RequireType", (object) item.RequireType),
          new SqlParameter("@Type", (object) item.Type)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddCardAchievement: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateCardAchievement(CardAchievementInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Card_Achievement]\r\n                               SET [AchievementID] = @AchievementID\r\n                                  ,[AddAttack] = @AddAttack\r\n                                  ,[AddBlood] = @AddBlood\r\n                                  ,[AddDamage] = @AddDamage\r\n                                  ,[AddDefend] = @AddDefend\r\n                                  ,[AddGuard] = @AddGuard\r\n                                  ,[AddLucky] = @AddLucky\r\n                                  ,[AddMagicAttack] = @AddMagicAttack\r\n                                  ,[AddMagicDefend] = @AddMagicDefend\r\n                                  ,[Desc] = @Desc\r\n                                  ,[Honor_id] = @Honor_id\r\n                                  ,[IsPrompt] = @IsPrompt\r\n                                  ,[Name] = @Name\r\n                                  ,[RequireGroupid] = @RequireGroupid\r\n                                  ,[RequireGroupNum] = @RequireGroupNum\r\n                                  ,[RequireNum] = @RequireNum\r\n                                  ,[RequireType] = @RequireType\r\n                                  ,[Type] = @Type\r\n                            WHERE [AchievementID] = @AchievementID", new SqlParameter[18]
                {
          new SqlParameter("@AchievementID", (object) item.AchievementID),
          new SqlParameter("@AddAttack", (object) item.AddAttack),
          new SqlParameter("@AddBlood", (object) item.AddBlood),
          new SqlParameter("@AddDamage", (object) item.AddDamage),
          new SqlParameter("@AddDefend", (object) item.AddDefend),
          new SqlParameter("@AddGuard", (object) item.AddGuard),
          new SqlParameter("@AddLucky", (object) item.AddLucky),
          new SqlParameter("@AddMagicAttack", (object) item.AddMagicAttack),
          new SqlParameter("@AddMagicDefend", (object) item.AddMagicDefend),
          new SqlParameter("@Desc", (object) item.Desc),
          new SqlParameter("@Honor_id", (object) item.Honor_id),
          new SqlParameter("@IsPrompt", (object) item.IsPrompt),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@RequireGroupid", (object) item.RequireGroupid),
          new SqlParameter("@RequireGroupNum", (object) item.RequireGroupNum),
          new SqlParameter("@RequireNum", (object) item.RequireNum),
          new SqlParameter("@RequireType", (object) item.RequireType),
          new SqlParameter("@Type", (object) item.Type)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateCardAchievement: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteCardAchievement(int achievementID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Card_Achievement] WHERE [AchievementID] = @AchievementID", new SqlParameter[1]
                {
          new SqlParameter("@AchievementID", (object) achievementID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteCardAchievement: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllCardAchievement()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Card_Achievement]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteCardAchievement: " + ex.ToString());
            }
            return flag;
        }

        public RuneAdvanceTemplateInfo[] GetAllRuneAdvanceTemplate()
        {
            List<RuneAdvanceTemplateInfo> advanceTemplateInfoList = new List<RuneAdvanceTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Rune_Advance_Template]");
                while (Sdr.Read())
                    advanceTemplateInfoList.Add(this.InitRuneAdvanceTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllRuneAdvanceTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return advanceTemplateInfoList.ToArray();
        }

        public RuneAdvanceTemplateInfo InitRuneAdvanceTemplateInfo(
          SqlDataReader reader)
        {
            return new RuneAdvanceTemplateInfo()
            {
                AdvancedTempId = (int)reader["AdvancedTempId"],
                RuneName = reader["RuneName"] == null ? "" : reader["RuneName"].ToString(),
                MainMaterials = reader["MainMaterials"] == null ? "" : reader["MainMaterials"].ToString(),
                Quality = (int)reader["Quality"],
                MaxLevelTempRunId = (int)reader["MaxLevelTempRunId"],
                AuxiliaryMaterials = (string)reader["AuxiliaryMaterials"],
                AdvanceDesc = reader["AdvanceDesc"] == null ? "" : reader["AdvanceDesc"].ToString()
            };
        }

        public bool AddRuneAdvanceTemplate(RuneAdvanceTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Rune_Advance_Template]\r\n                                   ([AdvancedTempId]\r\n                                   ,[RuneName]\r\n                                   ,[MainMaterials]\r\n                                   ,[Quality]\r\n                                   ,[MaxLevelTempRunId]\r\n                                   ,[AuxiliaryMaterials]\r\n                                   ,[AdvanceDesc])\r\n                               VALUES\r\n                                   (@AdvancedTempId\r\n                                   ,@RuneName\r\n                                   ,@MainMaterials\r\n                                   ,@Quality\r\n                                   ,@MaxLevelTempRunId\r\n                                   ,@AuxiliaryMaterials\r\n                                   ,@AdvanceDesc)", new SqlParameter[7]
                {
          new SqlParameter("@AdvancedTempId", (object) item.AdvancedTempId),
          new SqlParameter("@RuneName", (object) item.RuneName),
          new SqlParameter("@MainMaterials", (object) item.MainMaterials),
          new SqlParameter("@Quality", (object) item.Quality),
          new SqlParameter("@MaxLevelTempRunId", (object) item.MaxLevelTempRunId),
          new SqlParameter("@AuxiliaryMaterials", (object) item.AuxiliaryMaterials),
          new SqlParameter("@AdvanceDesc", (object) item.AdvanceDesc)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddRuneAdvanceTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateRuneAdvanceTemplate(RuneAdvanceTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Rune_Advance_Template]\r\n                               SET [RuneName] = @RuneName\r\n                                  ,[MainMaterials] = @MainMaterials\r\n                                  ,[Quality] = @Quality\r\n                                  ,[MaxLevelTempRunId] = @MaxLevelTempRunId\r\n                                  ,[AuxiliaryMaterials] = @AuxiliaryMaterials\r\n                                  ,[AdvanceDesc] = @AdvanceDesc\r\n                            WHERE [AdvancedTempId] = @AdvancedTempId", new SqlParameter[7]
                {
          new SqlParameter("@AdvancedTempId", (object) item.AdvancedTempId),
          new SqlParameter("@RuneName", (object) item.RuneName),
          new SqlParameter("@MainMaterials", (object) item.MainMaterials),
          new SqlParameter("@Quality", (object) item.Quality),
          new SqlParameter("@MaxLevelTempRunId", (object) item.MaxLevelTempRunId),
          new SqlParameter("@AuxiliaryMaterials", (object) item.AuxiliaryMaterials),
          new SqlParameter("@AdvanceDesc", (object) item.AdvanceDesc)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateRuneAdvanceTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteRuneAdvanceTemplate(int advancedTempId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Rune_Advance_Template] WHERE [AdvancedTempId] = @AdvancedTempId", new SqlParameter[1]
                {
          new SqlParameter("@AdvancedTempId", (object) advancedTempId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteRuneAdvanceTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllRuneAdvanceTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Rune_Advance_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteRuneAdvanceTemplate: " + ex.ToString());
            }
            return flag;
        }

        public ServerProperty[] GetAllServerProperty()
        {
            List<ServerProperty> serverPropertyList = new List<ServerProperty>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Server_Config] WHERE ID < 9000");
                while (Sdr.Read())
                    serverPropertyList.Add(this.InitServerPropertyInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllServerProperty " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return serverPropertyList.ToArray();
        }

        public ServerProperty InitServerPropertyInfo(SqlDataReader reader) => new ServerProperty()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Value = reader["Value"] == null ? "" : reader["Value"].ToString()
        };

        public bool AddServerProperty(ServerProperty item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Server_Config]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[Value])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@Value)", new SqlParameter[3]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Value", (object) item.Value)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddServerProperty: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateServerProperty(ServerProperty item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Server_Config]\r\n                               SET [Value] = @Value\r\n                            WHERE [Name] = @Name", new SqlParameter[2]
                {
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Value", (object) item.Value)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateServerProperty: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteServerProperty(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Server_Config] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteServerProperty: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteServerPropertyByName(string name)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Server_Config] WHERE [Name] = @Name", new SqlParameter[1]
                {
          new SqlParameter("@Name", (object) name)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteServerProperty: " + ex.ToString());
            }
            return flag;
        }

        public BattleBonusInfo[] GetAllBattleBonus()
        {
            List<BattleBonusInfo> battleBonusInfoList = new List<BattleBonusInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Battle_Bonus]");
                while (Sdr.Read())
                    battleBonusInfoList.Add(this.InitBattleBonusInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllBattleBonus " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return battleBonusInfoList.ToArray();
        }

        public BattleBonusInfo GetSingleBattleBonus(int id)
        {
            List<BattleBonusInfo> battleBonusInfoList = new List<BattleBonusInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Battle_Bonus] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    battleBonusInfoList.Add(this.InitBattleBonusInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleBattleBonus " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return battleBonusInfoList.Count > 0 ? battleBonusInfoList[0] : (BattleBonusInfo)null;
        }

        public BattleBonusInfo InitBattleBonusInfo(SqlDataReader reader) => new BattleBonusInfo()
        {
            ID = (int)reader["ID"],
            Rate = (int)reader["Rate"],
            MinValue = (int)reader["MinValue"],
            MaxValue = (int)reader["MaxValue"],
            BeginTime = (DateTime)reader["BeginTime"],
            EndTime = (DateTime)reader["EndTime"],
            Notice = reader["Notice"] == null ? "" : reader["Notice"].ToString(),
            TemplateID = (int)reader["TemplateID"],
            Type = (int)reader["Type"],
            IsLog = (bool)reader["IsLog"],
            IsBinds = (bool)reader["IsBinds"],
            ValidDate = (int)reader["ValidDate"],
            StrengthenLevel = (int)reader["StrengthenLevel"],
            AttackCompose = (int)reader["AttackCompose"],
            DefendCompose = (int)reader["DefendCompose"],
            AgilityCompose = (int)reader["AgilityCompose"],
            LuckCompose = (int)reader["LuckCompose"],
            Random = (int)reader["Random"],
            MagicAttack = (int)reader["MagicAttack"],
            MagicDefence = (int)reader["MagicDefence"],
            HasValidate = (bool)reader["HasValidate"],
            goldValidate = (int)reader["goldValidate"],
            Detail = reader["Detail"] == null ? "" : reader["Detail"].ToString(),
            DisableRandom = (bool)reader["DisableRandom"],
            IsExist = (bool)reader["IsExist"]
        };

        public bool AddBattleBonus(BattleBonusInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Battle_Bonus]\r\n                                   ([Rate]\r\n                                   ,[MinValue]\r\n                                   ,[MaxValue]\r\n                                   ,[BeginTime]\r\n                                   ,[EndTime]\r\n                                   ,[Notice]\r\n                                   ,[TemplateID]\r\n                                   ,[Type]\r\n                                   ,[IsLog]\r\n                                   ,[IsBinds]\r\n                                   ,[ValidDate]\r\n                                   ,[StrengthenLevel]\r\n                                   ,[AttackCompose]\r\n                                   ,[DefendCompose]\r\n                                   ,[AgilityCompose]\r\n                                   ,[LuckCompose]\r\n                                   ,[Random]\r\n                                   ,[MagicAttack]\r\n                                   ,[MagicDefence]\r\n                                   ,[HasValidate]\r\n                                   ,[goldValidate]\r\n                                   ,[Detail]\r\n                                   ,[DisableRandom]\r\n                                   ,[IsExist])\r\n                               VALUES\r\n                                   (@Rate\r\n                                   ,@MinValue\r\n                                   ,@MaxValue\r\n                                   ,@BeginTime\r\n                                   ,@EndTime\r\n                                   ,@Notice\r\n                                   ,@TemplateID\r\n                                   ,@Type\r\n                                   ,@IsLog\r\n                                   ,@IsBinds\r\n                                   ,@ValidDate\r\n                                   ,@StrengthenLevel\r\n                                   ,@AttackCompose\r\n                                   ,@DefendCompose\r\n                                   ,@AgilityCompose\r\n                                   ,@LuckCompose\r\n                                   ,@Random\r\n                                   ,@MagicAttack\r\n                                   ,@MagicDefence\r\n                                   ,@HasValidate\r\n                                   ,@goldValidate\r\n                                   ,@Detail\r\n                                   ,@DisableRandom\r\n                                   ,@IsExist)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[25];
                SqlParameters[0] = new SqlParameter("@ID", (object)item.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Rate", (object)item.Rate);
                SqlParameters[2] = new SqlParameter("@MinValue", (object)item.MinValue);
                SqlParameters[3] = new SqlParameter("@MaxValue", (object)item.MaxValue);
                SqlParameters[4] = new SqlParameter("@BeginTime", (object)item.BeginTime);
                SqlParameters[5] = new SqlParameter("@EndTime", (object)item.EndTime);
                SqlParameters[6] = new SqlParameter("@Notice", (object)item.Notice);
                SqlParameters[7] = new SqlParameter("@TemplateID", (object)item.TemplateID);
                SqlParameters[8] = new SqlParameter("@Type", (object)item.Type);
                SqlParameters[9] = new SqlParameter("@IsLog", (object)item.IsLog);
                SqlParameters[10] = new SqlParameter("@IsBinds", (object)item.IsBinds);
                SqlParameters[11] = new SqlParameter("@ValidDate", (object)item.ValidDate);
                SqlParameters[12] = new SqlParameter("@StrengthenLevel", (object)item.StrengthenLevel);
                SqlParameters[13] = new SqlParameter("@AttackCompose", (object)item.AttackCompose);
                SqlParameters[14] = new SqlParameter("@DefendCompose", (object)item.DefendCompose);
                SqlParameters[15] = new SqlParameter("@AgilityCompose", (object)item.AgilityCompose);
                SqlParameters[16] = new SqlParameter("@LuckCompose", (object)item.LuckCompose);
                SqlParameters[17] = new SqlParameter("@Random", (object)item.Random);
                SqlParameters[18] = new SqlParameter("@MagicAttack", (object)item.MagicAttack);
                SqlParameters[19] = new SqlParameter("@MagicDefence", (object)item.MagicDefence);
                SqlParameters[20] = new SqlParameter("@HasValidate", (object)item.HasValidate);
                SqlParameters[21] = new SqlParameter("@goldValidate", (object)item.goldValidate);
                SqlParameters[22] = new SqlParameter("@Detail", (object)item.Detail);
                SqlParameters[23] = new SqlParameter("@DisableRandom", (object)item.DisableRandom);
                SqlParameters[24] = new SqlParameter("@IsExist", (object)item.IsExist);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddBattleBonus: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateBattleBonus(BattleBonusInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Battle_Bonus]\r\n                               SET [Rate] = @Rate\r\n                                  ,[MinValue] = @MinValue\r\n                                  ,[MaxValue] = @MaxValue\r\n                                  ,[BeginTime] = @BeginTime\r\n                                  ,[EndTime] = @EndTime\r\n                                  ,[Notice] = @Notice\r\n                                  ,[TemplateID] = @TemplateID\r\n                                  ,[Type] = @Type\r\n                                  ,[IsLog] = @IsLog\r\n                                  ,[IsBinds] = @IsBinds\r\n                                  ,[ValidDate] = @ValidDate\r\n                                  ,[StrengthenLevel] = @StrengthenLevel\r\n                                  ,[AttackCompose] = @AttackCompose\r\n                                  ,[DefendCompose] = @DefendCompose\r\n                                  ,[AgilityCompose] = @AgilityCompose\r\n                                  ,[LuckCompose] = @LuckCompose\r\n                                  ,[Random] = @Random\r\n                                  ,[MagicAttack] = @MagicAttack\r\n                                  ,[MagicDefence] = @MagicDefence\r\n                                  ,[HasValidate] = @HasValidate\r\n                                  ,[goldValidate] = @goldValidate\r\n                                  ,[Detail] = @Detail\r\n                                  ,[DisableRandom] = @DisableRandom\r\n                                  ,[IsExist] = @IsExist\r\n                            WHERE [ID] = @ID", new SqlParameter[25]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Rate", (object) item.Rate),
          new SqlParameter("@MinValue", (object) item.MinValue),
          new SqlParameter("@MaxValue", (object) item.MaxValue),
          new SqlParameter("@BeginTime", (object) item.BeginTime),
          new SqlParameter("@EndTime", (object) item.EndTime),
          new SqlParameter("@Notice", (object) item.Notice),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@IsLog", (object) item.IsLog),
          new SqlParameter("@IsBinds", (object) item.IsBinds),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@Random", (object) item.Random),
          new SqlParameter("@MagicAttack", (object) item.MagicAttack),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence),
          new SqlParameter("@HasValidate", (object) item.HasValidate),
          new SqlParameter("@goldValidate", (object) item.goldValidate),
          new SqlParameter("@Detail", (object) item.Detail),
          new SqlParameter("@DisableRandom", (object) item.DisableRandom),
          new SqlParameter("@IsExist", (object) item.IsExist)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateBattleBonus: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteBattleBonus(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Battle_Bonus] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteBattleBonus: " + ex.ToString());
            }
            return flag;
        }

        public DailyLeagueRewardGroupInfo[] GetAllDailyLeagueRewardGroup()
        {
            List<DailyLeagueRewardGroupInfo> leagueRewardGroupInfoList = new List<DailyLeagueRewardGroupInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Daily_League_Reward_Group]");
                while (Sdr.Read())
                    leagueRewardGroupInfoList.Add(this.InitDailyLeagueRewardGroupInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllDailyLeagueRewardGroup " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return leagueRewardGroupInfoList.ToArray();
        }

        public DailyLeagueRewardGroupInfo GetSingleDailyLeagueRewardGroup(
          int id)
        {
            List<DailyLeagueRewardGroupInfo> leagueRewardGroupInfoList = new List<DailyLeagueRewardGroupInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Daily_League_Reward_Group] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    leagueRewardGroupInfoList.Add(this.InitDailyLeagueRewardGroupInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleDailyLeagueRewardGroup " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return leagueRewardGroupInfoList.Count > 0 ? leagueRewardGroupInfoList[0] : (DailyLeagueRewardGroupInfo)null;
        }

        public DailyLeagueRewardGroupInfo InitDailyLeagueRewardGroupInfo(
          SqlDataReader reader)
        {
            return new DailyLeagueRewardGroupInfo()
            {
                Class = (int)reader["ID"],
                Grade = (int)reader["Grade"],
                Score = (int)reader["Score"],
                Rank = (int)reader["Rank"]
            };
        }

        public bool AddDailyLeagueRewardGroup(DailyLeagueRewardGroupInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Daily_League_Reward_Group]\r\n                                   ([ID]\r\n                                   ,[Grade]\r\n                                   ,[Score]\r\n                                   ,[Rank])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Grade\r\n                                   ,@Score\r\n                                   ,@Rank)", new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.Class),
          new SqlParameter("@Grade", (object) item.Grade),
          new SqlParameter("@Score", (object) item.Score),
          new SqlParameter("@Rank", (object) item.Rank)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddDailyLeagueRewardGroup: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateDailyLeagueRewardGroup(DailyLeagueRewardGroupInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Daily_League_Reward_Group]\r\n                               SET [Grade] = @Grade\r\n                                  ,[Score] = @Score\r\n                                  ,[Rank] = @Rank\r\n                            WHERE [ID] = @ID", new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.Class),
          new SqlParameter("@Grade", (object) item.Grade),
          new SqlParameter("@Score", (object) item.Score),
          new SqlParameter("@Rank", (object) item.Rank)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateDailyLeagueRewardGroup: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteDailyLeagueRewardGroup(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Daily_League_Reward_Group] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteDailyLeagueRewardGroup: " + ex.ToString());
            }
            return flag;
        }

        public DailyLeagueRewardItemInfo[] GetAllDailyLeagueRewardItem()
        {
            List<DailyLeagueRewardItemInfo> leagueRewardItemInfoList = new List<DailyLeagueRewardItemInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Daily_League_Reward_Item]");
                while (Sdr.Read())
                    leagueRewardItemInfoList.Add(this.InitDailyLeagueRewardItemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllDailyLeagueRewardItem " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return leagueRewardItemInfoList.ToArray();
        }

        public DailyLeagueRewardItemInfo InitDailyLeagueRewardItemInfo(
          SqlDataReader reader)
        {
            return new DailyLeagueRewardItemInfo()
            {
                ID = (int)reader["ID"],
                TemplateID = (int)reader["TemplateID"],
                StrengthLevel = (int)reader["StrengthLevel"],
                AttackCompose = (int)reader["AttackCompose"],
                DefendCompose = (int)reader["DefendCompose"],
                LuckCompose = (int)reader["LuckCompose"],
                AgilityCompose = (int)reader["AgilityCompose"],
                IsBind = (bool)reader["IsBind"],
                ValidDate = (int)reader["ValidDate"],
                Count = (int)reader["Count"],
                GroupId = (int)reader["GroupId"]
            };
        }

        public bool AddDailyLeagueRewardItem(DailyLeagueRewardItemInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Daily_League_Reward_Item]\r\n                                   ([TemplateID]\r\n                                   ,[StrengthLevel]\r\n                                   ,[AttackCompose]\r\n                                   ,[DefendCompose]\r\n                                   ,[LuckCompose]\r\n                                   ,[AgilityCompose]\r\n                                   ,[IsBind]\r\n                                   ,[ValidDate]\r\n                                   ,[Count]\r\n                                   ,[GroupId])\r\n                               VALUES\r\n                                   (@TemplateID\r\n                                   ,@StrengthLevel\r\n                                   ,@AttackCompose\r\n                                   ,@DefendCompose\r\n                                   ,@LuckCompose\r\n                                   ,@AgilityCompose\r\n                                   ,@IsBind\r\n                                   ,@ValidDate\r\n                                   ,@Count\r\n                                   ,@GroupId)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[11];
                SqlParameters[0] = new SqlParameter("@ID", (object)item.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@TemplateID", (object)item.TemplateID);
                SqlParameters[2] = new SqlParameter("@StrengthLevel", (object)item.StrengthLevel);
                SqlParameters[3] = new SqlParameter("@AttackCompose", (object)item.AttackCompose);
                SqlParameters[4] = new SqlParameter("@DefendCompose", (object)item.DefendCompose);
                SqlParameters[5] = new SqlParameter("@LuckCompose", (object)item.LuckCompose);
                SqlParameters[6] = new SqlParameter("@AgilityCompose", (object)item.AgilityCompose);
                SqlParameters[7] = new SqlParameter("@IsBind", (object)item.IsBind);
                SqlParameters[8] = new SqlParameter("@ValidDate", (object)item.ValidDate);
                SqlParameters[9] = new SqlParameter("@Count", (object)item.Count);
                SqlParameters[10] = new SqlParameter("@GroupId", (object)item.GroupId);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddDailyLeagueRewardItem: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateDailyLeagueRewardItem(DailyLeagueRewardItemInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Daily_League_Reward_Item]\r\n                               SET [TemplateID] = @TemplateID\r\n                                  ,[StrengthLevel] = @StrengthLevel\r\n                                  ,[AttackCompose] = @AttackCompose\r\n                                  ,[DefendCompose] = @DefendCompose\r\n                                  ,[LuckCompose] = @LuckCompose\r\n                                  ,[AgilityCompose] = @AgilityCompose\r\n                                  ,[IsBind] = @IsBind\r\n                                  ,[ValidDate] = @ValidDate\r\n                                  ,[Count] = @Count\r\n                                  ,[GroupId] = @GroupId\r\n                            WHERE [GroupId] = @GroupId AND [TemplateID] = @TemplateID", new SqlParameter[11]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@StrengthLevel", (object) item.StrengthLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@GroupId", (object) item.GroupId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateDailyLeagueRewardItem: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteDailyLeagueRewardItem(int templateId, int groupId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Daily_League_Reward_Item] WHERE [GroupId] = @GroupId AND [TemplateID] = @TemplateID", new SqlParameter[2]
                {
          new SqlParameter("@GroupId", (object) groupId),
          new SqlParameter("@TemplateID", (object) templateId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteDailyLeagueRewardItem: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteDailyLeagueRewardItem(int groupId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Daily_League_Reward_Item] WHERE [GroupId] = @GroupId", new SqlParameter[1]
                {
          new SqlParameter("@GroupId", (object) groupId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteDailyLeagueRewardItem: " + ex.ToString());
            }
            return flag;
        }

        public ItemBoxInfo[] GetAllItemBox()
        {
            List<ItemBoxInfo> itemBoxInfoList = new List<ItemBoxInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Shop_Goods_Box]");
                while (Sdr.Read())
                    itemBoxInfoList.Add(this.InitItemBoxInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllItemBox " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemBoxInfoList.ToArray();
        }

        public ItemBoxInfo[] GetSingleItemBox(int iD, int templateId)
        {
            List<ItemBoxInfo> itemBoxInfoList = new List<ItemBoxInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Shop_Goods_Box] WHERE ID = " + (object)iD + " AND TemplateId = " + (object)templateId);
                while (Sdr.Read())
                    itemBoxInfoList.Add(this.InitItemBoxInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllItemBoxBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemBoxInfoList.ToArray();
        }

        public ItemBoxInfo InitItemBoxInfo(SqlDataReader reader) => new ItemBoxInfo()
        {
            ID = (int)reader["ID"],
            TemplateId = (int)reader["TemplateId"],
            IsSelect = (bool)reader["IsSelect"],
            IsBind = (bool)reader["IsBind"],
            ItemValid = (int)reader["ItemValid"],
            ItemCount = (int)reader["ItemCount"],
            StrengthenLevel = (int)reader["StrengthenLevel"],
            AttackCompose = (int)reader["AttackCompose"],
            DefendCompose = (int)reader["DefendCompose"],
            AgilityCompose = (int)reader["AgilityCompose"],
            LuckCompose = (int)reader["LuckCompose"],
            Random = (int)reader["Random"],
            IsTips = (int)reader["IsTips"],
            IsLogs = (bool)reader["IsLogs"]
        };

        public bool AddItemBox(ItemBoxInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Shop_Goods_Box]\r\n                                   ([ID]\r\n                                   ,[TemplateId]\r\n                                   ,[IsSelect]\r\n                                   ,[IsBind]\r\n                                   ,[ItemValid]\r\n                                   ,[ItemCount]\r\n                                   ,[StrengthenLevel]\r\n                                   ,[AttackCompose]\r\n                                   ,[DefendCompose]\r\n                                   ,[AgilityCompose]\r\n                                   ,[LuckCompose]\r\n                                   ,[Random]\r\n                                   ,[IsTips]\r\n                                   ,[IsLogs]\r\n                                   ,[addDate])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@TemplateId\r\n                                   ,@IsSelect\r\n                                   ,@IsBind\r\n                                   ,@ItemValid\r\n                                   ,@ItemCount\r\n                                   ,@StrengthenLevel\r\n                                   ,@AttackCompose\r\n                                   ,@DefendCompose\r\n                                   ,@AgilityCompose\r\n                                   ,@LuckCompose\r\n                                   ,@Random\r\n                                   ,@IsTips\r\n                                   ,@IsLogs\r\n                                   ,@addDate)", new SqlParameter[15]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@TemplateId", (object) item.TemplateId),
          new SqlParameter("@IsSelect", (object) item.IsSelect),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@ItemValid", (object) item.ItemValid),
          new SqlParameter("@ItemCount", (object) item.ItemCount),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@Random", (object) item.Random),
          new SqlParameter("@IsTips", (object) item.IsTips),
          new SqlParameter("@IsLogs", (object) item.IsLogs),
          new SqlParameter("@addDate", (object) DateTime.Now)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddItemBox: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateItemBox(ItemBoxInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Shop_Goods_Box]\r\n                               SET [TemplateId] = @TemplateId\r\n                                  ,[IsSelect] = @IsSelect\r\n                                  ,[IsBind] = @IsBind\r\n                                  ,[ItemValid] = @ItemValid\r\n                                  ,[ItemCount] = @ItemCount\r\n                                  ,[StrengthenLevel] = @StrengthenLevel\r\n                                  ,[AttackCompose] = @AttackCompose\r\n                                  ,[DefendCompose] = @DefendCompose\r\n                                  ,[AgilityCompose] = @AgilityCompose\r\n                                  ,[LuckCompose] = @LuckCompose\r\n                                  ,[Random] = @Random\r\n                                  ,[IsTips] = @IsTips\r\n                                  ,[IsLogs] = @IsLogs\r\n                                  ,[addDate] = @addDate\r\n                            WHERE [ID] = @ID AND [TemplateId] = @TemplateId", new SqlParameter[15]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@TemplateId", (object) item.TemplateId),
          new SqlParameter("@IsSelect", (object) item.IsSelect),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@ItemValid", (object) item.ItemValid),
          new SqlParameter("@ItemCount", (object) item.ItemCount),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@Random", (object) item.Random),
          new SqlParameter("@IsTips", (object) item.IsTips),
          new SqlParameter("@IsLogs", (object) item.IsLogs),
          new SqlParameter("@addDate", (object) DateTime.Now)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateItemBox: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteItemBox(int id, int templateId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Shop_Goods_Box] WHERE [ID] = @ID AND [TemplateId] = @TemplateId", new SqlParameter[2]
                {
          new SqlParameter("@ID", (object) id),
          new SqlParameter("@TemplateId", (object) templateId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteItemBox: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteItemBox(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Shop_Goods_Box] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteItemBox: " + ex.ToString());
            }
            return flag;
        }

        public QuestInfo[] GetAllQuest()
        {
            List<QuestInfo> questInfoList = new List<QuestInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Quest]");
                while (Sdr.Read())
                    questInfoList.Add(this.InitQuestInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllQuest " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return questInfoList.ToArray();
        }

        public QuestInfo InitQuestInfo(SqlDataReader reader) => new QuestInfo()
        {
            ID = (int)reader["ID"],
            QuestID = (int)reader["QuestID"],
            Title = reader["Title"] == null ? "" : reader["Title"].ToString(),
            Detail = reader["Detail"] == null ? "" : reader["Detail"].ToString(),
            Objective = reader["Objective"] == null ? "" : reader["Objective"].ToString(),
            NeedMinLevel = (int)reader["NeedMinLevel"],
            NeedMaxLevel = (int)reader["NeedMaxLevel"],
            PreQuestID = reader["PreQuestID"] == null ? "" : reader["PreQuestID"].ToString(),
            NextQuestID = reader["NextQuestID"] == null ? "" : reader["NextQuestID"].ToString(),
            IsOther = (int)reader["IsOther"],
            CanRepeat = (bool)reader["CanRepeat"],
            RepeatInterval = (int)reader["RepeatInterval"],
            RepeatMax = (int)reader["RepeatMax"],
            RewardGP = (int)reader["RewardGP"],
            RewardGold = (int)reader["RewardGold"],
            RewardBindMoney = 0,
            RewardOffer = (int)reader["RewardOffer"],
            RewardRiches = (int)reader["RewardRiches"],
            RewardBuffID = (int)reader["RewardBuffID"],
            RewardBuffDate = (int)reader["RewardBuffDate"],
            RewardMoney = (int)reader["RewardMoney"],
            Rands = (Decimal)reader["Rands"],
            RandDouble = (int)reader["RandDouble"],
            TimeMode = (bool)reader["TimeMode"],
            StartDate = (DateTime)reader["StartDate"],
            EndDate = (DateTime)reader["EndDate"],
            MapID = (int)reader["MapID"],
            AutoEquip = (bool)reader["AutoEquip"],
            OneKeyFinishNeedMoney = 0,
            Rank = reader["Rank"] == null ? "" : reader["Rank"].ToString(),
            StarLev = (int)reader["StarLev"],
            NotMustCount = (int)reader["NotMustCount"],
            Level2NeedMoney = 0,
            Level3NeedMoney = 0,
            Level4NeedMoney = 0,
            Level5NeedMoney = 0,
            CollocationCost = 0,
            CollocationColdTime = 0,
            IsAccept = true
        };

        public bool AddQuest(QuestInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Quest]\r\n                                   ([ID]\r\n                                   ,[QuestID]\r\n                                   ,[Title]\r\n                                   ,[Detail]\r\n                                   ,[Objective]\r\n                                   ,[NeedMinLevel]\r\n                                   ,[NeedMaxLevel]\r\n                                   ,[PreQuestID]\r\n                                   ,[NextQuestID]\r\n                                   ,[IsOther]\r\n                                   ,[CanRepeat]\r\n                                   ,[RepeatInterval]\r\n                                   ,[RepeatMax]\r\n                                   ,[RewardGP]\r\n                                   ,[RewardGold]\r\n                                                ,[RewardOffer]\r\n                                   ,[RewardRiches]\r\n                                   ,[RewardBuffID]\r\n                                   ,[RewardBuffDate]\r\n                                   ,[RewardMoney]\r\n                                   ,[Rands]\r\n                                   ,[RandDouble]\r\n                                   ,[TimeMode]\r\n                                   ,[StartDate]\r\n                                   ,[EndDate]\r\n                                   ,[MapID]\r\n                                   ,[AutoEquip]\r\n                               ,[Rank]\r\n                                   ,[StarLev]\r\n                                   ,[NotMustCount])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@QuestID\r\n                                   ,@Title\r\n                                   ,@Detail\r\n                                   ,@Objective\r\n                                   ,@NeedMinLevel\r\n                                   ,@NeedMaxLevel\r\n                                   ,@PreQuestID\r\n                                   ,@NextQuestID\r\n                                   ,@IsOther\r\n                                   ,@CanRepeat\r\n                                   ,@RepeatInterval\r\n                                   ,@RepeatMax\r\n                                   ,@RewardGP\r\n                                   ,@RewardGold\r\n                                                                   ,@RewardOffer\r\n                                   ,@RewardRiches\r\n                                   ,@RewardBuffID\r\n                                   ,@RewardBuffDate\r\n                                   ,@RewardMoney\r\n                                   ,@Rands\r\n                                   ,@RandDouble\r\n                                   ,@TimeMode\r\n                                   ,@StartDate\r\n                                   ,@EndDate\r\n                                   ,@MapID\r\n                                   ,@AutoEquip\r\n                                                                     ,@Rank\r\n                                   ,@StarLev\r\n                                   ,@NotMustCount)", new SqlParameter[30]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@QuestID", (object) item.QuestID),
          new SqlParameter("@Title", (object) item.Title),
          new SqlParameter("@Detail", (object) item.Detail),
          new SqlParameter("@Objective", (object) item.Objective),
          new SqlParameter("@NeedMinLevel", (object) item.NeedMinLevel),
          new SqlParameter("@NeedMaxLevel", (object) item.NeedMaxLevel),
          new SqlParameter("@PreQuestID", (object) item.PreQuestID),
          new SqlParameter("@NextQuestID", (object) item.NextQuestID),
          new SqlParameter("@IsOther", (object) item.IsOther),
          new SqlParameter("@CanRepeat", (object) item.CanRepeat),
          new SqlParameter("@RepeatInterval", (object) item.RepeatInterval),
          new SqlParameter("@RepeatMax", (object) item.RepeatMax),
          new SqlParameter("@RewardGP", (object) item.RewardGP),
          new SqlParameter("@RewardGold", (object) item.RewardGold),
          new SqlParameter("@RewardOffer", (object) item.RewardOffer),
          new SqlParameter("@RewardRiches", (object) item.RewardRiches),
          new SqlParameter("@RewardBuffID", (object) item.RewardBuffID),
          new SqlParameter("@RewardBuffDate", (object) item.RewardBuffDate),
          new SqlParameter("@RewardMoney", (object) item.RewardMoney),
          new SqlParameter("@Rands", (object) item.Rands),
          new SqlParameter("@RandDouble", (object) item.RandDouble),
          new SqlParameter("@TimeMode", (object) item.TimeMode),
          new SqlParameter("@StartDate", (object) item.StartDate),
          new SqlParameter("@EndDate", (object) item.EndDate),
          new SqlParameter("@MapID", (object) item.MapID),
          new SqlParameter("@AutoEquip", (object) item.AutoEquip),
          new SqlParameter("@Rank", (object) item.Rank),
          new SqlParameter("@StarLev", (object) item.StarLev),
          new SqlParameter("@NotMustCount", (object) item.NotMustCount)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddQuest: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateQuest(QuestInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Quest]\r\n                               SET [ID] = @ID\r\n                                  ,[QuestID] = @QuestID\r\n                                  ,[Title] = @Title\r\n                                  ,[Detail] = @Detail\r\n                                  ,[Objective] = @Objective\r\n                                  ,[NeedMinLevel] = @NeedMinLevel\r\n                                  ,[NeedMaxLevel] = @NeedMaxLevel\r\n                                  ,[PreQuestID] = @PreQuestID\r\n                                  ,[NextQuestID] = @NextQuestID\r\n                                  ,[IsOther] = @IsOther\r\n                                  ,[CanRepeat] = @CanRepeat\r\n                                  ,[RepeatInterval] = @RepeatInterval\r\n                                  ,[RepeatMax] = @RepeatMax\r\n                                  ,[RewardGP] = @RewardGP\r\n                                  ,[RewardGold] = @RewardGold\r\n                                  ,[RewardOffer] = @RewardOffer\r\n                                  ,[RewardRiches] = @RewardRiches\r\n                                  ,[RewardBuffID] = @RewardBuffID\r\n                                  ,[RewardBuffDate] = @RewardBuffDate\r\n                                  ,[RewardMoney] = @RewardMoney\r\n                                  ,[Rands] = @Rands\r\n                                  ,[RandDouble] = @RandDouble\r\n                                  ,[TimeMode] = @TimeMode\r\n                                  ,[StartDate] = @StartDate\r\n                                  ,[EndDate] = @EndDate\r\n                                  ,[MapID] = @MapID\r\n                                  ,[AutoEquip] = @AutoEquip\r\n                                                          ,[Rank] = @Rank\r\n                                  ,[StarLev] = @StarLev\r\n                                  ,[NotMustCount] = @NotMustCount\r\n                                                             WHERE [ID] = @ID", new SqlParameter[30]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@QuestID", (object) item.QuestID),
          new SqlParameter("@Title", (object) item.Title),
          new SqlParameter("@Detail", (object) item.Detail),
          new SqlParameter("@Objective", (object) item.Objective),
          new SqlParameter("@NeedMinLevel", (object) item.NeedMinLevel),
          new SqlParameter("@NeedMaxLevel", (object) item.NeedMaxLevel),
          new SqlParameter("@PreQuestID", (object) item.PreQuestID),
          new SqlParameter("@NextQuestID", (object) item.NextQuestID),
          new SqlParameter("@IsOther", (object) item.IsOther),
          new SqlParameter("@CanRepeat", (object) item.CanRepeat),
          new SqlParameter("@RepeatInterval", (object) item.RepeatInterval),
          new SqlParameter("@RepeatMax", (object) item.RepeatMax),
          new SqlParameter("@RewardGP", (object) item.RewardGP),
          new SqlParameter("@RewardGold", (object) item.RewardGold),
          new SqlParameter("@RewardOffer", (object) item.RewardOffer),
          new SqlParameter("@RewardRiches", (object) item.RewardRiches),
          new SqlParameter("@RewardBuffID", (object) item.RewardBuffID),
          new SqlParameter("@RewardBuffDate", (object) item.RewardBuffDate),
          new SqlParameter("@RewardMoney", (object) item.RewardMoney),
          new SqlParameter("@Rands", (object) item.Rands),
          new SqlParameter("@RandDouble", (object) item.RandDouble),
          new SqlParameter("@TimeMode", (object) item.TimeMode),
          new SqlParameter("@StartDate", (object) item.StartDate),
          new SqlParameter("@EndDate", (object) item.EndDate),
          new SqlParameter("@MapID", (object) item.MapID),
          new SqlParameter("@AutoEquip", (object) item.AutoEquip),
          new SqlParameter("@Rank", (object) item.Rank),
          new SqlParameter("@StarLev", (object) item.StarLev),
          new SqlParameter("@NotMustCount", (object) item.NotMustCount)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateQuest: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteQuest(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Quest] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteQuest: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllQuest()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Quest]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteQuest: " + ex.ToString());
            }
            return flag;
        }

        public QuestConditionInfo[] GetAllQuestCondiction()
        {
            List<QuestConditionInfo> questConditionInfoList = new List<QuestConditionInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Quest_Condiction]");
                while (Sdr.Read())
                    questConditionInfoList.Add(this.InitQuestConditionInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllQuestCondiction " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return questConditionInfoList.ToArray();
        }

        public QuestConditionInfo InitQuestConditionInfo(SqlDataReader reader) => new QuestConditionInfo()
        {
            QuestID = (int)reader["QuestID"],
            CondictionID = (int)reader["CondictionID"],
            CondictionType = (int)reader["CondictionType"],
            CondictionTitle = reader["CondictionTitle"] == null ? "" : reader["CondictionTitle"].ToString(),
            Para1 = (int)reader["Para1"],
            Para2 = (int)reader["Para2"],
            isOpitional = (bool)reader["isOpitional"]
        };

        public bool AddQuestCondiction(QuestConditionInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Quest_Condiction]\r\n                                   ([QuestID]\r\n                                   ,[CondictionID]\r\n                                   ,[CondictionType]\r\n                                   ,[CondictionTitle]\r\n                                   ,[Para1]\r\n                                   ,[Para2]\r\n                                   ,[isOpitional])\r\n                               VALUES\r\n                                   (@QuestID\r\n                                   ,@CondictionID\r\n                                   ,@CondictionType\r\n                                   ,@CondictionTitle\r\n                                   ,@Para1\r\n                                   ,@Para2\r\n                                   ,@isOpitional)", new SqlParameter[7]
                {
          new SqlParameter("@QuestID", (object) item.QuestID),
          new SqlParameter("@CondictionID", (object) item.CondictionID),
          new SqlParameter("@CondictionType", (object) item.CondictionType),
          new SqlParameter("@CondictionTitle", (object) item.CondictionTitle),
          new SqlParameter("@Para1", (object) item.Para1),
          new SqlParameter("@Para2", (object) item.Para2),
          new SqlParameter("@isOpitional", (object) item.isOpitional)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddQuestCondiction: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateQuestCondiction(QuestConditionInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Quest_Condiction]\r\n                               SET [QuestID] = @QuestID\r\n                                  ,[CondictionID] = @CondictionID\r\n                                  ,[CondictionType] = @CondictionType\r\n                                  ,[CondictionTitle] = @CondictionTitle\r\n                                  ,[Para1] = @Para1\r\n                                  ,[Para2] = @Para2\r\n                                  ,[isOpitional] = @isOpitional\r\n                            WHERE [QuestID] = @QuestID AND [CondictionID] = @CondictionID", new SqlParameter[7]
                {
          new SqlParameter("@QuestID", (object) item.QuestID),
          new SqlParameter("@CondictionID", (object) item.CondictionID),
          new SqlParameter("@CondictionType", (object) item.CondictionType),
          new SqlParameter("@CondictionTitle", (object) item.CondictionTitle),
          new SqlParameter("@Para1", (object) item.Para1),
          new SqlParameter("@Para2", (object) item.Para2),
          new SqlParameter("@isOpitional", (object) item.isOpitional)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateQuestCondiction: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteQuestCondiction(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Quest_Condiction] WHERE [QuestID] = @QuestID", new SqlParameter[1]
                {
          new SqlParameter("@QuestID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteQuestCondiction: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteQuestCondiction(int id, int conditionId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Quest_Condiction] WHERE [QuestID] = @QuestID AND [CondictionID] = @CondictionID", new SqlParameter[2]
                {
          new SqlParameter("@QuestID", (object) id),
          new SqlParameter("@CondictionID", (object) conditionId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteQuestCondiction: " + ex.ToString());
            }
            return flag;
        }

        public QuestAwardInfo[] GetAllQuestAward()
        {
            List<QuestAwardInfo> questAwardInfoList = new List<QuestAwardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Quest_Goods]");
                while (Sdr.Read())
                    questAwardInfoList.Add(this.InitQuestAwardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllQuestAward " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return questAwardInfoList.ToArray();
        }

        public QuestAwardInfo InitQuestAwardInfo(SqlDataReader reader) => new QuestAwardInfo()
        {
            QuestID = (int)reader["QuestID"],
            RewardItemID = (int)reader["RewardItemID"],
            IsSelect = (bool)reader["IsSelect"],
            RewardItemValid = (int)reader["RewardItemValid"],
            RewardItemCount = (int)reader["RewardItemCount"],
            RewardItemCount1 = 0,
            RewardItemCount2 = 0,
            RewardItemCount3 = 0,
            RewardItemCount4 = 0,
            RewardItemCount5 = 0,
            StrengthenLevel = (int)reader["StrengthenLevel"],
            AttackCompose = (int)reader["AttackCompose"],
            DefendCompose = (int)reader["DefendCompose"],
            AgilityCompose = (int)reader["AgilityCompose"],
            LuckCompose = (int)reader["LuckCompose"],
            IsCount = (bool)reader["IsCount"],
            IsBind = (bool)reader["IsBind"],
            MagicAttack = 0,
            MagicDefence = 0
        };

        public QuestAwardInfo[] GetAllQuestAwardOld()
        {
            List<QuestAwardInfo> questAwardInfoList = new List<QuestAwardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Quest_Goods]");
                while (Sdr.Read())
                    questAwardInfoList.Add(this.InitQuestAwardInfoOld(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllQuestAward " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return questAwardInfoList.ToArray();
        }

        public QuestAwardInfo InitQuestAwardInfoOld(SqlDataReader reader) => new QuestAwardInfo()
        {
            QuestID = (int)reader["QuestID"],
            RewardItemID = (int)reader["RewardItemID"],
            IsSelect = (bool)reader["IsSelect"],
            RewardItemValid = (int)reader["RewardItemValid"],
            RewardItemCount = (int)reader["RewardItemCount"],
            StrengthenLevel = (int)reader["StrengthenLevel"],
            AttackCompose = (int)reader["AttackCompose"],
            DefendCompose = (int)reader["DefendCompose"],
            AgilityCompose = (int)reader["AgilityCompose"],
            LuckCompose = (int)reader["LuckCompose"],
            IsCount = (bool)reader["IsCount"],
            IsBind = (bool)reader["IsBind"],
            MagicAttack = 0,
            MagicDefence = 0
        };

        public bool AddQuestAward(QuestAwardInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Quest_Goods]\r\n                                   ([QuestID]\r\n                                   ,[RewardItemID]\r\n                                   ,[IsSelect]\r\n                                   ,[RewardItemValid]\r\n    ,[StrengthenLevel]\r\n                                   ,[AttackCompose]\r\n                                   ,[DefendCompose]\r\n                                   ,[AgilityCompose]\r\n                                   ,[LuckCompose]\r\n                                   ,[IsCount]\r\n                                   ,[IsBind],[RewardItemCount])\r\n                               VALUES\r\n                                   (@QuestID\r\n                                   ,@RewardItemID\r\n                                   ,@IsSelect\r\n                                   ,@RewardItemValid\r\n                                 ,@StrengthenLevel\r\n                                   ,@AttackCompose\r\n                                   ,@DefendCompose\r\n                                   ,@AgilityCompose\r\n                                   ,@LuckCompose\r\n                                   ,@IsCount\r\n                                   ,@IsBind,@RewardItemCount)", new SqlParameter[12]
                {
          new SqlParameter("@QuestID", (object) item.QuestID),
          new SqlParameter("@RewardItemID", (object) item.RewardItemID),
          new SqlParameter("@IsSelect", (object) item.IsSelect),
          new SqlParameter("@RewardItemValid", (object) item.RewardItemValid),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@IsCount", (object) item.IsCount),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@RewardItemCount", (object) item.RewardItemCount1)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddQuestAward: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateQuestAward(QuestAwardInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Quest_Goods]\r\n                               SET [QuestID] = @QuestID\r\n                                  ,[RewardItemID] = @RewardItemID\r\n                                  ,[IsSelect] = @IsSelect\r\n                                  ,[RewardItemValid] = @RewardItemValid\r\n,[StrengthenLevel] = @StrengthenLevel\r\n                                  ,[AttackCompose] = @AttackCompose\r\n                                  ,[DefendCompose] = @DefendCompose\r\n                                  ,[AgilityCompose] = @AgilityCompose\r\n                                  ,[LuckCompose] = @LuckCompose\r\n                                  ,[IsCount] = @IsCount\r\n                                  ,[IsBind] = @IsBind\r\n   ,[RewardItemCount] = @RewardItemCount\r\n                        WHERE [QuestID] = @QuestID AND [RewardItemID] = @RewardItemID", new SqlParameter[12]
                {
          new SqlParameter("@QuestID", (object) item.QuestID),
          new SqlParameter("@RewardItemID", (object) item.RewardItemID),
          new SqlParameter("@IsSelect", (object) item.IsSelect),
          new SqlParameter("@RewardItemValid", (object) item.RewardItemValid),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@IsCount", (object) item.IsCount),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@RewardItemCount", (object) item.RewardItemCount1)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateQuestAward: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteQuestAward(int questID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Quest_Goods] WHERE [QuestID] = @QuestID", new SqlParameter[1]
                {
          new SqlParameter("@QuestID", (object) questID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteQuestAward: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteQuestAward(int questID, int goodId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Quest_Goods] WHERE [QuestID] = @QuestID AND [RewardItemID] = @RewardItemID", new SqlParameter[2]
                {
          new SqlParameter("@QuestID", (object) questID),
          new SqlParameter("@RewardItemID", (object) goodId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteQuestAward: " + ex.ToString());
            }
            return flag;
        }

        public QuestRateInfo GetAllQuestRate()
        {
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Quest_Rate]");
                if (Sdr.Read())
                    return this.InitQuestRateInfo(Sdr);
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllQuestRate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return (QuestRateInfo)null;
        }

        public QuestRateInfo InitQuestRateInfo(SqlDataReader reader) => new QuestRateInfo()
        {
            BindMoneyRate = reader["BindMoneyRate"] == null ? "" : reader["BindMoneyRate"].ToString(),
            ExpRate = reader["ExpRate"] == null ? "" : reader["ExpRate"].ToString(),
            GoldRate = reader["GoldRate"] == null ? "" : reader["GoldRate"].ToString(),
            ExploitRate = reader["ExploitRate"] == null ? "" : reader["ExploitRate"].ToString(),
            CanOneKeyFinishTime = (int)reader["CanOneKeyFinishTime"]
        };

        public bool AddQuestRate(QuestRateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Quest_Rate]\r\n                                   ([BindMoneyRate]\r\n                                   ,[ExpRate]\r\n                                   ,[GoldRate]\r\n                                   ,[ExploitRate]\r\n                                   ,[CanOneKeyFinishTime])\r\n                               VALUES\r\n                                   (@BindMoneyRate\r\n                                   ,@ExpRate\r\n                                   ,@GoldRate\r\n                                   ,@ExploitRate\r\n                                   ,@CanOneKeyFinishTime)", new SqlParameter[5]
                {
          new SqlParameter("@BindMoneyRate", (object) item.BindMoneyRate),
          new SqlParameter("@ExpRate", (object) item.ExpRate),
          new SqlParameter("@GoldRate", (object) item.GoldRate),
          new SqlParameter("@ExploitRate", (object) item.ExploitRate),
          new SqlParameter("@CanOneKeyFinishTime", (object) item.CanOneKeyFinishTime)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddQuestRate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateQuestRate(QuestRateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Quest_Rate]\r\n                               SET [BindMoneyRate] = @BindMoneyRate\r\n                                  ,[ExpRate] = @ExpRate\r\n                                  ,[GoldRate] = @GoldRate\r\n                                  ,[ExploitRate] = @ExploitRate\r\n                                  ,[CanOneKeyFinishTime] = @CanOneKeyFinishTime\r\n                            WHERE [BindMoneyRate] > 0", new SqlParameter[5]
                {
          new SqlParameter("@BindMoneyRate", (object) item.BindMoneyRate),
          new SqlParameter("@ExpRate", (object) item.ExpRate),
          new SqlParameter("@GoldRate", (object) item.GoldRate),
          new SqlParameter("@ExploitRate", (object) item.ExploitRate),
          new SqlParameter("@CanOneKeyFinishTime", (object) item.CanOneKeyFinishTime)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateQuestRate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllQuestRate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Quest_Rate]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteQuestRate: " + ex.ToString());
            }
            return flag;
        }

        public ConsortiaBadgeConfigInfo[] GetAllConsortiaBadgeConfig()
        {
            List<ConsortiaBadgeConfigInfo> consortiaBadgeConfigInfoList = new List<ConsortiaBadgeConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Consortia_Badge_Config]");
                while (Sdr.Read())
                    consortiaBadgeConfigInfoList.Add(this.InitConsortiaBadgeConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllConsortiaBadgeConfig " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return consortiaBadgeConfigInfoList.ToArray();
        }

        public ConsortiaBadgeConfigInfo[] GetAllConsortiaBadgeConfigBy(int id)
        {
            List<ConsortiaBadgeConfigInfo> consortiaBadgeConfigInfoList = new List<ConsortiaBadgeConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Consortia_Badge_Config] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    consortiaBadgeConfigInfoList.Add(this.InitConsortiaBadgeConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllConsortiaBadgeConfigBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return consortiaBadgeConfigInfoList.ToArray();
        }

        public ConsortiaBadgeConfigInfo GetSingleConsortiaBadgeConfig(int id)
        {
            List<ConsortiaBadgeConfigInfo> consortiaBadgeConfigInfoList = new List<ConsortiaBadgeConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Consortia_Badge_Config] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    consortiaBadgeConfigInfoList.Add(this.InitConsortiaBadgeConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleConsortiaBadgeConfig " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return consortiaBadgeConfigInfoList.Count > 0 ? consortiaBadgeConfigInfoList[0] : (ConsortiaBadgeConfigInfo)null;
        }

        public ConsortiaBadgeConfigInfo InitConsortiaBadgeConfigInfo(
          SqlDataReader reader)
        {
            return new ConsortiaBadgeConfigInfo()
            {
                BadgeID = (int)reader["BadgeID"],
                BadgeName = reader["BadgeName"] == null ? "" : reader["BadgeName"].ToString(),
                Cost = (int)reader["Cost"],
                LimitLevel = (int)reader["LimitLevel"],
                ValidDate = (int)reader["ValidDate"]
            };
        }

        public bool AddConsortiaBadgeConfig(ConsortiaBadgeConfigInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Consortia_Badge_Config]\r\n                                   ([BadgeID]\r\n                                   ,[BadgeName]\r\n                                   ,[Cost]\r\n                                   ,[LimitLevel]\r\n                                   ,[ValidDate])\r\n                               VALUES\r\n                                   (@BadgeID\r\n                                   ,@BadgeName\r\n                                   ,@Cost\r\n                                   ,@LimitLevel\r\n                                   ,@ValidDate)", new SqlParameter[5]
                {
          new SqlParameter("@BadgeID", (object) item.BadgeID),
          new SqlParameter("@BadgeName", (object) item.BadgeName),
          new SqlParameter("@Cost", (object) item.Cost),
          new SqlParameter("@LimitLevel", (object) item.LimitLevel),
          new SqlParameter("@ValidDate", (object) item.ValidDate)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddConsortiaBadgeConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateConsortiaBadgeConfig(ConsortiaBadgeConfigInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Consortia_Badge_Config]\r\n                               SET [BadgeID] = @BadgeID\r\n                                  ,[BadgeName] = @BadgeName\r\n                                  ,[Cost] = @Cost\r\n                                  ,[LimitLevel] = @LimitLevel\r\n                                  ,[ValidDate] = @ValidDate\r\n                            WHERE [ID] = @ID", new SqlParameter[5]
                {
          new SqlParameter("@BadgeID", (object) item.BadgeID),
          new SqlParameter("@BadgeName", (object) item.BadgeName),
          new SqlParameter("@Cost", (object) item.Cost),
          new SqlParameter("@LimitLevel", (object) item.LimitLevel),
          new SqlParameter("@ValidDate", (object) item.ValidDate)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateConsortiaBadgeConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteConsortiaBadgeConfig(int badgeId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Consortia_Badge_Config] WHERE [BadgeID] = @BadgeID", new SqlParameter[1]
                {
          new SqlParameter("@BadgeID", (object) badgeId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteConsortiaBadgeConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllConsortiaBadgeConfig()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Consortia_Badge_Config]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteConsortiaBadgeConfig: " + ex.ToString());
            }
            return flag;
        }

        public ConsortiaBossConfigInfo[] GetAllConsortiaBossConfig()
        {
            List<ConsortiaBossConfigInfo> consortiaBossConfigInfoList = new List<ConsortiaBossConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Consortia_Boss_Config]");
                while (Sdr.Read())
                    consortiaBossConfigInfoList.Add(this.InitConsortiaBossConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllConsortiaBossConfig " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return consortiaBossConfigInfoList.ToArray();
        }

        public ConsortiaBossConfigInfo[] GetAllConsortiaBossConfigBy(int id)
        {
            List<ConsortiaBossConfigInfo> consortiaBossConfigInfoList = new List<ConsortiaBossConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Consortia_Boss_Config] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    consortiaBossConfigInfoList.Add(this.InitConsortiaBossConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllConsortiaBossConfigBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return consortiaBossConfigInfoList.ToArray();
        }

        public ConsortiaBossConfigInfo GetSingleConsortiaBossConfig(int id)
        {
            List<ConsortiaBossConfigInfo> consortiaBossConfigInfoList = new List<ConsortiaBossConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Consortia_Boss_Config] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    consortiaBossConfigInfoList.Add(this.InitConsortiaBossConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleConsortiaBossConfig " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return consortiaBossConfigInfoList.Count > 0 ? consortiaBossConfigInfoList[0] : (ConsortiaBossConfigInfo)null;
        }

        public ConsortiaBossConfigInfo InitConsortiaBossConfigInfo(
          SqlDataReader reader)
        {
            return new ConsortiaBossConfigInfo()
            {
                Level = (int)reader["Level"],
                NpcID = (int)reader["NpcID"],
                MissionID = (int)reader["MissionID"],
                AwardID = (int)reader["AwardID"],
                CostRich = (int)reader["CostRich"],
                ProlongRich = (int)reader["ProlongRich"],
                BossLevel = (int)reader["BossLevel"]
            };
        }

        public bool AddConsortiaBossConfig(ConsortiaBossConfigInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Consortia_Boss_Config]\r\n                                   ([Level]\r\n                                   ,[NpcID]\r\n                                   ,[MissionID]\r\n                                   ,[AwardID]\r\n                                   ,[CostRich]\r\n                                   ,[ProlongRich]\r\n                                   ,[BossLevel])\r\n                               VALUES\r\n                                   (@Level\r\n                                   ,@NpcID\r\n                                   ,@MissionID\r\n                                   ,@AwardID\r\n                                   ,@CostRich\r\n                                   ,@ProlongRich\r\n                                   ,@BossLevel)", new SqlParameter[7]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@NpcID", (object) item.NpcID),
          new SqlParameter("@MissionID", (object) item.MissionID),
          new SqlParameter("@AwardID", (object) item.AwardID),
          new SqlParameter("@CostRich", (object) item.CostRich),
          new SqlParameter("@ProlongRich", (object) item.ProlongRich),
          new SqlParameter("@BossLevel", (object) item.BossLevel)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddConsortiaBossConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateConsortiaBossConfig(ConsortiaBossConfigInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Consortia_Boss_Config]\r\n                               SET [Level] = @Level\r\n                                  ,[NpcID] = @NpcID\r\n                                  ,[MissionID] = @MissionID\r\n                                  ,[AwardID] = @AwardID\r\n                                  ,[CostRich] = @CostRich\r\n                                  ,[ProlongRich] = @ProlongRich\r\n                                  ,[BossLevel] = @BossLevel\r\n                            WHERE [ID] = @ID", new SqlParameter[7]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@NpcID", (object) item.NpcID),
          new SqlParameter("@MissionID", (object) item.MissionID),
          new SqlParameter("@AwardID", (object) item.AwardID),
          new SqlParameter("@CostRich", (object) item.CostRich),
          new SqlParameter("@ProlongRich", (object) item.ProlongRich),
          new SqlParameter("@BossLevel", (object) item.BossLevel)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateConsortiaBossConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteConsortiaBossConfig(int level)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Consortia_Boss_Config] WHERE [Level] = @Level", new SqlParameter[1]
                {
          new SqlParameter("@Level", (object) level)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteConsortiaBossConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllConsortiaBossConfig()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Consortia_Boss_Config]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteConsortiaBossConfig: " + ex.ToString());
            }
            return flag;
        }

        public ConsortiaBufferTempInfo[] GetAllConsortiaBufferTemp()
        {
            List<ConsortiaBufferTempInfo> consortiaBufferTempInfoList = new List<ConsortiaBufferTempInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Consortia_Buff_Temp]");
                while (Sdr.Read())
                    consortiaBufferTempInfoList.Add(this.InitConsortiaBufferTempInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllConsortiaBufferTemp " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return consortiaBufferTempInfoList.ToArray();
        }

        public ConsortiaBufferTempInfo[] GetAllConsortiaBufferTempBy(int id)
        {
            List<ConsortiaBufferTempInfo> consortiaBufferTempInfoList = new List<ConsortiaBufferTempInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Consortia_Buff_Temp] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    consortiaBufferTempInfoList.Add(this.InitConsortiaBufferTempInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllConsortiaBufferTempBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return consortiaBufferTempInfoList.ToArray();
        }

        public ConsortiaBufferTempInfo GetSingleConsortiaBufferTemp(int id)
        {
            List<ConsortiaBufferTempInfo> consortiaBufferTempInfoList = new List<ConsortiaBufferTempInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Consortia_Buff_Temp] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    consortiaBufferTempInfoList.Add(this.InitConsortiaBufferTempInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleConsortiaBufferTemp " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return consortiaBufferTempInfoList.Count > 0 ? consortiaBufferTempInfoList[0] : (ConsortiaBufferTempInfo)null;
        }

        public ConsortiaBufferTempInfo InitConsortiaBufferTempInfo(
          SqlDataReader reader)
        {
            return new ConsortiaBufferTempInfo()
            {
                id = (int)reader["id"],
                name = reader["name"] == null ? "" : reader["name"].ToString(),
                descript = reader["descript"] == null ? "" : reader["descript"].ToString(),
                type = (int)reader["type"],
                level = (int)reader["level"],
                value = (int)reader["value"],
                riches = (int)reader["riches"],
                metal = (int)reader["metal"],
                pic = (int)reader["pic"],
                group = (int)reader["group"]
            };
        }

        public bool AddConsortiaBufferTemp(ConsortiaBufferTempInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Consortia_Buff_Temp]\r\n                                   ([id]\r\n                                   ,[name]\r\n                                   ,[descript]\r\n                                   ,[type]\r\n                                   ,[level]\r\n                                   ,[value]\r\n                                   ,[riches]\r\n                                   ,[metal]\r\n                                   ,[pic]\r\n                                   ,[group])\r\n                               VALUES\r\n                                   (@id\r\n                                   ,@name\r\n                                   ,@descript\r\n                                   ,@type\r\n                                   ,@level\r\n                                   ,@value\r\n                                   ,@riches\r\n                                   ,@metal\r\n                                   ,@pic\r\n                                   ,@group)", new SqlParameter[10]
                {
          new SqlParameter("@id", (object) item.id),
          new SqlParameter("@name", (object) item.name),
          new SqlParameter("@descript", (object) item.descript),
          new SqlParameter("@type", (object) item.type),
          new SqlParameter("@level", (object) item.level),
          new SqlParameter("@value", (object) item.value),
          new SqlParameter("@riches", (object) item.riches),
          new SqlParameter("@metal", (object) item.metal),
          new SqlParameter("@pic", (object) item.pic),
          new SqlParameter("@group", (object) item.group)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddConsortiaBufferTemp: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateConsortiaBufferTemp(ConsortiaBufferTempInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Consortia_Buff_Temp]\r\n                               SET [id] = @id\r\n                                  ,[name] = @name\r\n                                  ,[descript] = @descript\r\n                                  ,[type] = @type\r\n                                  ,[level] = @level\r\n                                  ,[value] = @value\r\n                                  ,[riches] = @riches\r\n                                  ,[metal] = @metal\r\n                                  ,[pic] = @pic\r\n                                  ,[group] = @group\r\n                            WHERE [ID] = @ID", new SqlParameter[10]
                {
          new SqlParameter("@id", (object) item.id),
          new SqlParameter("@name", (object) item.name),
          new SqlParameter("@descript", (object) item.descript),
          new SqlParameter("@type", (object) item.type),
          new SqlParameter("@level", (object) item.level),
          new SqlParameter("@value", (object) item.value),
          new SqlParameter("@riches", (object) item.riches),
          new SqlParameter("@metal", (object) item.metal),
          new SqlParameter("@pic", (object) item.pic),
          new SqlParameter("@group", (object) item.group)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateConsortiaBufferTemp: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteConsortiaBufferTemp(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Consortia_Buff_Temp] WHERE [id] = @id", new SqlParameter[1]
                {
          new SqlParameter("@id", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteConsortiaBufferTemp: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllConsortiaBufferTemp()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Consortia_Buff_Temp]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteConsortiaBufferTemp: " + ex.ToString());
            }
            return flag;
        }

        public ClothPropertyTemplateInfo[] GetAllClothPropertyTemplate()
        {
            List<ClothPropertyTemplateInfo> propertyTemplateInfoList = new List<ClothPropertyTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Cloth_Property_Template]");
                while (Sdr.Read())
                    propertyTemplateInfoList.Add(this.InitClothPropertyTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllClothPropertyTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return propertyTemplateInfoList.ToArray();
        }

        public ClothPropertyTemplateInfo[] GetAllClothPropertyTemplateBy(int id)
        {
            List<ClothPropertyTemplateInfo> propertyTemplateInfoList = new List<ClothPropertyTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Cloth_Property_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    propertyTemplateInfoList.Add(this.InitClothPropertyTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllClothPropertyTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return propertyTemplateInfoList.ToArray();
        }

        public ClothPropertyTemplateInfo GetSingleClothPropertyTemplate(int id)
        {
            List<ClothPropertyTemplateInfo> propertyTemplateInfoList = new List<ClothPropertyTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Cloth_Property_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    propertyTemplateInfoList.Add(this.InitClothPropertyTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleClothPropertyTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return propertyTemplateInfoList.Count > 0 ? propertyTemplateInfoList[0] : (ClothPropertyTemplateInfo)null;
        }

        public ClothPropertyTemplateInfo InitClothPropertyTemplateInfo(
          SqlDataReader reader)
        {
            return new ClothPropertyTemplateInfo()
            {
                ID = (int)reader["ID"],
                Sex = (int)reader["Sex"],
                Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
                Attack = (int)reader["Attack"],
                Defend = (int)reader["Defend"],
                Agility = (int)reader["Agility"],
                Luck = (int)reader["Luck"],
                Blood = (int)reader["Blood"],
                Damage = (int)reader["Damage"],
                Guard = (int)reader["Guard"],
                Cost = (int)reader["Cost"]
            };
        }

        public bool AddClothPropertyTemplate(ClothPropertyTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Cloth_Property_Template]\r\n                                   ([ID]\r\n                                   ,[Sex]\r\n                                   ,[Name]\r\n                                   ,[Attack]\r\n                                   ,[Defend]\r\n                                   ,[Agility]\r\n                                   ,[Luck]\r\n                                   ,[Blood]\r\n                                   ,[Damage]\r\n                                   ,[Guard]\r\n                                   ,[Cost])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Sex\r\n                                   ,@Name\r\n                                   ,@Attack\r\n                                   ,@Defend\r\n                                   ,@Agility\r\n                                   ,@Luck\r\n                                   ,@Blood\r\n                                   ,@Damage\r\n                                   ,@Guard\r\n                                   ,@Cost)", new SqlParameter[11]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Sex", (object) item.Sex),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defend", (object) item.Defend),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Luck", (object) item.Luck),
          new SqlParameter("@Blood", (object) item.Blood),
          new SqlParameter("@Damage", (object) item.Damage),
          new SqlParameter("@Guard", (object) item.Guard),
          new SqlParameter("@Cost", (object) item.Cost)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddClothPropertyTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateClothPropertyTemplate(ClothPropertyTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Cloth_Property_Template]\r\n                               SET [ID] = @ID\r\n                                  ,[Sex] = @Sex\r\n                                  ,[Name] = @Name\r\n                                  ,[Attack] = @Attack\r\n                                  ,[Defend] = @Defend\r\n                                  ,[Agility] = @Agility\r\n                                  ,[Luck] = @Luck\r\n                                  ,[Blood] = @Blood\r\n                                  ,[Damage] = @Damage\r\n                                  ,[Guard] = @Guard\r\n                                  ,[Cost] = @Cost\r\n                            WHERE [ID] = @ID", new SqlParameter[11]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Sex", (object) item.Sex),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defend", (object) item.Defend),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Luck", (object) item.Luck),
          new SqlParameter("@Blood", (object) item.Blood),
          new SqlParameter("@Damage", (object) item.Damage),
          new SqlParameter("@Guard", (object) item.Guard),
          new SqlParameter("@Cost", (object) item.Cost)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateClothPropertyTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteClothPropertyTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Cloth_Property_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteClothPropertyTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllClothPropertyTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Cloth_Property_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteClothPropertyTemplate: " + ex.ToString());
            }
            return flag;
        }

        public StrengThenExpInfo[] GetAllStrengThenExp()
        {
            List<StrengThenExpInfo> strengThenExpInfoList = new List<StrengThenExpInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[StrengThenExp]");
                while (Sdr.Read())
                    strengThenExpInfoList.Add(this.InitStrengThenExpInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllStrengThenExp " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return strengThenExpInfoList.ToArray();
        }

        public StrengThenExpInfo[] GetAllStrengThenExpBy(int id)
        {
            List<StrengThenExpInfo> strengThenExpInfoList = new List<StrengThenExpInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[StrengThenExp] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    strengThenExpInfoList.Add(this.InitStrengThenExpInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllStrengThenExpBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return strengThenExpInfoList.ToArray();
        }

        public StrengThenExpInfo GetSingleStrengThenExp(int id)
        {
            List<StrengThenExpInfo> strengThenExpInfoList = new List<StrengThenExpInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[StrengThenExp] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    strengThenExpInfoList.Add(this.InitStrengThenExpInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleStrengThenExp " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return strengThenExpInfoList.Count > 0 ? strengThenExpInfoList[0] : (StrengThenExpInfo)null;
        }

        public StrengThenExpInfo InitStrengThenExpInfo(SqlDataReader reader) => new StrengThenExpInfo()
        {
            ID = (int)reader["ID"],
            Level = (int)reader["Level"],
            Exp = (int)reader["Exp"],
            NecklaceStrengthExp = (int)reader["NecklaceStrengthExp"],
            NecklaceStrengthPlus = (int)reader["NecklaceStrengthPlus"]
        };

        public bool AddStrengThenExp(StrengThenExpInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[StrengThenExp]\r\n                                   ([Level]\r\n                                   ,[Exp]\r\n                                   ,[NecklaceStrengthExp]\r\n                                   ,[NecklaceStrengthPlus])\r\n                               VALUES\r\n                                   (@Level\r\n                                   ,@Exp\r\n                                   ,@NecklaceStrengthExp\r\n                                   ,@NecklaceStrengthPlus)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          null,
          null,
          null,
          null
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Level", (object)item.Level);
                SqlParameters[2] = new SqlParameter("@Exp", (object)item.Exp);
                SqlParameters[3] = new SqlParameter("@NecklaceStrengthExp", (object)item.NecklaceStrengthExp);
                SqlParameters[4] = new SqlParameter("@NecklaceStrengthPlus", (object)item.NecklaceStrengthPlus);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddStrengThenExp: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateStrengThenExp(StrengThenExpInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[StrengThenExp]\r\n                               SET [Level] = @Level\r\n                                  ,[Exp] = @Exp\r\n                                  ,[NecklaceStrengthExp] = @NecklaceStrengthExp\r\n                                  ,[NecklaceStrengthPlus] = @NecklaceStrengthPlus\r\n                            WHERE [ID] = @ID", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@NecklaceStrengthExp", (object) item.NecklaceStrengthExp),
          new SqlParameter("@NecklaceStrengthPlus", (object) item.NecklaceStrengthPlus)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateStrengThenExp: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteStrengThenExp(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[StrengThenExp] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteStrengThenExp: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllStrengThenExp()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[StrengThenExp]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteStrengThenExp: " + ex.ToString());
            }
            return flag;
        }

        public MagicItemTemplateInfo[] GetAllMagicItemTemplate()
        {
            List<MagicItemTemplateInfo> itemTemplateInfoList = new List<MagicItemTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Magic_Item_Template]");
                while (Sdr.Read())
                    itemTemplateInfoList.Add(this.InitMagicItemTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMagicItemTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemTemplateInfoList.ToArray();
        }

        public MagicItemTemplateInfo[] GetAllMagicItemTemplateBy(int id)
        {
            List<MagicItemTemplateInfo> itemTemplateInfoList = new List<MagicItemTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Magic_Item_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    itemTemplateInfoList.Add(this.InitMagicItemTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMagicItemTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemTemplateInfoList.ToArray();
        }

        public MagicItemTemplateInfo GetSingleMagicItemTemplate(int id)
        {
            List<MagicItemTemplateInfo> itemTemplateInfoList = new List<MagicItemTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Magic_Item_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    itemTemplateInfoList.Add(this.InitMagicItemTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleMagicItemTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemTemplateInfoList.Count > 0 ? itemTemplateInfoList[0] : (MagicItemTemplateInfo)null;
        }

        public MagicItemTemplateInfo InitMagicItemTemplateInfo(SqlDataReader reader) => new MagicItemTemplateInfo()
        {
            Lv = (int)reader["Lv"],
            Exp = (int)reader["Exp"],
            MagicAttack = (int)reader["MagicAttack"],
            MagicDefence = (int)reader["MagicDefence"]
        };

        public bool AddMagicItemTemplate(MagicItemTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Magic_Item_Template]\r\n                                   ([Lv]\r\n                                   ,[Exp]\r\n                                   ,[MagicAttack]\r\n                                   ,[MagicDefence])\r\n                               VALUES\r\n                                   (@Lv\r\n                                   ,@Exp\r\n                                   ,@MagicAttack\r\n                                   ,@MagicDefence)", new SqlParameter[4]
                {
          new SqlParameter("@Lv", (object) item.Lv),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@MagicAttack", (object) item.MagicAttack),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddMagicItemTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateMagicItemTemplate(MagicItemTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Magic_Item_Template]\r\n                               SET [Lv] = @Lv\r\n                                  ,[Exp] = @Exp\r\n                                  ,[MagicAttack] = @MagicAttack\r\n                                  ,[MagicDefence] = @MagicDefence\r\n                            WHERE [ID] = @ID", new SqlParameter[4]
                {
          new SqlParameter("@Lv", (object) item.Lv),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@MagicAttack", (object) item.MagicAttack),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateMagicItemTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteMagicItemTemplate(int lv)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Magic_Item_Template] WHERE [Lv] = @Lv", new SqlParameter[1]
                {
          new SqlParameter("@Lv", (object) lv)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMagicItemTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllMagicItemTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Magic_Item_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMagicItemTemplate: " + ex.ToString());
            }
            return flag;
        }

        public MagicFusionDataInfo[] GetAllMagicFusionData()
        {
            List<MagicFusionDataInfo> magicFusionDataInfoList = new List<MagicFusionDataInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Magic_Fusion_Data]");
                while (Sdr.Read())
                    magicFusionDataInfoList.Add(this.InitMagicFusionDataInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMagicFusionData " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return magicFusionDataInfoList.ToArray();
        }

        public MagicFusionDataInfo[] GetAllMagicFusionDataBy(int id)
        {
            List<MagicFusionDataInfo> magicFusionDataInfoList = new List<MagicFusionDataInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Magic_Fusion_Data] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    magicFusionDataInfoList.Add(this.InitMagicFusionDataInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMagicFusionDataBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return magicFusionDataInfoList.ToArray();
        }

        public MagicFusionDataInfo GetSingleMagicFusionData(int id)
        {
            List<MagicFusionDataInfo> magicFusionDataInfoList = new List<MagicFusionDataInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Magic_Fusion_Data] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    magicFusionDataInfoList.Add(this.InitMagicFusionDataInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleMagicFusionData " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return magicFusionDataInfoList.Count > 0 ? magicFusionDataInfoList[0] : (MagicFusionDataInfo)null;
        }

        public MagicFusionDataInfo InitMagicFusionDataInfo(SqlDataReader reader) => new MagicFusionDataInfo()
        {
            ID = (int)reader["ID"],
            ItemID = (int)reader["ItemID"],
            Type = (int)reader["Type"],
            NeedGold = (int)reader["NeedGold"],
            NeedKey = (int)reader["NeedKey"],
            Item1 = (int)reader["Item1"],
            Item1Count = (int)reader["Item1Count"],
            Item2 = (int)reader["Item2"],
            Item2Count = (int)reader["Item2Count"],
            Item3 = (int)reader["Item3"],
            Item3Count = (int)reader["Item3Count"],
            Item4 = (int)reader["Item4"],
            Item4Count = (int)reader["Item4Count"],
            GetKeys = (int)reader["GetKeys"]
        };

        public bool AddMagicFusionData(MagicFusionDataInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Magic_Fusion_Data]\r\n                                   ([ID]\r\n                                   ,[ItemID]\r\n                                   ,[Type]\r\n                                   ,[NeedGold]\r\n                                   ,[NeedKey]\r\n                                   ,[Item1]\r\n                                   ,[Item1Count]\r\n                                   ,[Item2]\r\n                                   ,[Item2Count]\r\n                                   ,[Item3]\r\n                                   ,[Item3Count]\r\n                                   ,[Item4]\r\n                                   ,[Item4Count]\r\n                                   ,[GetKeys])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@ItemID\r\n                                   ,@Type\r\n                                   ,@NeedGold\r\n                                   ,@NeedKey\r\n                                   ,@Item1\r\n                                   ,@Item1Count\r\n                                   ,@Item2\r\n                                   ,@Item2Count\r\n                                   ,@Item3\r\n                                   ,@Item3Count\r\n                                   ,@Item4\r\n                                   ,@Item4Count\r\n                                   ,@GetKeys)", new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@ItemID", (object) item.ItemID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@NeedGold", (object) item.NeedGold),
          new SqlParameter("@NeedKey", (object) item.NeedKey),
          new SqlParameter("@Item1", (object) item.Item1),
          new SqlParameter("@Item1Count", (object) item.Item1Count),
          new SqlParameter("@Item2", (object) item.Item2),
          new SqlParameter("@Item2Count", (object) item.Item2Count),
          new SqlParameter("@Item3", (object) item.Item3),
          new SqlParameter("@Item3Count", (object) item.Item3Count),
          new SqlParameter("@Item4", (object) item.Item4),
          new SqlParameter("@Item4Count", (object) item.Item4Count),
          new SqlParameter("@GetKeys", (object) item.GetKeys)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddMagicFusionData: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateMagicFusionData(MagicFusionDataInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Magic_Fusion_Data]\r\n                               SET [ID] = @ID\r\n                                  ,[ItemID] = @ItemID\r\n                                  ,[Type] = @Type\r\n                                  ,[NeedGold] = @NeedGold\r\n                                  ,[NeedKey] = @NeedKey\r\n                                  ,[Item1] = @Item1\r\n                                  ,[Item1Count] = @Item1Count\r\n                                  ,[Item2] = @Item2\r\n                                  ,[Item2Count] = @Item2Count\r\n                                  ,[Item3] = @Item3\r\n                                  ,[Item3Count] = @Item3Count\r\n                                  ,[Item4] = @Item4\r\n                                  ,[Item4Count] = @Item4Count\r\n                                  ,[GetKeys] = @GetKeys\r\n                            WHERE [ID] = @ID", new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@ItemID", (object) item.ItemID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@NeedGold", (object) item.NeedGold),
          new SqlParameter("@NeedKey", (object) item.NeedKey),
          new SqlParameter("@Item1", (object) item.Item1),
          new SqlParameter("@Item1Count", (object) item.Item1Count),
          new SqlParameter("@Item2", (object) item.Item2),
          new SqlParameter("@Item2Count", (object) item.Item2Count),
          new SqlParameter("@Item3", (object) item.Item3),
          new SqlParameter("@Item3Count", (object) item.Item3Count),
          new SqlParameter("@Item4", (object) item.Item4),
          new SqlParameter("@Item4Count", (object) item.Item4Count),
          new SqlParameter("@GetKeys", (object) item.GetKeys)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateMagicFusionData: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteMagicFusionData(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Magic_Fusion_Data] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMagicFusionData: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllMagicFusionData()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Magic_Fusion_Data]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMagicFusionData: " + ex.ToString());
            }
            return flag;
        }

        public LoginAwardItemTemplateInfo[] GetAllLoginAwardItemTemplate()
        {
            List<LoginAwardItemTemplateInfo> itemTemplateInfoList = new List<LoginAwardItemTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Login_Award_Item_Template]");
                while (Sdr.Read())
                    itemTemplateInfoList.Add(this.InitLoginAwardItemTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllLoginAwardItemTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemTemplateInfoList.ToArray();
        }

        public LoginAwardItemTemplateInfo[] GetAllLoginAwardItemTemplateBy(
          int id)
        {
            List<LoginAwardItemTemplateInfo> itemTemplateInfoList = new List<LoginAwardItemTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Login_Award_Item_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    itemTemplateInfoList.Add(this.InitLoginAwardItemTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllLoginAwardItemTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemTemplateInfoList.ToArray();
        }

        public LoginAwardItemTemplateInfo GetSingleLoginAwardItemTemplate(
          int id)
        {
            List<LoginAwardItemTemplateInfo> itemTemplateInfoList = new List<LoginAwardItemTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Login_Award_Item_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    itemTemplateInfoList.Add(this.InitLoginAwardItemTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleLoginAwardItemTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemTemplateInfoList.Count > 0 ? itemTemplateInfoList[0] : (LoginAwardItemTemplateInfo)null;
        }

        public LoginAwardItemTemplateInfo InitLoginAwardItemTemplateInfo(
          SqlDataReader reader)
        {
            return new LoginAwardItemTemplateInfo()
            {
                ID = (int)reader["ID"],
                Count = (int)reader["Count"],
                RewardItemID = (int)reader["RewardItemID"],
                IsSelect = (bool)reader["IsSelect"],
                IsBind = (bool)reader["IsBind"],
                RewardItemValid = (int)reader["RewardItemValid"],
                RewardItemCount = (int)reader["RewardItemCount"],
                StrengthenLevel = (int)reader["StrengthenLevel"],
                AttackCompose = (int)reader["AttackCompose"],
                DefendCompose = (int)reader["DefendCompose"],
                AgilityCompose = (int)reader["AgilityCompose"],
                LuckCompose = (int)reader["LuckCompose"]
            };
        }

        public bool AddLoginAwardItemTemplate(LoginAwardItemTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Login_Award_Item_Template]\r\n                                   ([ID]\r\n                                   ,[Count]\r\n                                   ,[RewardItemID]\r\n                                   ,[IsSelect]\r\n                                   ,[IsBind]\r\n                                   ,[RewardItemValid]\r\n                                   ,[RewardItemCount]\r\n                                   ,[StrengthenLevel]\r\n                                   ,[AttackCompose]\r\n                                   ,[DefendCompose]\r\n                                   ,[AgilityCompose]\r\n                                   ,[LuckCompose])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Count\r\n                                   ,@RewardItemID\r\n                                   ,@IsSelect\r\n                                   ,@IsBind\r\n                                   ,@RewardItemValid\r\n                                   ,@RewardItemCount\r\n                                   ,@StrengthenLevel\r\n                                   ,@AttackCompose\r\n                                   ,@DefendCompose\r\n                                   ,@AgilityCompose\r\n                                   ,@LuckCompose)", new SqlParameter[12]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@RewardItemID", (object) item.RewardItemID),
          new SqlParameter("@IsSelect", (object) item.IsSelect),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@RewardItemValid", (object) item.RewardItemValid),
          new SqlParameter("@RewardItemCount", (object) item.RewardItemCount),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddLoginAwardItemTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateLoginAwardItemTemplate(LoginAwardItemTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Login_Award_Item_Template]\r\n                               SET [ID] = @ID\r\n                                  ,[Count] = @Count\r\n                                  ,[RewardItemID] = @RewardItemID\r\n                                  ,[IsSelect] = @IsSelect\r\n                                  ,[IsBind] = @IsBind\r\n                                  ,[RewardItemValid] = @RewardItemValid\r\n                                  ,[RewardItemCount] = @RewardItemCount\r\n                                  ,[StrengthenLevel] = @StrengthenLevel\r\n                                  ,[AttackCompose] = @AttackCompose\r\n                                  ,[DefendCompose] = @DefendCompose\r\n                                  ,[AgilityCompose] = @AgilityCompose\r\n                                  ,[LuckCompose] = @LuckCompose\r\n                            WHERE [ID] = @ID", new SqlParameter[12]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@RewardItemID", (object) item.RewardItemID),
          new SqlParameter("@IsSelect", (object) item.IsSelect),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@RewardItemValid", (object) item.RewardItemValid),
          new SqlParameter("@RewardItemCount", (object) item.RewardItemCount),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateLoginAwardItemTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteLoginAwardItemTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Login_Award_Item_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteLoginAwardItemTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllLoginAwardItemTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Login_Award_Item_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteLoginAwardItemTemplate: " + ex.ToString());
            }
            return flag;
        }

        public LoadUserBoxInfo[] GetAllLoadUserBox()
        {
            List<LoadUserBoxInfo> loadUserBoxInfoList = new List<LoadUserBoxInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[LoadUserBox]");
                while (Sdr.Read())
                    loadUserBoxInfoList.Add(this.InitLoadUserBoxInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllLoadUserBox " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return loadUserBoxInfoList.ToArray();
        }

        public LoadUserBoxInfo[] GetAllLoadUserBoxBy(int id)
        {
            List<LoadUserBoxInfo> loadUserBoxInfoList = new List<LoadUserBoxInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[LoadUserBox] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    loadUserBoxInfoList.Add(this.InitLoadUserBoxInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllLoadUserBoxBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return loadUserBoxInfoList.ToArray();
        }

        public LoadUserBoxInfo GetSingleLoadUserBox(int id)
        {
            List<LoadUserBoxInfo> loadUserBoxInfoList = new List<LoadUserBoxInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[LoadUserBox] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    loadUserBoxInfoList.Add(this.InitLoadUserBoxInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleLoadUserBox " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return loadUserBoxInfoList.Count > 0 ? loadUserBoxInfoList[0] : (LoadUserBoxInfo)null;
        }

        public LoadUserBoxInfo InitLoadUserBoxInfo(SqlDataReader reader) => new LoadUserBoxInfo()
        {
            ID = (int)reader["ID"],
            Type = (int)reader["Type"],
            Level = (int)reader["Level"],
            Condition = (int)reader["Condition"],
            TemplateID = (int)reader["TemplateID"]
        };

        public bool AddLoadUserBox(LoadUserBoxInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[LoadUserBox]\r\n                                   ([ID]\r\n                                   ,[Type]\r\n                                   ,[Level]\r\n                                   ,[Condition]\r\n                                   ,[TemplateID])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Type\r\n                                   ,@Level\r\n                                   ,@Condition\r\n                                   ,@TemplateID)", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Condition", (object) item.Condition),
          new SqlParameter("@TemplateID", (object) item.TemplateID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddLoadUserBox: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateLoadUserBox(LoadUserBoxInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[LoadUserBox]\r\n                               SET [ID] = @ID\r\n                                  ,[Type] = @Type\r\n                                  ,[Level] = @Level\r\n                                  ,[Condition] = @Condition\r\n                                  ,[TemplateID] = @TemplateID\r\n                            WHERE [ID] = @ID", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Condition", (object) item.Condition),
          new SqlParameter("@TemplateID", (object) item.TemplateID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateLoadUserBox: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteLoadUserBox(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[LoadUserBox] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteLoadUserBox: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllLoadUserBox()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[LoadUserBox]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteLoadUserBox: " + ex.ToString());
            }
            return flag;
        }

        public LevelInfo[] GetAllLevel()
        {
            List<LevelInfo> levelInfoList = new List<LevelInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[LevelInfo]");
                while (Sdr.Read())
                    levelInfoList.Add(this.InitLevelInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllLevel " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return levelInfoList.ToArray();
        }

        public LevelInfo[] GetAllLevelBy(int id)
        {
            List<LevelInfo> levelInfoList = new List<LevelInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[LevelInfo] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    levelInfoList.Add(this.InitLevelInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllLevelBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return levelInfoList.ToArray();
        }

        public LevelInfo GetSingleLevel(int id)
        {
            List<LevelInfo> levelInfoList = new List<LevelInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[LevelInfo] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    levelInfoList.Add(this.InitLevelInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleLevel " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return levelInfoList.Count > 0 ? levelInfoList[0] : (LevelInfo)null;
        }

        public LevelInfo InitLevelInfo(SqlDataReader reader) => new LevelInfo()
        {
            Grade = (int)reader["Grade"],
            GP = (int)reader["GP"],
            Blood = (int)reader["Blood"]
        };

        public bool AddLevel(LevelInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[LevelInfo]\r\n                                   ([Grade]\r\n                                   ,[GP]\r\n                                   ,[Blood])\r\n                               VALUES\r\n                                   (@Grade\r\n                                   ,@GP\r\n                                   ,@Blood)", new SqlParameter[3]
                {
          new SqlParameter("@Grade", (object) item.Grade),
          new SqlParameter("@GP", (object) item.GP),
          new SqlParameter("@Blood", (object) item.Blood)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddLevel: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateLevel(LevelInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[LevelInfo]\r\n                               SET [Grade] = @Grade\r\n                                  ,[GP] = @GP\r\n                                  ,[Blood] = @Blood\r\n                            WHERE [ID] = @ID", new SqlParameter[3]
                {
          new SqlParameter("@Grade", (object) item.Grade),
          new SqlParameter("@GP", (object) item.GP),
          new SqlParameter("@Blood", (object) item.Blood)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateLevel: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteLevel(int grade)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[LevelInfo] WHERE [Grade] = @Grade", new SqlParameter[1]
                {
          new SqlParameter("@Grade", (object) grade)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteLevel: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllLevel()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[LevelInfo]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteLevel: " + ex.ToString());
            }
            return flag;
        }

        public GoodsCollectInfo[] GetAllGoodsCollect()
        {
            List<GoodsCollectInfo> goodsCollectInfoList = new List<GoodsCollectInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Goods_Collect]");
                while (Sdr.Read())
                    goodsCollectInfoList.Add(this.InitGoodsCollectInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllGoodsCollect " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return goodsCollectInfoList.ToArray();
        }

        public GoodsCollectInfo[] GetAllGoodsCollectBy(int id)
        {
            List<GoodsCollectInfo> goodsCollectInfoList = new List<GoodsCollectInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Goods_Collect] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    goodsCollectInfoList.Add(this.InitGoodsCollectInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllGoodsCollectBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return goodsCollectInfoList.ToArray();
        }

        public GoodsCollectInfo GetSingleGoodsCollect(int id)
        {
            List<GoodsCollectInfo> goodsCollectInfoList = new List<GoodsCollectInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Goods_Collect] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    goodsCollectInfoList.Add(this.InitGoodsCollectInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleGoodsCollect " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return goodsCollectInfoList.Count > 0 ? goodsCollectInfoList[0] : (GoodsCollectInfo)null;
        }

        public GoodsCollectInfo InitGoodsCollectInfo(SqlDataReader reader) => new GoodsCollectInfo()
        {
            ID = (int)reader["ID"],
            Type = (int)reader["Type"],
            TemplateID = (int)reader["TemplateID"],
            Count = (int)reader["Count"],
            ValidDate = (int)reader["ValidDate"],
            IsBind = (bool)reader["IsBind"],
            GetFrom = reader["GetFrom"] == null ? "" : reader["GetFrom"].ToString(),
            SondNode = reader["SondNode"] == null ? "" : reader["SondNode"].ToString()
        };

        public bool AddGoodsCollect(GoodsCollectInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Goods_Collect]\r\n                                   ([ID]\r\n                                   ,[Type]\r\n                                   ,[TemplateID]\r\n                                   ,[Count]\r\n                                   ,[ValidDate]\r\n                                   ,[IsBind]\r\n                                   ,[GetFrom]\r\n                                   ,[SondNode])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Type\r\n                                   ,@TemplateID\r\n                                   ,@Count\r\n                                   ,@ValidDate\r\n                                   ,@IsBind\r\n                                   ,@GetFrom\r\n                                   ,@SondNode)", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@GetFrom", (object) item.GetFrom),
          new SqlParameter("@SondNode", (object) item.SondNode)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddGoodsCollect: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateGoodsCollect(GoodsCollectInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Goods_Collect]\r\n                               SET [ID] = @ID\r\n                                  ,[Type] = @Type\r\n                                  ,[TemplateID] = @TemplateID\r\n                                  ,[Count] = @Count\r\n                                  ,[ValidDate] = @ValidDate\r\n                                  ,[IsBind] = @IsBind\r\n                                  ,[GetFrom] = @GetFrom\r\n                                  ,[SondNode] = @SondNode\r\n                            WHERE [ID] = @ID", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@GetFrom", (object) item.GetFrom),
          new SqlParameter("@SondNode", (object) item.SondNode)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateGoodsCollect: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteGoodsCollect(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Goods_Collect] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteGoodsCollect: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllGoodsCollect()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Goods_Collect]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteGoodsCollect: " + ex.ToString());
            }
            return flag;
        }

        public EveryDayActiveRewardTemplateInfo[] GetAllEveryDayActiveRewardTemplate()
        {
            List<EveryDayActiveRewardTemplateInfo> rewardTemplateInfoList = new List<EveryDayActiveRewardTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Every_Day_Active_Reward_Template]");
                while (Sdr.Read())
                    rewardTemplateInfoList.Add(this.InitEveryDayActiveRewardTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllEveryDayActiveRewardTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return rewardTemplateInfoList.ToArray();
        }

        public EveryDayActiveRewardTemplateInfo[] GetAllEveryDayActiveRewardTemplateBy(
          int id)
        {
            List<EveryDayActiveRewardTemplateInfo> rewardTemplateInfoList = new List<EveryDayActiveRewardTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Every_Day_Active_Reward_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    rewardTemplateInfoList.Add(this.InitEveryDayActiveRewardTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllEveryDayActiveRewardTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return rewardTemplateInfoList.ToArray();
        }

        public EveryDayActiveRewardTemplateInfo GetSingleEveryDayActiveRewardTemplate(
          int id)
        {
            List<EveryDayActiveRewardTemplateInfo> rewardTemplateInfoList = new List<EveryDayActiveRewardTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Every_Day_Active_Reward_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    rewardTemplateInfoList.Add(this.InitEveryDayActiveRewardTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleEveryDayActiveRewardTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return rewardTemplateInfoList.Count > 0 ? rewardTemplateInfoList[0] : (EveryDayActiveRewardTemplateInfo)null;
        }

        public EveryDayActiveRewardTemplateInfo InitEveryDayActiveRewardTemplateInfo(
          SqlDataReader reader)
        {
            return new EveryDayActiveRewardTemplateInfo()
            {
                ID = (int)reader["ID"],
                RewardID = (int)reader["RewardID"],
                RewardItemID = (int)reader["RewardItemID"],
                IsSelect = (bool)reader["IsSelect"],
                RewardItemValid = (int)reader["RewardItemValid"],
                RewardItemCount = (int)reader["RewardItemCount"],
                StrengthenLevel = (int)reader["StrengthenLevel"],
                AttackCompose = (int)reader["AttackCompose"],
                DefendCompose = (int)reader["DefendCompose"],
                AgilityCompose = (int)reader["AgilityCompose"],
                LuckCompose = (int)reader["LuckCompose"],
                IsBind = (bool)reader["IsBind"]
            };
        }

        public bool AddEveryDayActiveRewardTemplate(EveryDayActiveRewardTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Every_Day_Active_Reward_Template]\r\n                                   ([ID]\r\n                                   ,[RewardID]\r\n                                   ,[RewardItemID]\r\n                                   ,[IsSelect]\r\n                                   ,[RewardItemValid]\r\n                                   ,[RewardItemCount]\r\n                                   ,[StrengthenLevel]\r\n                                   ,[AttackCompose]\r\n                                   ,[DefendCompose]\r\n                                   ,[AgilityCompose]\r\n                                   ,[LuckCompose]\r\n                                   ,[IsBind])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@RewardID\r\n                                   ,@RewardItemID\r\n                                   ,@IsSelect\r\n                                   ,@RewardItemValid\r\n                                   ,@RewardItemCount\r\n                                   ,@StrengthenLevel\r\n                                   ,@AttackCompose\r\n                                   ,@DefendCompose\r\n                                   ,@AgilityCompose\r\n                                   ,@LuckCompose\r\n                                   ,@IsBind)", new SqlParameter[12]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@RewardID", (object) item.RewardID),
          new SqlParameter("@RewardItemID", (object) item.RewardItemID),
          new SqlParameter("@IsSelect", (object) item.IsSelect),
          new SqlParameter("@RewardItemValid", (object) item.RewardItemValid),
          new SqlParameter("@RewardItemCount", (object) item.RewardItemCount),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@IsBind", (object) item.IsBind)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddEveryDayActiveRewardTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateEveryDayActiveRewardTemplate(EveryDayActiveRewardTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Every_Day_Active_Reward_Template]\r\n                               SET [ID] = @ID\r\n                                  ,[RewardID] = @RewardID\r\n                                  ,[RewardItemID] = @RewardItemID\r\n                                  ,[IsSelect] = @IsSelect\r\n                                  ,[RewardItemValid] = @RewardItemValid\r\n                                  ,[RewardItemCount] = @RewardItemCount\r\n                                  ,[StrengthenLevel] = @StrengthenLevel\r\n                                  ,[AttackCompose] = @AttackCompose\r\n                                  ,[DefendCompose] = @DefendCompose\r\n                                  ,[AgilityCompose] = @AgilityCompose\r\n                                  ,[LuckCompose] = @LuckCompose\r\n                                  ,[IsBind] = @IsBind\r\n                            WHERE [ID] = @ID", new SqlParameter[12]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@RewardID", (object) item.RewardID),
          new SqlParameter("@RewardItemID", (object) item.RewardItemID),
          new SqlParameter("@IsSelect", (object) item.IsSelect),
          new SqlParameter("@RewardItemValid", (object) item.RewardItemValid),
          new SqlParameter("@RewardItemCount", (object) item.RewardItemCount),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@IsBind", (object) item.IsBind)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateEveryDayActiveRewardTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteEveryDayActiveRewardTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Every_Day_Active_Reward_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteEveryDayActiveRewardTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllEveryDayActiveRewardTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Every_Day_Active_Reward_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteEveryDayActiveRewardTemplate: " + ex.ToString());
            }
            return flag;
        }

        public EveryDayActiveProgressInfo[] GetAllEveryDayActiveProgress()
        {
            List<EveryDayActiveProgressInfo> activeProgressInfoList = new List<EveryDayActiveProgressInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Every_Day_Active_Progress]");
                while (Sdr.Read())
                    activeProgressInfoList.Add(this.InitEveryDayActiveProgressInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllEveryDayActiveProgress " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeProgressInfoList.ToArray();
        }

        public EveryDayActiveProgressInfo[] GetAllEveryDayActiveProgressBy(
          int id)
        {
            List<EveryDayActiveProgressInfo> activeProgressInfoList = new List<EveryDayActiveProgressInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Every_Day_Active_Progress] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    activeProgressInfoList.Add(this.InitEveryDayActiveProgressInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllEveryDayActiveProgressBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeProgressInfoList.ToArray();
        }

        public EveryDayActiveProgressInfo GetSingleEveryDayActiveProgress(
          int id)
        {
            List<EveryDayActiveProgressInfo> activeProgressInfoList = new List<EveryDayActiveProgressInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Every_Day_Active_Progress] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    activeProgressInfoList.Add(this.InitEveryDayActiveProgressInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleEveryDayActiveProgress " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeProgressInfoList.Count > 0 ? activeProgressInfoList[0] : (EveryDayActiveProgressInfo)null;
        }

        public EveryDayActiveProgressInfo InitEveryDayActiveProgressInfo(
          SqlDataReader reader)
        {
            return new EveryDayActiveProgressInfo()
            {
                ID = (int)reader["ID"],
                ActiveName = reader["ActiveName"] == null ? "" : reader["ActiveName"].ToString(),
                ActiveTime = reader["ActiveTime"] == null ? "" : reader["ActiveTime"].ToString(),
                Count = reader["Count"] == null ? "" : reader["Count"].ToString(),
                Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
                JumpType = (int)reader["JumpType"],
                LevelLimit = (int)reader["LevelLimit"],
                DayOfWeek = reader["DayOfWeek"] == null ? "" : reader["DayOfWeek"].ToString()
            };
        }

        public bool AddEveryDayActiveProgress(EveryDayActiveProgressInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Every_Day_Active_Progress]\r\n                                   ([ID]\r\n                                   ,[ActiveName]\r\n                                   ,[ActiveTime]\r\n                                   ,[Count]\r\n                                   ,[Description]\r\n                                   ,[JumpType]\r\n                                   ,[LevelLimit]\r\n                                   ,[DayOfWeek])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@ActiveName\r\n                                   ,@ActiveTime\r\n                                   ,@Count\r\n                                   ,@Description\r\n                                   ,@JumpType\r\n                                   ,@LevelLimit\r\n                                   ,@DayOfWeek)", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@ActiveName", (object) item.ActiveName),
          new SqlParameter("@ActiveTime", (object) item.ActiveTime),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@JumpType", (object) item.JumpType),
          new SqlParameter("@LevelLimit", (object) item.LevelLimit),
          new SqlParameter("@DayOfWeek", (object) item.DayOfWeek)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddEveryDayActiveProgress: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateEveryDayActiveProgress(EveryDayActiveProgressInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Every_Day_Active_Progress]\r\n                               SET [ID] = @ID\r\n                                  ,[ActiveName] = @ActiveName\r\n                                  ,[ActiveTime] = @ActiveTime\r\n                                  ,[Count] = @Count\r\n                                  ,[Description] = @Description\r\n                                  ,[JumpType] = @JumpType\r\n                                  ,[LevelLimit] = @LevelLimit\r\n                                  ,[DayOfWeek] = @DayOfWeek\r\n                            WHERE [ID] = @ID", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@ActiveName", (object) item.ActiveName),
          new SqlParameter("@ActiveTime", (object) item.ActiveTime),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@JumpType", (object) item.JumpType),
          new SqlParameter("@LevelLimit", (object) item.LevelLimit),
          new SqlParameter("@DayOfWeek", (object) item.DayOfWeek)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateEveryDayActiveProgress: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteEveryDayActiveProgress(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Every_Day_Active_Progress] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteEveryDayActiveProgress: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllEveryDayActiveProgress()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Every_Day_Active_Progress]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteEveryDayActiveProgress: " + ex.ToString());
            }
            return flag;
        }

        public EveryDayActivePointTemplateInfo[] GetAllEveryDayActivePointTemplate()
        {
            List<EveryDayActivePointTemplateInfo> pointTemplateInfoList = new List<EveryDayActivePointTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Every_Day_Active_Point_Template]");
                while (Sdr.Read())
                    pointTemplateInfoList.Add(this.InitEveryDayActivePointTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllEveryDayActivePointTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return pointTemplateInfoList.ToArray();
        }

        public EveryDayActivePointTemplateInfo[] GetAllEveryDayActivePointTemplateBy(
          int id)
        {
            List<EveryDayActivePointTemplateInfo> pointTemplateInfoList = new List<EveryDayActivePointTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Every_Day_Active_Point_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    pointTemplateInfoList.Add(this.InitEveryDayActivePointTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllEveryDayActivePointTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return pointTemplateInfoList.ToArray();
        }

        public EveryDayActivePointTemplateInfo GetSingleEveryDayActivePointTemplate(
          int id)
        {
            List<EveryDayActivePointTemplateInfo> pointTemplateInfoList = new List<EveryDayActivePointTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Every_Day_Active_Point_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    pointTemplateInfoList.Add(this.InitEveryDayActivePointTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleEveryDayActivePointTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return pointTemplateInfoList.Count > 0 ? pointTemplateInfoList[0] : (EveryDayActivePointTemplateInfo)null;
        }

        public EveryDayActivePointTemplateInfo InitEveryDayActivePointTemplateInfo(
          SqlDataReader reader)
        {
            return new EveryDayActivePointTemplateInfo()
            {
                ID = (int)reader["ID"],
                MinLevel = (int)reader["MinLevel"],
                MaxLevel = (int)reader["MaxLevel"],
                ActivityType = (int)reader["ActivityType"],
                JumpType = (int)reader["JumpType"],
                Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
                Count = (int)reader["Count"],
                ActivePoint = (int)reader["ActivePoint"],
                MoneyPoint = (int)reader["MoneyPoint"]
            };
        }

        public bool AddEveryDayActivePointTemplate(EveryDayActivePointTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Every_Day_Active_Point_Template]\r\n                                   ([ID]\r\n                                   ,[MinLevel]\r\n                                   ,[MaxLevel]\r\n                                   ,[ActivityType]\r\n                                   ,[JumpType]\r\n                                   ,[Description]\r\n                                   ,[Count]\r\n                                   ,[ActivePoint]\r\n                                   ,[MoneyPoint])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@MinLevel\r\n                                   ,@MaxLevel\r\n                                   ,@ActivityType\r\n                                   ,@JumpType\r\n                                   ,@Description\r\n                                   ,@Count\r\n                                   ,@ActivePoint\r\n                                   ,@MoneyPoint)", new SqlParameter[9]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@MinLevel", (object) item.MinLevel),
          new SqlParameter("@MaxLevel", (object) item.MaxLevel),
          new SqlParameter("@ActivityType", (object) item.ActivityType),
          new SqlParameter("@JumpType", (object) item.JumpType),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@ActivePoint", (object) item.ActivePoint),
          new SqlParameter("@MoneyPoint", (object) item.MoneyPoint)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddEveryDayActivePointTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateEveryDayActivePointTemplate(EveryDayActivePointTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Every_Day_Active_Point_Template]\r\n                               SET [ID] = @ID\r\n                                  ,[MinLevel] = @MinLevel\r\n                                  ,[MaxLevel] = @MaxLevel\r\n                                  ,[ActivityType] = @ActivityType\r\n                                  ,[JumpType] = @JumpType\r\n                                  ,[Description] = @Description\r\n                                  ,[Count] = @Count\r\n                                  ,[ActivePoint] = @ActivePoint\r\n                                  ,[MoneyPoint] = @MoneyPoint\r\n                            WHERE [ID] = @ID", new SqlParameter[9]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@MinLevel", (object) item.MinLevel),
          new SqlParameter("@MaxLevel", (object) item.MaxLevel),
          new SqlParameter("@ActivityType", (object) item.ActivityType),
          new SqlParameter("@JumpType", (object) item.JumpType),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@ActivePoint", (object) item.ActivePoint),
          new SqlParameter("@MoneyPoint", (object) item.MoneyPoint)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateEveryDayActivePointTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteEveryDayActivePointTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Every_Day_Active_Point_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteEveryDayActivePointTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllEveryDayActivePointTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Every_Day_Active_Point_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteEveryDayActivePointTemplate: " + ex.ToString());
            }
            return flag;
        }

        public DiceGameAwardInfo[] GetAllDiceGameAward()
        {
            List<DiceGameAwardInfo> diceGameAwardInfoList = new List<DiceGameAwardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Dice_Game_Award]");
                while (Sdr.Read())
                    diceGameAwardInfoList.Add(this.InitDiceGameAwardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllDiceGameAward " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return diceGameAwardInfoList.ToArray();
        }

        public DiceGameAwardInfo[] GetAllDiceGameAwardBy(int id)
        {
            List<DiceGameAwardInfo> diceGameAwardInfoList = new List<DiceGameAwardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Dice_Game_Award] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    diceGameAwardInfoList.Add(this.InitDiceGameAwardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllDiceGameAwardBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return diceGameAwardInfoList.ToArray();
        }

        public DiceGameAwardInfo GetSingleDiceGameAward(int id)
        {
            List<DiceGameAwardInfo> diceGameAwardInfoList = new List<DiceGameAwardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Dice_Game_Award] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    diceGameAwardInfoList.Add(this.InitDiceGameAwardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleDiceGameAward " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return diceGameAwardInfoList.Count > 0 ? diceGameAwardInfoList[0] : (DiceGameAwardInfo)null;
        }

        public DiceGameAwardInfo InitDiceGameAwardInfo(SqlDataReader reader) => new DiceGameAwardInfo()
        {
            Rank = (int)reader["Rank"],
            template = (int)reader["template"],
            count = (int)reader["count"]
        };

        public bool AddDiceGameAward(DiceGameAwardInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Dice_Game_Award]\r\n                                   ([Rank]\r\n                                   ,[template]\r\n                                   ,[count])\r\n                               VALUES\r\n                                   (@Rank\r\n                                   ,@template\r\n                                   ,@count)", new SqlParameter[3]
                {
          new SqlParameter("@Rank", (object) item.Rank),
          new SqlParameter("@template", (object) item.template),
          new SqlParameter("@count", (object) item.count)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddDiceGameAward: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateDiceGameAward(DiceGameAwardInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Dice_Game_Award]\r\n                               SET [Rank] = @Rank\r\n                                  ,[template] = @template\r\n                                  ,[count] = @count\r\n                            WHERE [ID] = @ID", new SqlParameter[3]
                {
          new SqlParameter("@Rank", (object) item.Rank),
          new SqlParameter("@template", (object) item.template),
          new SqlParameter("@count", (object) item.count)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateDiceGameAward: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteDiceGameAward(int rank)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Dice_Game_Award] WHERE [rank] = @rank", new SqlParameter[1]
                {
          new SqlParameter("@rank", (object) rank)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteDiceGameAward: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllDiceGameAward()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Dice_Game_Award]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteDiceGameAward: " + ex.ToString());
            }
            return flag;
        }

        public BallConfigInfo[] GetAllBallConfig()
        {
            List<BallConfigInfo> ballConfigInfoList = new List<BallConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[BallConfig]");
                while (Sdr.Read())
                    ballConfigInfoList.Add(this.InitBallConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllBallConfig " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return ballConfigInfoList.ToArray();
        }

        public BallConfigInfo[] GetAllBallConfigBy(int id)
        {
            List<BallConfigInfo> ballConfigInfoList = new List<BallConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[BallConfig] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    ballConfigInfoList.Add(this.InitBallConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllBallConfigBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return ballConfigInfoList.ToArray();
        }

        public BallConfigInfo GetSingleBallConfig(int id)
        {
            List<BallConfigInfo> ballConfigInfoList = new List<BallConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[BallConfig] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    ballConfigInfoList.Add(this.InitBallConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleBallConfig " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return ballConfigInfoList.Count > 0 ? ballConfigInfoList[0] : (BallConfigInfo)null;
        }

        public BallConfigInfo InitBallConfigInfo(SqlDataReader reader) => new BallConfigInfo()
        {
            TemplateID = (int)reader["TemplateID"],
            Common = (int)reader["Common"],
            CommonAddWound = (int)reader["CommonAddWound"],
            CommonMultiBall = (int)reader["CommonMultiBall"],
            Special = (int)reader["Special"]
        };

        public bool AddBallConfig(BallConfigInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[BallConfig]\r\n                                   ([TemplateID]\r\n                                   ,[Common]\r\n                                   ,[CommonAddWound]\r\n                                   ,[CommonMultiBall]\r\n                                   ,[Special])\r\n                               VALUES\r\n                                   (@TemplateID\r\n                                   ,@Common\r\n                                   ,@CommonAddWound\r\n                                   ,@CommonMultiBall\r\n                                   ,@Special)", new SqlParameter[5]
                {
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Common", (object) item.Common),
          new SqlParameter("@CommonAddWound", (object) item.CommonAddWound),
          new SqlParameter("@CommonMultiBall", (object) item.CommonMultiBall),
          new SqlParameter("@Special", (object) item.Special)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddBallConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateBallConfig(BallConfigInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[BallConfig]\r\n                               SET [TemplateID] = @TemplateID\r\n                                  ,[Common] = @Common\r\n                                  ,[CommonAddWound] = @CommonAddWound\r\n                                  ,[CommonMultiBall] = @CommonMultiBall\r\n                                  ,[Special] = @Special\r\n                            WHERE [TemplateID] = @TemplateID", new SqlParameter[5]
                {
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Common", (object) item.Common),
          new SqlParameter("@CommonAddWound", (object) item.CommonAddWound),
          new SqlParameter("@CommonMultiBall", (object) item.CommonMultiBall),
          new SqlParameter("@Special", (object) item.Special)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateBallConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteBallConfig(int templateID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[BallConfig] WHERE [TemplateID] = @TemplateID", new SqlParameter[1]
                {
          new SqlParameter("@TemplateID", (object) templateID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteBallConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllBallConfig()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[BallConfig]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteBallConfig: " + ex.ToString());
            }
            return flag;
        }

        public TotemHonorTemplateInfo[] GetAllTotemHonorTemplate()
        {
            List<TotemHonorTemplateInfo> honorTemplateInfoList = new List<TotemHonorTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Totem_Honor_Template]");
                while (Sdr.Read())
                    honorTemplateInfoList.Add(this.InitTotemHonorTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllTotemHonorTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return honorTemplateInfoList.ToArray();
        }

        public TotemHonorTemplateInfo[] GetAllTotemHonorTemplateBy(int id)
        {
            List<TotemHonorTemplateInfo> honorTemplateInfoList = new List<TotemHonorTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Totem_Honor_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    honorTemplateInfoList.Add(this.InitTotemHonorTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllTotemHonorTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return honorTemplateInfoList.ToArray();
        }

        public TotemHonorTemplateInfo GetSingleTotemHonorTemplate(int id)
        {
            List<TotemHonorTemplateInfo> honorTemplateInfoList = new List<TotemHonorTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Totem_Honor_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    honorTemplateInfoList.Add(this.InitTotemHonorTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleTotemHonorTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return honorTemplateInfoList.Count > 0 ? honorTemplateInfoList[0] : (TotemHonorTemplateInfo)null;
        }

        public TotemHonorTemplateInfo InitTotemHonorTemplateInfo(
          SqlDataReader reader)
        {
            return new TotemHonorTemplateInfo()
            {
                ID = (int)reader["ID"],
                Type = (int)reader["Type"],
                NeedMoney = (int)reader["NeedMoney"],
                AddHonor = (int)reader["AddHonor"]
            };
        }

        public bool AddTotemHonorTemplate(TotemHonorTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Totem_Honor_Template]\r\n                                   ([ID]\r\n                                   ,[Type]\r\n                                   ,[NeedMoney]\r\n                                   ,[AddHonor])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Type\r\n                                   ,@NeedMoney\r\n                                   ,@AddHonor)", new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@NeedMoney", (object) item.NeedMoney),
          new SqlParameter("@AddHonor", (object) item.AddHonor)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddTotemHonorTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateTotemHonorTemplate(TotemHonorTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Totem_Honor_Template]\r\n                               SET [ID] = @ID\r\n                                  ,[Type] = @Type\r\n                                  ,[NeedMoney] = @NeedMoney\r\n                                  ,[AddHonor] = @AddHonor\r\n                            WHERE [ID] = @ID", new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@NeedMoney", (object) item.NeedMoney),
          new SqlParameter("@AddHonor", (object) item.AddHonor)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateTotemHonorTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteTotemHonorTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Totem_Honor_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteTotemHonorTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllTotemHonorTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Totem_Honor_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteTotemHonorTemplate: " + ex.ToString());
            }
            return flag;
        }

        public ButtonConfigInfo[] GetAllButtonConfig()
        {
            List<ButtonConfigInfo> buttonConfigInfoList = new List<ButtonConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Button_Config]");
                while (Sdr.Read())
                    buttonConfigInfoList.Add(this.InitButtonConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllButtonConfig " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return buttonConfigInfoList.ToArray();
        }

        public ButtonConfigInfo[] GetAllButtonConfigBy(int id)
        {
            List<ButtonConfigInfo> buttonConfigInfoList = new List<ButtonConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Button_Config] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    buttonConfigInfoList.Add(this.InitButtonConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllButtonConfigBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return buttonConfigInfoList.ToArray();
        }

        public ButtonConfigInfo GetSingleButtonConfig(int id)
        {
            List<ButtonConfigInfo> buttonConfigInfoList = new List<ButtonConfigInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Button_Config] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    buttonConfigInfoList.Add(this.InitButtonConfigInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleButtonConfig " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return buttonConfigInfoList.Count > 0 ? buttonConfigInfoList[0] : (ButtonConfigInfo)null;
        }

        public ButtonConfigInfo InitButtonConfigInfo(SqlDataReader reader) => new ButtonConfigInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Text = reader["Text"] == null ? "" : reader["Text"].ToString(),
            IsShow = (bool)reader["IsShow"],
            IsClose = (bool)reader["IsClose"]
        };

        public bool AddButtonConfig(ButtonConfigInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Button_Config]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[Text]\r\n                                   ,[IsShow]\r\n                                   ,[IsClose])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@Text\r\n                                   ,@IsShow\r\n                                   ,@IsClose)", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Text", (object) item.Text),
          new SqlParameter("@IsShow", (object) item.IsShow),
          new SqlParameter("@IsClose", (object) item.IsClose)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddButtonConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateButtonConfig(ButtonConfigInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Button_Config]\r\n                               SET [ID] = @ID\r\n                                  ,[Name] = @Name\r\n                                  ,[Text] = @Text\r\n                                  ,[IsShow] = @IsShow\r\n                                  ,[IsClose] = @IsClose\r\n                            WHERE [ID] = @ID", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Text", (object) item.Text),
          new SqlParameter("@IsShow", (object) item.IsShow),
          new SqlParameter("@IsClose", (object) item.IsClose)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateButtonConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteButtonConfig(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Button_Config] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteButtonConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllButtonConfig()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Button_Config]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteButtonConfig: " + ex.ToString());
            }
            return flag;
        }

        public CardGrooveUpdateInfo[] GetAllCardGrooveUpdate()
        {
            List<CardGrooveUpdateInfo> grooveUpdateInfoList = new List<CardGrooveUpdateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Card_Groove_Update]");
                while (Sdr.Read())
                    grooveUpdateInfoList.Add(this.InitCardGrooveUpdateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllCardGrooveUpdate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return grooveUpdateInfoList.ToArray();
        }

        public CardGrooveUpdateInfo[] GetAllCardGrooveUpdateBy(int id)
        {
            List<CardGrooveUpdateInfo> grooveUpdateInfoList = new List<CardGrooveUpdateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Card_Groove_Update] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    grooveUpdateInfoList.Add(this.InitCardGrooveUpdateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllCardGrooveUpdateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return grooveUpdateInfoList.ToArray();
        }

        public CardGrooveUpdateInfo GetSingleCardGrooveUpdate(int id)
        {
            List<CardGrooveUpdateInfo> grooveUpdateInfoList = new List<CardGrooveUpdateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Card_Groove_Update] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    grooveUpdateInfoList.Add(this.InitCardGrooveUpdateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleCardGrooveUpdate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return grooveUpdateInfoList.Count > 0 ? grooveUpdateInfoList[0] : (CardGrooveUpdateInfo)null;
        }

        public CardGrooveUpdateInfo InitCardGrooveUpdateInfo(SqlDataReader reader) => new CardGrooveUpdateInfo()
        {
            ID = (int)reader["ID"],
            Level = (int)reader["Level"],
            Type = (int)reader["Type"],
            Exp = (int)reader["Exp"],
            Attack = (int)reader["Attack"],
            Defend = (int)reader["Defend"],
            Agility = (int)reader["Agility"],
            Lucky = (int)reader["Lucky"],
            Damage = (int)reader["Damage"],
            Guard = (int)reader["Guard"]
        };

        public bool AddCardGrooveUpdate(CardGrooveUpdateInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Card_Groove_Update]\r\n                                   ([Level]\r\n                                   ,[Type]\r\n                                   ,[Exp]\r\n                                   ,[Attack]\r\n                                   ,[Defend]\r\n                                   ,[Agility]\r\n                                   ,[Lucky]\r\n                                   ,[Damage]\r\n                                   ,[Guard])\r\n                               VALUES\r\n                                   (@Level\r\n                                   ,@Type\r\n                                   ,@Exp\r\n                                   ,@Attack\r\n                                   ,@Defend\r\n                                   ,@Agility\r\n                                   ,@Lucky\r\n                                   ,@Damage\r\n                                   ,@Guard)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[10];
                SqlParameters[0] = new SqlParameter("@ID", (object)item.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Level", (object)item.Level);
                SqlParameters[2] = new SqlParameter("@Type", (object)item.Type);
                SqlParameters[3] = new SqlParameter("@Exp", (object)item.Exp);
                SqlParameters[4] = new SqlParameter("@Attack", (object)item.Attack);
                SqlParameters[5] = new SqlParameter("@Defend", (object)item.Defend);
                SqlParameters[6] = new SqlParameter("@Agility", (object)item.Agility);
                SqlParameters[7] = new SqlParameter("@Lucky", (object)item.Lucky);
                SqlParameters[8] = new SqlParameter("@Damage", (object)item.Damage);
                SqlParameters[9] = new SqlParameter("@Guard", (object)item.Guard);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddCardGrooveUpdate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateCardGrooveUpdate(CardGrooveUpdateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Card_Groove_Update]\r\n                               SET [Level] = @Level\r\n                                  ,[Type] = @Type\r\n                                  ,[Exp] = @Exp\r\n                                  ,[Attack] = @Attack\r\n                                  ,[Defend] = @Defend\r\n                                  ,[Agility] = @Agility\r\n                                  ,[Lucky] = @Lucky\r\n                                  ,[Damage] = @Damage\r\n                                  ,[Guard] = @Guard\r\n                            WHERE [ID] = @ID", new SqlParameter[10]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defend", (object) item.Defend),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Lucky", (object) item.Lucky),
          new SqlParameter("@Damage", (object) item.Damage),
          new SqlParameter("@Guard", (object) item.Guard)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateCardGrooveUpdate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteCardGrooveUpdate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Card_Groove_Update] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteCardGrooveUpdate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllCardGrooveUpdate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Card_Groove_Update]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteCardGrooveUpdate: " + ex.ToString());
            }
            return flag;
        }

        public ChargeSpendRewardTemplateInfo[] GetAllChargeSpendRewardTemplate()
        {
            List<ChargeSpendRewardTemplateInfo> rewardTemplateInfoList = new List<ChargeSpendRewardTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Charge_Spend_Reward_Template]");
                while (Sdr.Read())
                    rewardTemplateInfoList.Add(this.InitChargeSpendRewardTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllChargeSpendRewardTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return rewardTemplateInfoList.ToArray();
        }

        public ChargeSpendRewardTemplateInfo[] GetAllChargeSpendRewardTemplateBy(
          int id)
        {
            List<ChargeSpendRewardTemplateInfo> rewardTemplateInfoList = new List<ChargeSpendRewardTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Charge_Spend_Reward_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    rewardTemplateInfoList.Add(this.InitChargeSpendRewardTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllChargeSpendRewardTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return rewardTemplateInfoList.ToArray();
        }

        public ChargeSpendRewardTemplateInfo GetSingleChargeSpendRewardTemplate(
          int id)
        {
            List<ChargeSpendRewardTemplateInfo> rewardTemplateInfoList = new List<ChargeSpendRewardTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Charge_Spend_Reward_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    rewardTemplateInfoList.Add(this.InitChargeSpendRewardTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleChargeSpendRewardTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return rewardTemplateInfoList.Count > 0 ? rewardTemplateInfoList[0] : (ChargeSpendRewardTemplateInfo)null;
        }

        public ChargeSpendRewardTemplateInfo InitChargeSpendRewardTemplateInfo(
          SqlDataReader reader)
        {
            return new ChargeSpendRewardTemplateInfo()
            {
                ID = (int)reader["ID"],
                RewardID = (int)reader["RewardID"],
                RewardItemID = (int)reader["RewardItemID"],
                IsSelect = (bool)reader["IsSelect"],
                IsBind = (bool)reader["IsBind"],
                RewardItemValid = (int)reader["RewardItemValid"],
                RewardItemCount = (int)reader["RewardItemCount"],
                StrengthenLevel = (int)reader["StrengthenLevel"],
                AttackCompose = (int)reader["AttackCompose"],
                DefendCompose = (int)reader["DefendCompose"],
                AgilityCompose = (int)reader["AgilityCompose"],
                LuckCompose = (int)reader["LuckCompose"]
            };
        }

        public bool AddChargeSpendRewardTemplate(ChargeSpendRewardTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Charge_Spend_Reward_Template]\r\n                                   ([ID]\r\n                                   ,[RewardID]\r\n                                   ,[RewardItemID]\r\n                                   ,[IsSelect]\r\n                                   ,[IsBind]\r\n                                   ,[RewardItemValid]\r\n                                   ,[RewardItemCount]\r\n                                   ,[StrengthenLevel]\r\n                                   ,[AttackCompose]\r\n                                   ,[DefendCompose]\r\n                                   ,[AgilityCompose]\r\n                                   ,[LuckCompose])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@RewardID\r\n                                   ,@RewardItemID\r\n                                   ,@IsSelect\r\n                                   ,@IsBind\r\n                                   ,@RewardItemValid\r\n                                   ,@RewardItemCount\r\n                                   ,@StrengthenLevel\r\n                                   ,@AttackCompose\r\n                                   ,@DefendCompose\r\n                                   ,@AgilityCompose\r\n                                   ,@LuckCompose)", new SqlParameter[12]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@RewardID", (object) item.RewardID),
          new SqlParameter("@RewardItemID", (object) item.RewardItemID),
          new SqlParameter("@IsSelect", (object) item.IsSelect),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@RewardItemValid", (object) item.RewardItemValid),
          new SqlParameter("@RewardItemCount", (object) item.RewardItemCount),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddChargeSpendRewardTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateChargeSpendRewardTemplate(ChargeSpendRewardTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Charge_Spend_Reward_Template]\r\n                               SET [ID] = @ID\r\n                                  ,[RewardID] = @RewardID\r\n                                  ,[RewardItemID] = @RewardItemID\r\n                                  ,[IsSelect] = @IsSelect\r\n                                  ,[IsBind] = @IsBind\r\n                                  ,[RewardItemValid] = @RewardItemValid\r\n                                  ,[RewardItemCount] = @RewardItemCount\r\n                                  ,[StrengthenLevel] = @StrengthenLevel\r\n                                  ,[AttackCompose] = @AttackCompose\r\n                                  ,[DefendCompose] = @DefendCompose\r\n                                  ,[AgilityCompose] = @AgilityCompose\r\n                                  ,[LuckCompose] = @LuckCompose\r\n                            WHERE [ID] = @ID", new SqlParameter[12]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@RewardID", (object) item.RewardID),
          new SqlParameter("@RewardItemID", (object) item.RewardItemID),
          new SqlParameter("@IsSelect", (object) item.IsSelect),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@RewardItemValid", (object) item.RewardItemValid),
          new SqlParameter("@RewardItemCount", (object) item.RewardItemCount),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateChargeSpendRewardTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteChargeSpendRewardTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Charge_Spend_Reward_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteChargeSpendRewardTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllChargeSpendRewardTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Charge_Spend_Reward_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteChargeSpendRewardTemplate: " + ex.ToString());
            }
            return flag;
        }

        public FairBattleRewardInfo[] GetAllFairBattleReward()
        {
            List<FairBattleRewardInfo> battleRewardInfoList = new List<FairBattleRewardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Fair_Battle_Reward_Temp]");
                while (Sdr.Read())
                    battleRewardInfoList.Add(this.InitFairBattleRewardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllFairBattleReward " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return battleRewardInfoList.ToArray();
        }

        public FairBattleRewardInfo[] GetAllFairBattleRewardBy(int id)
        {
            List<FairBattleRewardInfo> battleRewardInfoList = new List<FairBattleRewardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Fair_Battle_Reward_Temp] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    battleRewardInfoList.Add(this.InitFairBattleRewardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllFairBattleRewardBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return battleRewardInfoList.ToArray();
        }

        public FairBattleRewardInfo GetSingleFairBattleReward(int id)
        {
            List<FairBattleRewardInfo> battleRewardInfoList = new List<FairBattleRewardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Fair_Battle_Reward_Temp] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    battleRewardInfoList.Add(this.InitFairBattleRewardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleFairBattleReward " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return battleRewardInfoList.Count > 0 ? battleRewardInfoList[0] : (FairBattleRewardInfo)null;
        }

        public FairBattleRewardInfo InitFairBattleRewardInfo(SqlDataReader reader) => new FairBattleRewardInfo()
        {
            Prestige = (int)reader["Prestige"],
            Level = (int)reader["Level"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            PrestigeForWin = (int)reader["PrestigeForWin"],
            PrestigeForLose = (int)reader["PrestigeForLose"],
            Title = reader["Title"] == null ? "" : reader["Title"].ToString()
        };

        public bool AddFairBattleReward(FairBattleRewardInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Fair_Battle_Reward_Temp]\r\n                                   ([Prestige]\r\n                                   ,[Level]\r\n                                   ,[Name]\r\n                                   ,[PrestigeForWin]\r\n                                   ,[PrestigeForLose]\r\n                                   ,[Title])\r\n                               VALUES\r\n                                   (@Prestige\r\n                                   ,@Level\r\n                                   ,@Name\r\n                                   ,@PrestigeForWin\r\n                                   ,@PrestigeForLose\r\n                                   ,@Title)", new SqlParameter[6]
                {
          new SqlParameter("@Prestige", (object) item.Prestige),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@PrestigeForWin", (object) item.PrestigeForWin),
          new SqlParameter("@PrestigeForLose", (object) item.PrestigeForLose),
          new SqlParameter("@Title", (object) item.Title)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddFairBattleReward: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateFairBattleReward(FairBattleRewardInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Fair_Battle_Reward_Temp]\r\n                               SET [Prestige] = @Prestige\r\n                                  ,[Level] = @Level\r\n                                  ,[Name] = @Name\r\n                                  ,[PrestigeForWin] = @PrestigeForWin\r\n                                  ,[PrestigeForLose] = @PrestigeForLose\r\n                                  ,[Title] = @Title\r\n                            WHERE [ID] = @ID", new SqlParameter[6]
                {
          new SqlParameter("@Prestige", (object) item.Prestige),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@PrestigeForWin", (object) item.PrestigeForWin),
          new SqlParameter("@PrestigeForLose", (object) item.PrestigeForLose),
          new SqlParameter("@Title", (object) item.Title)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateFairBattleReward: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteFairBattleReward(int level)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Fair_Battle_Reward_Temp] WHERE [Level] = @Level", new SqlParameter[1]
                {
          new SqlParameter("@Level", (object) level)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteFairBattleReward: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllFairBattleReward()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Fair_Battle_Reward_Temp]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteFairBattleReward: " + ex.ToString());
            }
            return flag;
        }

        public LightriddleQuestInfo[] GetAllLightriddleQuest()
        {
            List<LightriddleQuestInfo> lightriddleQuestInfoList = new List<LightriddleQuestInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Lightriddle_Quest]");
                while (Sdr.Read())
                    lightriddleQuestInfoList.Add(this.InitLightriddleQuestInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllLightriddleQuest " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return lightriddleQuestInfoList.ToArray();
        }

        public LightriddleQuestInfo[] GetAllLightriddleQuestBy(int id)
        {
            List<LightriddleQuestInfo> lightriddleQuestInfoList = new List<LightriddleQuestInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Lightriddle_Quest] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    lightriddleQuestInfoList.Add(this.InitLightriddleQuestInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllLightriddleQuestBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return lightriddleQuestInfoList.ToArray();
        }

        public LightriddleQuestInfo GetSingleLightriddleQuest(int id)
        {
            List<LightriddleQuestInfo> lightriddleQuestInfoList = new List<LightriddleQuestInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Lightriddle_Quest] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    lightriddleQuestInfoList.Add(this.InitLightriddleQuestInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleLightriddleQuest " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return lightriddleQuestInfoList.Count > 0 ? lightriddleQuestInfoList[0] : (LightriddleQuestInfo)null;
        }

        public LightriddleQuestInfo InitLightriddleQuestInfo(SqlDataReader reader) => new LightriddleQuestInfo()
        {
            QuestionID = (int)reader["QuestionID"],
            QuestionContent = reader["QuestionContent"] == null ? "" : reader["QuestionContent"].ToString(),
            Option1 = reader["Option1"] == null ? "" : reader["Option1"].ToString(),
            Option2 = reader["Option2"] == null ? "" : reader["Option2"].ToString(),
            Option3 = reader["Option3"] == null ? "" : reader["Option3"].ToString(),
            Option4 = reader["Option4"] == null ? "" : reader["Option4"].ToString(),
            OptionTrue = (int)reader["OptionTrue"]
        };

        public bool AddLightriddleQuest(LightriddleQuestInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Lightriddle_Quest]\r\n                                   ([QuestionID]\r\n                                   ,[QuestionContent]\r\n                                   ,[Option1]\r\n                                   ,[Option2]\r\n                                   ,[Option3]\r\n                                   ,[Option4]\r\n                                   ,[OptionTrue])\r\n                               VALUES\r\n                                   (@QuestionID\r\n                                   ,@QuestionContent\r\n                                   ,@Option1\r\n                                   ,@Option2\r\n                                   ,@Option3\r\n                                   ,@Option4\r\n                                   ,@OptionTrue)", new SqlParameter[7]
                {
          new SqlParameter("@QuestionID", (object) item.QuestionID),
          new SqlParameter("@QuestionContent", (object) item.QuestionContent),
          new SqlParameter("@Option1", (object) item.Option1),
          new SqlParameter("@Option2", (object) item.Option2),
          new SqlParameter("@Option3", (object) item.Option3),
          new SqlParameter("@Option4", (object) item.Option4),
          new SqlParameter("@OptionTrue", (object) item.OptionTrue)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddLightriddleQuest: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateLightriddleQuest(LightriddleQuestInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Lightriddle_Quest]\r\n                               SET [QuestionID] = @QuestionID\r\n                                  ,[QuestionContent] = @QuestionContent\r\n                                  ,[Option1] = @Option1\r\n                                  ,[Option2] = @Option2\r\n                                  ,[Option3] = @Option3\r\n                                  ,[Option4] = @Option4\r\n                                  ,[OptionTrue] = @OptionTrue\r\n                            WHERE [ID] = @ID", new SqlParameter[7]
                {
          new SqlParameter("@QuestionID", (object) item.QuestionID),
          new SqlParameter("@QuestionContent", (object) item.QuestionContent),
          new SqlParameter("@Option1", (object) item.Option1),
          new SqlParameter("@Option2", (object) item.Option2),
          new SqlParameter("@Option3", (object) item.Option3),
          new SqlParameter("@Option4", (object) item.Option4),
          new SqlParameter("@OptionTrue", (object) item.OptionTrue)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateLightriddleQuest: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteLightriddleQuest(int questionID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Lightriddle_Quest] WHERE [QuestionID] = @QuestionID", new SqlParameter[1]
                {
          new SqlParameter("@QuestionID", (object) questionID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteLightriddleQuest: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllLightriddleQuest()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Lightriddle_Quest]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteLightriddleQuest: " + ex.ToString());
            }
            return flag;
        }

        public MissionEnergyInfo[] GetAllMissionEnergy()
        {
            List<MissionEnergyInfo> missionEnergyInfoList = new List<MissionEnergyInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[MissionEnergyPrice]");
                while (Sdr.Read())
                    missionEnergyInfoList.Add(this.InitMissionEnergyInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMissionEnergy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return missionEnergyInfoList.ToArray();
        }

        public MissionEnergyInfo[] GetAllMissionEnergyBy(int id)
        {
            List<MissionEnergyInfo> missionEnergyInfoList = new List<MissionEnergyInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[MissionEnergyPrice] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    missionEnergyInfoList.Add(this.InitMissionEnergyInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMissionEnergyBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return missionEnergyInfoList.ToArray();
        }

        public MissionEnergyInfo GetSingleMissionEnergy(int id)
        {
            List<MissionEnergyInfo> missionEnergyInfoList = new List<MissionEnergyInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[MissionEnergyPrice] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    missionEnergyInfoList.Add(this.InitMissionEnergyInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleMissionEnergy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return missionEnergyInfoList.Count > 0 ? missionEnergyInfoList[0] : (MissionEnergyInfo)null;
        }

        public MissionEnergyInfo InitMissionEnergyInfo(SqlDataReader reader) => new MissionEnergyInfo()
        {
            Count = (int)reader["Count"],
            Money = (int)reader["Money"],
            Energy = (int)reader["Energy"]
        };

        public bool AddMissionEnergy(MissionEnergyInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[MissionEnergyPrice]\r\n                                   ([Count]\r\n                                   ,[Money]\r\n                                   ,[Energy])\r\n                               VALUES\r\n                                   (@Count\r\n                                   ,@Money\r\n                                   ,@Energy)", new SqlParameter[3]
                {
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@Money", (object) item.Money),
          new SqlParameter("@Energy", (object) item.Energy)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddMissionEnergy: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateMissionEnergy(MissionEnergyInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[MissionEnergyPrice]\r\n                               SET [Count] = @Count\r\n                                  ,[Money] = @Money\r\n                                  ,[Energy] = @Energy\r\n                            WHERE [ID] = @ID", new SqlParameter[3]
                {
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@Money", (object) item.Money),
          new SqlParameter("@Energy", (object) item.Energy)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateMissionEnergy: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteMissionEnergy(int count)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[MissionEnergyPrice] WHERE [Count] = @Count", new SqlParameter[1]
                {
          new SqlParameter("@Count", (object) count)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMissionEnergy: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllMissionEnergy()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[MissionEnergyPrice]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMissionEnergy: " + ex.ToString());
            }
            return flag;
        }

        public AllQuestionsInfo[] GetAllAllQuestions()
        {
            List<AllQuestionsInfo> allQuestionsInfoList = new List<AllQuestionsInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[All_Questions]");
                while (Sdr.Read())
                    allQuestionsInfoList.Add(this.InitAllQuestionsInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllAllQuestions " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return allQuestionsInfoList.ToArray();
        }

        public AllQuestionsInfo[] GetAllAllQuestionsBy(int id)
        {
            List<AllQuestionsInfo> allQuestionsInfoList = new List<AllQuestionsInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[All_Questions] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    allQuestionsInfoList.Add(this.InitAllQuestionsInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllAllQuestionsBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return allQuestionsInfoList.ToArray();
        }

        public AllQuestionsInfo GetSingleAllQuestions(int id)
        {
            List<AllQuestionsInfo> allQuestionsInfoList = new List<AllQuestionsInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[All_Questions] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    allQuestionsInfoList.Add(this.InitAllQuestionsInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleAllQuestions " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return allQuestionsInfoList.Count > 0 ? allQuestionsInfoList[0] : (AllQuestionsInfo)null;
        }

        public AllQuestionsInfo InitAllQuestionsInfo(SqlDataReader reader) => new AllQuestionsInfo()
        {
            QuestionCatalogID = (int)reader["QuestionCatalogID"],
            QuestionID = (int)reader["QuestionID"],
            QuestionContent = reader["QuestionContent"] == null ? "" : reader["QuestionContent"].ToString(),
            Option1 = reader["Option1"] == null ? "" : reader["Option1"].ToString(),
            Option2 = reader["Option2"] == null ? "" : reader["Option2"].ToString(),
            Option3 = reader["Option3"] == null ? "" : reader["Option3"].ToString(),
            Option4 = reader["Option4"] == null ? "" : reader["Option4"].ToString()
        };

        public bool AddAllQuestions(AllQuestionsInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[All_Questions]\r\n                                   ([QuestionCatalogID]\r\n                                   ,[QuestionID]\r\n                                   ,[QuestionContent]\r\n                                   ,[Option1]\r\n                                   ,[Option2]\r\n                                   ,[Option3]\r\n                                   ,[Option4])\r\n                               VALUES\r\n                                   (@QuestionCatalogID\r\n                                   ,@QuestionID\r\n                                   ,@QuestionContent\r\n                                   ,@Option1\r\n                                   ,@Option2\r\n                                   ,@Option3\r\n                                   ,@Option4)", new SqlParameter[7]
                {
          new SqlParameter("@QuestionCatalogID", (object) item.QuestionCatalogID),
          new SqlParameter("@QuestionID", (object) item.QuestionID),
          new SqlParameter("@QuestionContent", (object) item.QuestionContent),
          new SqlParameter("@Option1", (object) item.Option1),
          new SqlParameter("@Option2", (object) item.Option2),
          new SqlParameter("@Option3", (object) item.Option3),
          new SqlParameter("@Option4", (object) item.Option4)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddAllQuestions: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateAllQuestions(AllQuestionsInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[All_Questions]\r\n                               SET [QuestionCatalogID] = @QuestionCatalogID\r\n                                  ,[QuestionID] = @QuestionID\r\n                                  ,[QuestionContent] = @QuestionContent\r\n                                  ,[Option1] = @Option1\r\n                                  ,[Option2] = @Option2\r\n                                  ,[Option3] = @Option3\r\n                                  ,[Option4] = @Option4\r\n                            WHERE [ID] = @ID", new SqlParameter[7]
                {
          new SqlParameter("@QuestionCatalogID", (object) item.QuestionCatalogID),
          new SqlParameter("@QuestionID", (object) item.QuestionID),
          new SqlParameter("@QuestionContent", (object) item.QuestionContent),
          new SqlParameter("@Option1", (object) item.Option1),
          new SqlParameter("@Option2", (object) item.Option2),
          new SqlParameter("@Option3", (object) item.Option3),
          new SqlParameter("@Option4", (object) item.Option4)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateAllQuestions: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllQuestions(int questionID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[All_Questions] WHERE [QuestionID] = @QuestionID", new SqlParameter[1]
                {
          new SqlParameter("@QuestionID", (object) questionID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteAllQuestions: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllAllQuestions()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[All_Questions]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteAllQuestions: " + ex.ToString());
            }
            return flag;
        }

        public ShopGoodsCategorysInfo[] GetAllShopGoodsCategorys()
        {
            List<ShopGoodsCategorysInfo> goodsCategorysInfoList = new List<ShopGoodsCategorysInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Shop_Goods_Categorys]");
                while (Sdr.Read())
                    goodsCategorysInfoList.Add(this.InitShopGoodsCategorysInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllShopGoodsCategorys " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return goodsCategorysInfoList.ToArray();
        }

        public ShopGoodsCategorysInfo[] GetAllShopGoodsCategorysBy(int id)
        {
            List<ShopGoodsCategorysInfo> goodsCategorysInfoList = new List<ShopGoodsCategorysInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Shop_Goods_Categorys] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    goodsCategorysInfoList.Add(this.InitShopGoodsCategorysInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllShopGoodsCategorysBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return goodsCategorysInfoList.ToArray();
        }

        public ShopGoodsCategorysInfo GetSingleShopGoodsCategorys(int id)
        {
            List<ShopGoodsCategorysInfo> goodsCategorysInfoList = new List<ShopGoodsCategorysInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Shop_Goods_Categorys] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    goodsCategorysInfoList.Add(this.InitShopGoodsCategorysInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleShopGoodsCategorys " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return goodsCategorysInfoList.Count > 0 ? goodsCategorysInfoList[0] : (ShopGoodsCategorysInfo)null;
        }

        public ShopGoodsCategorysInfo InitShopGoodsCategorysInfo(
          SqlDataReader reader)
        {
            return new ShopGoodsCategorysInfo()
            {
                ID = (int)reader["ID"],
                Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
                Place = (int)reader["Place"],
                Remark = reader["Remark"] == null ? "" : reader["Remark"].ToString()
            };
        }

        public bool AddShopGoodsCategorys(ShopGoodsCategorysInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Shop_Goods_Categorys]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[Place]\r\n                                   ,[Remark])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@Place\r\n                                   ,@Remark)", new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Place", (object) item.Place),
          new SqlParameter("@Remark", (object) item.Remark)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddShopGoodsCategorys: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateShopGoodsCategorys(ShopGoodsCategorysInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Shop_Goods_Categorys]\r\n                               SET [ID] = @ID\r\n                                  ,[Name] = @Name\r\n                                  ,[Place] = @Place\r\n                                  ,[Remark] = @Remark\r\n                            WHERE [ID] = @ID", new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Place", (object) item.Place),
          new SqlParameter("@Remark", (object) item.Remark)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateShopGoodsCategorys: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteShopGoodsCategorys(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Shop_Goods_Categorys] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteShopGoodsCategorys: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllShopGoodsCategorys()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Shop_Goods_Categorys]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteShopGoodsCategorys: " + ex.ToString());
            }
            return flag;
        }

        public SuitTemplateInfo[] GetAllSuitTemplate()
        {
            List<SuitTemplateInfo> suitTemplateInfoList = new List<SuitTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Suit_Template]");
                while (Sdr.Read())
                    suitTemplateInfoList.Add(this.InitSuitTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllSuitTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return suitTemplateInfoList.ToArray();
        }

        public SuitTemplateInfo[] GetAllSuitTemplateBy(int id)
        {
            List<SuitTemplateInfo> suitTemplateInfoList = new List<SuitTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Suit_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    suitTemplateInfoList.Add(this.InitSuitTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllSuitTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return suitTemplateInfoList.ToArray();
        }

        public SuitTemplateInfo GetSingleSuitTemplate(int id)
        {
            List<SuitTemplateInfo> suitTemplateInfoList = new List<SuitTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Suit_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    suitTemplateInfoList.Add(this.InitSuitTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleSuitTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return suitTemplateInfoList.Count > 0 ? suitTemplateInfoList[0] : (SuitTemplateInfo)null;
        }

        public SuitTemplateInfo InitSuitTemplateInfo(SqlDataReader reader) => new SuitTemplateInfo()
        {
            SuitId = (int)reader["SuitId"],
            SuitName = reader["SuitName"] == null ? "" : reader["SuitName"].ToString(),
            EqipCount1 = (int)reader["EqipCount1"],
            SkillDescribe1 = reader["SkillDescribe1"] == null ? "" : reader["SkillDescribe1"].ToString(),
            Skill1 = reader["Skill1"] == null ? "" : reader["Skill1"].ToString(),
            EqipCount2 = (int)reader["EqipCount2"],
            SkillDescribe2 = reader["SkillDescribe2"] == null ? "" : reader["SkillDescribe2"].ToString(),
            Skill2 = reader["Skill2"] == null ? "" : reader["Skill2"].ToString(),
            EqipCount3 = (int)reader["EqipCount3"],
            SkillDescribe3 = reader["SkillDescribe3"] == null ? "" : reader["SkillDescribe3"].ToString(),
            Skill3 = reader["Skill3"] == null ? "" : reader["Skill3"].ToString(),
            EqipCount4 = (int)reader["EqipCount4"],
            SkillDescribe4 = reader["SkillDescribe4"] == null ? "" : reader["SkillDescribe4"].ToString(),
            Skill4 = reader["Skill4"] == null ? "" : reader["Skill4"].ToString(),
            EqipCount5 = (int)reader["EqipCount5"],
            SkillDescribe5 = reader["SkillDescribe5"] == null ? "" : reader["SkillDescribe5"].ToString(),
            Skill5 = reader["Skill5"] == null ? "" : reader["Skill5"].ToString()
        };

        public bool AddSuitTemplate(SuitTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Suit_Template]\r\n                                   ([SuitId]\r\n                                   ,[SuitName]\r\n                                   ,[EqipCount1]\r\n                                   ,[SkillDescribe1]\r\n                                   ,[Skill1]\r\n                                   ,[EqipCount2]\r\n                                   ,[SkillDescribe2]\r\n                                   ,[Skill2]\r\n                                   ,[EqipCount3]\r\n                                   ,[SkillDescribe3]\r\n                                   ,[Skill3]\r\n                                   ,[EqipCount4]\r\n                                   ,[SkillDescribe4]\r\n                                   ,[Skill4]\r\n                                   ,[EqipCount5]\r\n                                   ,[SkillDescribe5]\r\n                                   ,[Skill5])\r\n                               VALUES\r\n                                   (@SuitId\r\n                                   ,@SuitName\r\n                                   ,@EqipCount1\r\n                                   ,@SkillDescribe1\r\n                                   ,@Skill1\r\n                                   ,@EqipCount2\r\n                                   ,@SkillDescribe2\r\n                                   ,@Skill2\r\n                                   ,@EqipCount3\r\n                                   ,@SkillDescribe3\r\n                                   ,@Skill3\r\n                                   ,@EqipCount4\r\n                                   ,@SkillDescribe4\r\n                                   ,@Skill4\r\n                                   ,@EqipCount5\r\n                                   ,@SkillDescribe5\r\n                                   ,@Skill5)", new SqlParameter[17]
                {
          new SqlParameter("@SuitId", (object) item.SuitId),
          new SqlParameter("@SuitName", (object) item.SuitName),
          new SqlParameter("@EqipCount1", (object) item.EqipCount1),
          new SqlParameter("@SkillDescribe1", (object) item.SkillDescribe1),
          new SqlParameter("@Skill1", (object) item.Skill1),
          new SqlParameter("@EqipCount2", (object) item.EqipCount2),
          new SqlParameter("@SkillDescribe2", (object) item.SkillDescribe2),
          new SqlParameter("@Skill2", (object) item.Skill2),
          new SqlParameter("@EqipCount3", (object) item.EqipCount3),
          new SqlParameter("@SkillDescribe3", (object) item.SkillDescribe3),
          new SqlParameter("@Skill3", (object) item.Skill3),
          new SqlParameter("@EqipCount4", (object) item.EqipCount4),
          new SqlParameter("@SkillDescribe4", (object) item.SkillDescribe4),
          new SqlParameter("@Skill4", (object) item.Skill4),
          new SqlParameter("@EqipCount5", (object) item.EqipCount5),
          new SqlParameter("@SkillDescribe5", (object) item.SkillDescribe5),
          new SqlParameter("@Skill5", (object) item.Skill5)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddSuitTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateSuitTemplate(SuitTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Suit_Template]\r\n                               SET [SuitId] = @SuitId\r\n                                  ,[SuitName] = @SuitName\r\n                                  ,[EqipCount1] = @EqipCount1\r\n                                  ,[SkillDescribe1] = @SkillDescribe1\r\n                                  ,[Skill1] = @Skill1\r\n                                  ,[EqipCount2] = @EqipCount2\r\n                                  ,[SkillDescribe2] = @SkillDescribe2\r\n                                  ,[Skill2] = @Skill2\r\n                                  ,[EqipCount3] = @EqipCount3\r\n                                  ,[SkillDescribe3] = @SkillDescribe3\r\n                                  ,[Skill3] = @Skill3\r\n                                  ,[EqipCount4] = @EqipCount4\r\n                                  ,[SkillDescribe4] = @SkillDescribe4\r\n                                  ,[Skill4] = @Skill4\r\n                                  ,[EqipCount5] = @EqipCount5\r\n                                  ,[SkillDescribe5] = @SkillDescribe5\r\n                                  ,[Skill5] = @Skill5\r\n                            WHERE [ID] = @ID", new SqlParameter[17]
                {
          new SqlParameter("@SuitId", (object) item.SuitId),
          new SqlParameter("@SuitName", (object) item.SuitName),
          new SqlParameter("@EqipCount1", (object) item.EqipCount1),
          new SqlParameter("@SkillDescribe1", (object) item.SkillDescribe1),
          new SqlParameter("@Skill1", (object) item.Skill1),
          new SqlParameter("@EqipCount2", (object) item.EqipCount2),
          new SqlParameter("@SkillDescribe2", (object) item.SkillDescribe2),
          new SqlParameter("@Skill2", (object) item.Skill2),
          new SqlParameter("@EqipCount3", (object) item.EqipCount3),
          new SqlParameter("@SkillDescribe3", (object) item.SkillDescribe3),
          new SqlParameter("@Skill3", (object) item.Skill3),
          new SqlParameter("@EqipCount4", (object) item.EqipCount4),
          new SqlParameter("@SkillDescribe4", (object) item.SkillDescribe4),
          new SqlParameter("@Skill4", (object) item.Skill4),
          new SqlParameter("@EqipCount5", (object) item.EqipCount5),
          new SqlParameter("@SkillDescribe5", (object) item.SkillDescribe5),
          new SqlParameter("@Skill5", (object) item.Skill5)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateSuitTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteSuitTemplate(int suitId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Suit_Template] WHERE [SuitId] = @SuitId", new SqlParameter[1]
                {
          new SqlParameter("@SuitId", (object) suitId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteSuitTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllSuitTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Suit_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteSuitTemplate: " + ex.ToString());
            }
            return flag;
        }

        public SuitPartEquipInfo[] GetAllSuitPartEquip()
        {
            List<SuitPartEquipInfo> suitPartEquipInfoList = new List<SuitPartEquipInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Suit_Part_Equip]");
                while (Sdr.Read())
                    suitPartEquipInfoList.Add(this.InitSuitPartEquipInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllSuitPartEquip " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return suitPartEquipInfoList.ToArray();
        }

        public SuitPartEquipInfo[] GetAllSuitPartEquipBy(int id)
        {
            List<SuitPartEquipInfo> suitPartEquipInfoList = new List<SuitPartEquipInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Suit_Part_Equip] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    suitPartEquipInfoList.Add(this.InitSuitPartEquipInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllSuitPartEquipBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return suitPartEquipInfoList.ToArray();
        }

        public SuitPartEquipInfo GetSingleSuitPartEquip(int id)
        {
            List<SuitPartEquipInfo> suitPartEquipInfoList = new List<SuitPartEquipInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Suit_Part_Equip] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    suitPartEquipInfoList.Add(this.InitSuitPartEquipInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleSuitPartEquip " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return suitPartEquipInfoList.Count > 0 ? suitPartEquipInfoList[0] : (SuitPartEquipInfo)null;
        }

        public SuitPartEquipInfo InitSuitPartEquipInfo(SqlDataReader reader) => new SuitPartEquipInfo()
        {
            ID = (int)reader["ID"],
            ContainEquip = reader["ContainEquip"] == null ? "" : reader["ContainEquip"].ToString(),
            PartName = reader["PartName"] == null ? "" : reader["PartName"].ToString()
        };

        public bool AddSuitPartEquip(SuitPartEquipInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Suit_Part_Equip]\r\n                                   ([ID]\r\n                                   ,[ContainEquip]\r\n                                   ,[PartName])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@ContainEquip\r\n                                   ,@PartName)", new SqlParameter[3]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@ContainEquip", (object) item.ContainEquip),
          new SqlParameter("@PartName", (object) item.PartName)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddSuitPartEquip: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateSuitPartEquip(SuitPartEquipInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Suit_Part_Equip]\r\n                               SET [ID] = @ID\r\n                                  ,[ContainEquip] = @ContainEquip\r\n                                  ,[PartName] = @PartName\r\n                            WHERE [ID] = @ID", new SqlParameter[3]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@ContainEquip", (object) item.ContainEquip),
          new SqlParameter("@PartName", (object) item.PartName)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateSuitPartEquip: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteSuitPartEquip(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Suit_Part_Equip] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteSuitPartEquip: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllSuitPartEquip()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Suit_Part_Equip]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteSuitPartEquip: " + ex.ToString());
            }
            return flag;
        }

        public MountSkillElementTemplateInfo[] GetAllMountSkillElementTemplate()
        {
            List<MountSkillElementTemplateInfo> elementTemplateInfoList = new List<MountSkillElementTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_SKill_Element_Tempalate]");
                while (Sdr.Read())
                    elementTemplateInfoList.Add(this.InitMountSkillElementTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMountSkillElementTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return elementTemplateInfoList.ToArray();
        }

        public MountSkillElementTemplateInfo[] GetAllMountSkillElementTemplateBy(
          int id)
        {
            List<MountSkillElementTemplateInfo> elementTemplateInfoList = new List<MountSkillElementTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_SKill_Element_Tempalate] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    elementTemplateInfoList.Add(this.InitMountSkillElementTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMountSkillElementTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return elementTemplateInfoList.ToArray();
        }

        public MountSkillElementTemplateInfo GetSingleMountSkillElementTemplate(
          int id)
        {
            List<MountSkillElementTemplateInfo> elementTemplateInfoList = new List<MountSkillElementTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_SKill_Element_Tempalate] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    elementTemplateInfoList.Add(this.InitMountSkillElementTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleMountSkillElementTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return elementTemplateInfoList.Count > 0 ? elementTemplateInfoList[0] : (MountSkillElementTemplateInfo)null;
        }

        public MountSkillElementTemplateInfo InitMountSkillElementTemplateInfo(
          SqlDataReader reader)
        {
            return new MountSkillElementTemplateInfo()
            {
                ID = (int)reader["ID"],
                Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
                EffectPic = reader["EffectPic"] == null ? "" : reader["EffectPic"].ToString(),
                Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
                Pic = (int)reader["Pic"]
            };
        }

        public bool AddMountSkillElementTemplate(MountSkillElementTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Mount_SKill_Element_Tempalate]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[EffectPic]\r\n                                   ,[Description]\r\n                                   ,[Pic])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@EffectPic\r\n                                   ,@Description\r\n                                   ,@Pic)", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@EffectPic", (object) item.EffectPic),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Pic", (object) item.Pic)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddMountSkillElementTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateMountSkillElementTemplate(MountSkillElementTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Mount_SKill_Element_Tempalate]\r\n                               SET [ID] = @ID\r\n                                  ,[Name] = @Name\r\n                                  ,[EffectPic] = @EffectPic\r\n                                  ,[Description] = @Description\r\n                                  ,[Pic] = @Pic\r\n                            WHERE [ID] = @ID", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@EffectPic", (object) item.EffectPic),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Pic", (object) item.Pic)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateMountSkillElementTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteMountSkillElementTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Mount_SKill_Element_Tempalate] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMountSkillElementTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllMountSkillElementTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Mount_SKill_Element_Tempalate]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMountSkillElementTemplate: " + ex.ToString());
            }
            return flag;
        }

        public MountSkillGetTemplateInfo[] GetAllMountSkillGetTemplate()
        {
            List<MountSkillGetTemplateInfo> skillGetTemplateInfoList = new List<MountSkillGetTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_SKill_Get_Template]");
                while (Sdr.Read())
                    skillGetTemplateInfoList.Add(this.InitMountSkillGetTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMountSkillGetTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return skillGetTemplateInfoList.ToArray();
        }

        public MountSkillGetTemplateInfo[] GetAllMountSkillGetTemplateBy(int id)
        {
            List<MountSkillGetTemplateInfo> skillGetTemplateInfoList = new List<MountSkillGetTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_SKill_Get_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    skillGetTemplateInfoList.Add(this.InitMountSkillGetTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMountSkillGetTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return skillGetTemplateInfoList.ToArray();
        }

        public MountSkillGetTemplateInfo GetSingleMountSkillGetTemplate(int id)
        {
            List<MountSkillGetTemplateInfo> skillGetTemplateInfoList = new List<MountSkillGetTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_SKill_Get_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    skillGetTemplateInfoList.Add(this.InitMountSkillGetTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleMountSkillGetTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return skillGetTemplateInfoList.Count > 0 ? skillGetTemplateInfoList[0] : (MountSkillGetTemplateInfo)null;
        }

        public MountSkillGetTemplateInfo InitMountSkillGetTemplateInfo(
          SqlDataReader reader)
        {
            return new MountSkillGetTemplateInfo()
            {
                ID = (int)reader["ID"],
                Level = (int)reader["Level"],
                SkillID = (int)reader["SkillID"],
                NextID = (int)reader["NextID"],
                Type = (int)reader["Type"],
                Exp = (int)reader["Exp"]
            };
        }

        public bool AddMountSkillGetTemplate(MountSkillGetTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Mount_SKill_Get_Template]\r\n                                   ([ID]\r\n                                   ,[Level]\r\n                                   ,[SkillID]\r\n                                   ,[NextID]\r\n                                   ,[Type]\r\n                                   ,[Exp])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Level\r\n                                   ,@SkillID\r\n                                   ,@NextID\r\n                                   ,@Type\r\n                                   ,@Exp)", new SqlParameter[6]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@SkillID", (object) item.SkillID),
          new SqlParameter("@NextID", (object) item.NextID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@Exp", (object) item.Exp)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddMountSkillGetTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateMountSkillGetTemplate(MountSkillGetTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Mount_SKill_Get_Template]\r\n                               SET [ID] = @ID\r\n                                  ,[Level] = @Level\r\n                                  ,[SkillID] = @SkillID\r\n                                  ,[NextID] = @NextID\r\n                                  ,[Type] = @Type\r\n                                  ,[Exp] = @Exp\r\n                            WHERE [ID] = @ID", new SqlParameter[6]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@SkillID", (object) item.SkillID),
          new SqlParameter("@NextID", (object) item.NextID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@Exp", (object) item.Exp)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateMountSkillGetTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteMountSkillGetTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Mount_SKill_Get_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMountSkillGetTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllMountSkillGetTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Mount_SKill_Get_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMountSkillGetTemplate: " + ex.ToString());
            }
            return flag;
        }

        public MountSkillTemplateInfo[] GetAllMountSkillTemplate()
        {
            List<MountSkillTemplateInfo> skillTemplateInfoList = new List<MountSkillTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_Skill_Template]");
                while (Sdr.Read())
                    skillTemplateInfoList.Add(this.InitMountSkillTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMountSkillTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return skillTemplateInfoList.ToArray();
        }

        public MountSkillTemplateInfo[] GetAllMountSkillTemplateBy(int id)
        {
            List<MountSkillTemplateInfo> skillTemplateInfoList = new List<MountSkillTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_Skill_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    skillTemplateInfoList.Add(this.InitMountSkillTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMountSkillTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return skillTemplateInfoList.ToArray();
        }

        public MountSkillTemplateInfo GetSingleMountSkillTemplate(int id)
        {
            List<MountSkillTemplateInfo> skillTemplateInfoList = new List<MountSkillTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_Skill_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    skillTemplateInfoList.Add(this.InitMountSkillTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleMountSkillTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return skillTemplateInfoList.Count > 0 ? skillTemplateInfoList[0] : (MountSkillTemplateInfo)null;
        }

        public MountSkillTemplateInfo InitMountSkillTemplateInfo(
          SqlDataReader reader)
        {
            return new MountSkillTemplateInfo()
            {
                ID = (int)reader["ID"],
                Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
                ElementIDs = reader["ElementIDs"] == null ? "" : reader["ElementIDs"].ToString(),
                Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
                BallType = (int)reader["BallType"],
                NewBallID = (int)reader["NewBallID"],
                CostMP = (int)reader["CostMP"],
                Pic = (int)reader["Pic"],
                Action = reader["Action"] == null ? "" : reader["Action"].ToString(),
                EffectPic = reader["EffectPic"] == null ? "" : reader["EffectPic"].ToString(),
                Delay = (int)reader["Delay"],
                ColdDown = (int)reader["ColdDown"],
                GameType = (int)reader["GameType"],
                Probability = (int)reader["Probability"],
                CostEnergy = (int)reader["CostEnergy"],
                UseCount = (int)reader["UseCount"]
            };
        }

        public bool AddMountSkillTemplate(MountSkillTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Mount_Skill_Template]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[ElementIDs]\r\n                                   ,[Description]\r\n                                   ,[BallType]\r\n                                   ,[NewBallID]\r\n                                   ,[CostMP]\r\n                                   ,[Pic]\r\n                                   ,[Action]\r\n                                   ,[EffectPic]\r\n                                   ,[Delay]\r\n                                   ,[ColdDown]\r\n                                   ,[GameType]\r\n                                   ,[Probability]\r\n                                   ,[CostEnergy]\r\n                                   ,[UseCount])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@ElementIDs\r\n                                   ,@Description\r\n                                   ,@BallType\r\n                                   ,@NewBallID\r\n                                   ,@CostMP\r\n                                   ,@Pic\r\n                                   ,@Action\r\n                                   ,@EffectPic\r\n                                   ,@Delay\r\n                                   ,@ColdDown\r\n                                   ,@GameType\r\n                                   ,@Probability\r\n                                   ,@CostEnergy\r\n                                   ,@UseCount)", new SqlParameter[16]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@ElementIDs", (object) item.ElementIDs),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@BallType", (object) item.BallType),
          new SqlParameter("@NewBallID", (object) item.NewBallID),
          new SqlParameter("@CostMP", (object) item.CostMP),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@Action", (object) item.Action),
          new SqlParameter("@EffectPic", (object) item.EffectPic),
          new SqlParameter("@Delay", (object) item.Delay),
          new SqlParameter("@ColdDown", (object) item.ColdDown),
          new SqlParameter("@GameType", (object) item.GameType),
          new SqlParameter("@Probability", (object) item.Probability),
          new SqlParameter("@CostEnergy", (object) item.CostEnergy),
          new SqlParameter("@UseCount", (object) item.UseCount)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddMountSkillTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateMountSkillTemplate(MountSkillTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Mount_Skill_Template]\r\n                               SET [ID] = @ID\r\n                                  ,[Name] = @Name\r\n                                  ,[ElementIDs] = @ElementIDs\r\n                                  ,[Description] = @Description\r\n                                  ,[BallType] = @BallType\r\n                                  ,[NewBallID] = @NewBallID\r\n                                  ,[CostMP] = @CostMP\r\n                                  ,[Pic] = @Pic\r\n                                  ,[Action] = @Action\r\n                                  ,[EffectPic] = @EffectPic\r\n                                  ,[Delay] = @Delay\r\n                                  ,[ColdDown] = @ColdDown\r\n                                  ,[GameType] = @GameType\r\n                                  ,[Probability] = @Probability\r\n                                  ,[CostEnergy] = @CostEnergy\r\n                                  ,[UseCount] = @UseCount\r\n                            WHERE [ID] = @ID", new SqlParameter[16]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@ElementIDs", (object) item.ElementIDs),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@BallType", (object) item.BallType),
          new SqlParameter("@NewBallID", (object) item.NewBallID),
          new SqlParameter("@CostMP", (object) item.CostMP),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@Action", (object) item.Action),
          new SqlParameter("@EffectPic", (object) item.EffectPic),
          new SqlParameter("@Delay", (object) item.Delay),
          new SqlParameter("@ColdDown", (object) item.ColdDown),
          new SqlParameter("@GameType", (object) item.GameType),
          new SqlParameter("@Probability", (object) item.Probability),
          new SqlParameter("@CostEnergy", (object) item.CostEnergy),
          new SqlParameter("@UseCount", (object) item.UseCount)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateMountSkillTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteMountSkillTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Mount_Skill_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMountSkillTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllMountSkillTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Mount_Skill_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMountSkillTemplate: " + ex.ToString());
            }
            return flag;
        }

        public MountTemplateInfo[] GetAllMountTemplate()
        {
            List<MountTemplateInfo> mountTemplateInfoList = new List<MountTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_Template]");
                while (Sdr.Read())
                    mountTemplateInfoList.Add(this.InitMountTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMountTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return mountTemplateInfoList.ToArray();
        }

        public MountTemplateInfo[] GetAllMountTemplateBy(int id)
        {
            List<MountTemplateInfo> mountTemplateInfoList = new List<MountTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    mountTemplateInfoList.Add(this.InitMountTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMountTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return mountTemplateInfoList.ToArray();
        }

        public MountTemplateInfo GetSingleMountTemplate(int id)
        {
            List<MountTemplateInfo> mountTemplateInfoList = new List<MountTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    mountTemplateInfoList.Add(this.InitMountTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleMountTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return mountTemplateInfoList.Count > 0 ? mountTemplateInfoList[0] : (MountTemplateInfo)null;
        }

        public MountTemplateInfo InitMountTemplateInfo(SqlDataReader reader) => new MountTemplateInfo()
        {
            Grade = (int)reader["Grade"],
            Experience = (int)reader["Experience"],
            SkillID = (int)reader["SkillID"],
            AddDamage = (int)reader["AddDamage"],
            AddGuard = (int)reader["AddGuard"],
            MagicAttack = (int)reader["MagicAttack"],
            MagicDefence = (int)reader["MagicDefence"],
            AddBlood = (int)reader["AddBlood"]
        };

        public bool AddMountTemplate(MountTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Mount_Template]\r\n                                   ([Grade]\r\n                                   ,[Experience]\r\n                                   ,[SkillID]\r\n                                   ,[AddDamage]\r\n                                   ,[AddGuard]\r\n                                   ,[MagicAttack]\r\n                                   ,[MagicDefence]\r\n                                   ,[AddBlood])\r\n                               VALUES\r\n                                   (@Grade\r\n                                   ,@Experience\r\n                                   ,@SkillID\r\n                                   ,@AddDamage\r\n                                   ,@AddGuard\r\n                                   ,@MagicAttack\r\n                                   ,@MagicDefence\r\n                                   ,@AddBlood)", new SqlParameter[8]
                {
          new SqlParameter("@Grade", (object) item.Grade),
          new SqlParameter("@Experience", (object) item.Experience),
          new SqlParameter("@SkillID", (object) item.SkillID),
          new SqlParameter("@AddDamage", (object) item.AddDamage),
          new SqlParameter("@AddGuard", (object) item.AddGuard),
          new SqlParameter("@MagicAttack", (object) item.MagicAttack),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence),
          new SqlParameter("@AddBlood", (object) item.AddBlood)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddMountTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateMountTemplate(MountTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Mount_Template]\r\n                               SET [Grade] = @Grade\r\n                                  ,[Experience] = @Experience\r\n                                  ,[SkillID] = @SkillID\r\n                                  ,[AddDamage] = @AddDamage\r\n                                  ,[AddGuard] = @AddGuard\r\n                                  ,[MagicAttack] = @MagicAttack\r\n                                  ,[MagicDefence] = @MagicDefence\r\n                                  ,[AddBlood] = @AddBlood\r\n                            WHERE [ID] = @ID", new SqlParameter[8]
                {
          new SqlParameter("@Grade", (object) item.Grade),
          new SqlParameter("@Experience", (object) item.Experience),
          new SqlParameter("@SkillID", (object) item.SkillID),
          new SqlParameter("@AddDamage", (object) item.AddDamage),
          new SqlParameter("@AddGuard", (object) item.AddGuard),
          new SqlParameter("@MagicAttack", (object) item.MagicAttack),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence),
          new SqlParameter("@AddBlood", (object) item.AddBlood)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateMountTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteMountTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Mount_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMountTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllMountTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Mount_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMountTemplate: " + ex.ToString());
            }
            return flag;
        }

        public RankTemplateInfo[] GetAllRankTemplate()
        {
            List<RankTemplateInfo> rankTemplateInfoList = new List<RankTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Rank_Template]");
                while (Sdr.Read())
                    rankTemplateInfoList.Add(this.InitRankTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllRankTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return rankTemplateInfoList.ToArray();
        }

        public RankTemplateInfo[] GetAllRankTemplateBy(int id)
        {
            List<RankTemplateInfo> rankTemplateInfoList = new List<RankTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Rank_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    rankTemplateInfoList.Add(this.InitRankTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllRankTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return rankTemplateInfoList.ToArray();
        }

        public RankTemplateInfo GetSingleRankTemplate(int id)
        {
            List<RankTemplateInfo> rankTemplateInfoList = new List<RankTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Rank_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    rankTemplateInfoList.Add(this.InitRankTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleRankTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return rankTemplateInfoList.Count > 0 ? rankTemplateInfoList[0] : (RankTemplateInfo)null;
        }

        public RankTemplateInfo InitRankTemplateInfo(SqlDataReader reader) => new RankTemplateInfo()
        {
            ID = (int)reader["ID"],
            Rank = reader["Rank"] == null ? "" : reader["Rank"].ToString(),
            Attack = (int)reader["Attack"],
            Defend = (int)reader["Defend"],
            Agility = (int)reader["Agility"],
            Lucky = (int)reader["Lucky"]
        };

        public bool AddRankTemplate(RankTemplateInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Rank_Template]\r\n                                   ([Rank]\r\n                                   ,[Attack]\r\n                                   ,[Defend]\r\n                                   ,[Agility]\r\n                                   ,[Lucky])\r\n                               VALUES\r\n                                   (@Rank\r\n                                   ,@Attack\r\n                                   ,@Defend\r\n                                   ,@Agility\r\n                                   ,@Lucky)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[6];
                SqlParameters[0] = new SqlParameter("@ID", (object)item.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Rank", (object)item.Rank);
                SqlParameters[2] = new SqlParameter("@Attack", (object)item.Attack);
                SqlParameters[3] = new SqlParameter("@Defend", (object)item.Defend);
                SqlParameters[4] = new SqlParameter("@Agility", (object)item.Agility);
                SqlParameters[5] = new SqlParameter("@Lucky", (object)item.Lucky);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddRankTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateRankTemplate(RankTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Rank_Template]\r\n                               SET [Rank] = @Rank\r\n                                  ,[Attack] = @Attack\r\n                                  ,[Defend] = @Defend\r\n                                  ,[Agility] = @Agility\r\n                                  ,[Lucky] = @Lucky\r\n                            WHERE [ID] = @ID", new SqlParameter[6]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Rank", (object) item.Rank),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defend", (object) item.Defend),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Lucky", (object) item.Lucky)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateRankTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteRankTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Rank_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteRankTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllRankTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Rank_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteRankTemplate: " + ex.ToString());
            }
            return flag;
        }

        public PveInfo[] GetAllPve()
        {
            List<PveInfo> pveInfoList = new List<PveInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pve_Info]");
                while (Sdr.Read())
                    pveInfoList.Add(this.InitPveInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPve " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return pveInfoList.ToArray();
        }

        public PveInfo[] GetAllPveBy(int id)
        {
            List<PveInfo> pveInfoList = new List<PveInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pve_Info] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    pveInfoList.Add(this.InitPveInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPveBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return pveInfoList.ToArray();
        }

        public PveInfo GetSinglePve(int id)
        {
            List<PveInfo> pveInfoList = new List<PveInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pve_Info] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    pveInfoList.Add(this.InitPveInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePve " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return pveInfoList.Count > 0 ? pveInfoList[0] : (PveInfo)null;
        }

        public PveInfo InitPveInfo(SqlDataReader reader) => new PveInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Type = (int)reader["Type"],
            LevelLimits = (int)reader["LevelLimits"],
            SimpleTemplateIds = reader["SimpleTemplateIds"] == null ? "" : reader["SimpleTemplateIds"].ToString(),
            NormalTemplateIds = reader["NormalTemplateIds"] == null ? "" : reader["NormalTemplateIds"].ToString(),
            HardTemplateIds = reader["HardTemplateIds"] == null ? "" : reader["HardTemplateIds"].ToString(),
            TerrorTemplateIds = reader["TerrorTemplateIds"] == null ? "" : reader["TerrorTemplateIds"].ToString(),
            NightmareTemplateIds = reader["NightmareTemplateIds"] == null ? "" : reader["NightmareTemplateIds"].ToString(),
            EpicTemplateIds = reader["EpicTemplateIds"] == null ? "" : reader["EpicTemplateIds"].ToString(),
            Pic = reader["Pic"] == null ? "" : reader["Pic"].ToString(),
            Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
            SimpleGameScript = reader["SimpleGameScript"] == null ? "" : reader["SimpleGameScript"].ToString(),
            NormalGameScript = reader["NormalGameScript"] == null ? "" : reader["NormalGameScript"].ToString(),
            HardGameScript = reader["HardGameScript"] == null ? "" : reader["HardGameScript"].ToString(),
            TerrorGameScript = reader["TerrorGameScript"] == null ? "" : reader["TerrorGameScript"].ToString(),
            EpicGameScript = reader["EpicGameScript"] == null ? "" : reader["EpicGameScript"].ToString(),
            NightmareGameScript = reader["NightmareGameScript"] == null ? "" : reader["NightmareGameScript"].ToString(),
            Ordering = (int)reader["Ordering"],
            AdviceTips = reader["AdviceTips"] == null ? "" : reader["AdviceTips"].ToString(),
            BossFightNeedMoney = reader["BossFightNeedMoney"] == null ? "" : reader["BossFightNeedMoney"].ToString(),
            MinLv = (int)reader["MinLv"],
            MaxLv = (int)reader["MaxLv"]
        };

        public bool AddPve(PveInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Pve_Info]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[Type]\r\n                                   ,[LevelLimits]\r\n                                   ,[SimpleTemplateIds]\r\n                                   ,[NormalTemplateIds]\r\n                                   ,[HardTemplateIds]\r\n                                   ,[TerrorTemplateIds]\r\n                                   ,[NightmareTemplateIds]\r\n                                   ,[EpicTemplateIds]\r\n                                   ,[Pic]\r\n                                   ,[Description]\r\n                                   ,[SimpleGameScript]\r\n                                   ,[NormalGameScript]\r\n                                   ,[HardGameScript]\r\n                                   ,[TerrorGameScript]\r\n                                   ,[EpicGameScript]\r\n                                   ,[NightmareGameScript]\r\n                                   ,[Ordering]\r\n                                   ,[AdviceTips]\r\n                                   ,[BossFightNeedMoney]\r\n                                   ,[MinLv]\r\n                                   ,[MaxLv])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@Type\r\n                                   ,@LevelLimits\r\n                                   ,@SimpleTemplateIds\r\n                                   ,@NormalTemplateIds\r\n                                   ,@HardTemplateIds\r\n                                   ,@TerrorTemplateIds\r\n                                   ,@NightmareTemplateIds\r\n                                   ,@EpicTemplateIds\r\n                                   ,@Pic\r\n                                   ,@Description\r\n                                   ,@SimpleGameScript\r\n                                   ,@NormalGameScript\r\n                                   ,@HardGameScript\r\n                                   ,@TerrorGameScript\r\n                                   ,@EpicGameScript\r\n                                   ,@NightmareGameScript\r\n                                   ,@Ordering\r\n                                   ,@AdviceTips\r\n                                   ,@BossFightNeedMoney\r\n                                   ,@MinLv\r\n                                   ,@MaxLv)", new SqlParameter[23]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@LevelLimits", (object) item.LevelLimits),
          new SqlParameter("@SimpleTemplateIds", (object) item.SimpleTemplateIds),
          new SqlParameter("@NormalTemplateIds", (object) item.NormalTemplateIds),
          new SqlParameter("@HardTemplateIds", (object) item.HardTemplateIds),
          new SqlParameter("@TerrorTemplateIds", (object) item.TerrorTemplateIds),
          new SqlParameter("@NightmareTemplateIds", (object) item.NightmareTemplateIds),
          new SqlParameter("@EpicTemplateIds", (object) item.EpicTemplateIds),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@SimpleGameScript", (object) item.SimpleGameScript),
          new SqlParameter("@NormalGameScript", (object) item.NormalGameScript),
          new SqlParameter("@HardGameScript", (object) item.HardGameScript),
          new SqlParameter("@TerrorGameScript", (object) item.TerrorGameScript),
          new SqlParameter("@EpicGameScript", (object) item.EpicGameScript),
          new SqlParameter("@NightmareGameScript", (object) item.NightmareGameScript),
          new SqlParameter("@Ordering", (object) item.Ordering),
          new SqlParameter("@AdviceTips", (object) item.AdviceTips),
          new SqlParameter("@BossFightNeedMoney", (object) item.BossFightNeedMoney),
          new SqlParameter("@MinLv", (object) item.MinLv),
          new SqlParameter("@MaxLv", (object) item.MaxLv)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddPve: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePve(PveInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pve_Info]\r\n                               SET [ID] = @ID\r\n                                  ,[Name] = @Name\r\n                                  ,[Type] = @Type\r\n                                  ,[LevelLimits] = @LevelLimits\r\n                                  ,[SimpleTemplateIds] = @SimpleTemplateIds\r\n                                  ,[NormalTemplateIds] = @NormalTemplateIds\r\n                                  ,[HardTemplateIds] = @HardTemplateIds\r\n                                  ,[TerrorTemplateIds] = @TerrorTemplateIds\r\n                                  ,[NightmareTemplateIds] = @NightmareTemplateIds\r\n                                  ,[EpicTemplateIds] = @EpicTemplateIds\r\n                                  ,[Pic] = @Pic\r\n                                  ,[Description] = @Description\r\n                                  ,[SimpleGameScript] = @SimpleGameScript\r\n                                  ,[NormalGameScript] = @NormalGameScript\r\n                                  ,[HardGameScript] = @HardGameScript\r\n                                  ,[TerrorGameScript] = @TerrorGameScript\r\n                                  ,[EpicGameScript] = @EpicGameScript\r\n                                  ,[NightmareGameScript] = @NightmareGameScript\r\n                                  ,[Ordering] = @Ordering\r\n                                  ,[AdviceTips] = @AdviceTips\r\n                                  ,[BossFightNeedMoney] = @BossFightNeedMoney\r\n                                  ,[MinLv] = @MinLv\r\n                                  ,[MaxLv] = @MaxLv\r\n                            WHERE [ID] = @ID", new SqlParameter[23]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@LevelLimits", (object) item.LevelLimits),
          new SqlParameter("@SimpleTemplateIds", (object) item.SimpleTemplateIds),
          new SqlParameter("@NormalTemplateIds", (object) item.NormalTemplateIds),
          new SqlParameter("@HardTemplateIds", (object) item.HardTemplateIds),
          new SqlParameter("@TerrorTemplateIds", (object) item.TerrorTemplateIds),
          new SqlParameter("@NightmareTemplateIds", (object) item.NightmareTemplateIds),
          new SqlParameter("@EpicTemplateIds", (object) item.EpicTemplateIds),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@SimpleGameScript", (object) item.SimpleGameScript),
          new SqlParameter("@NormalGameScript", (object) item.NormalGameScript),
          new SqlParameter("@HardGameScript", (object) item.HardGameScript),
          new SqlParameter("@TerrorGameScript", (object) item.TerrorGameScript),
          new SqlParameter("@EpicGameScript", (object) item.EpicGameScript),
          new SqlParameter("@NightmareGameScript", (object) item.NightmareGameScript),
          new SqlParameter("@Ordering", (object) item.Ordering),
          new SqlParameter("@AdviceTips", (object) item.AdviceTips),
          new SqlParameter("@BossFightNeedMoney", (object) item.BossFightNeedMoney),
          new SqlParameter("@MinLv", (object) item.MinLv),
          new SqlParameter("@MaxLv", (object) item.MaxLv)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePve: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePve(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pve_Info] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePve: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllPve()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pve_Info]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePve: " + ex.ToString());
            }
            return flag;
        }

        public MapServerInfo[] GetAllMapServer()
        {
            List<MapServerInfo> mapServerInfoList = new List<MapServerInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Map_Server]");
                while (Sdr.Read())
                    mapServerInfoList.Add(this.InitMapServerInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMapServer " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return mapServerInfoList.ToArray();
        }

        public MapServerInfo[] GetAllMapServerBy(int id)
        {
            List<MapServerInfo> mapServerInfoList = new List<MapServerInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Map_Server] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    mapServerInfoList.Add(this.InitMapServerInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMapServerBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return mapServerInfoList.ToArray();
        }

        public MapServerInfo GetSingleMapServer(int id)
        {
            List<MapServerInfo> mapServerInfoList = new List<MapServerInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Map_Server] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    mapServerInfoList.Add(this.InitMapServerInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleMapServer " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return mapServerInfoList.Count > 0 ? mapServerInfoList[0] : (MapServerInfo)null;
        }

        public MapServerInfo InitMapServerInfo(SqlDataReader reader) => new MapServerInfo()
        {
            ServerID = (int)reader["ServerID"],
            OpenMap = reader["OpenMap"] == null ? "" : reader["OpenMap"].ToString(),
            IsSpecial = (int)reader["IsSpecial"]
        };

        public bool AddMapServer(MapServerInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Map_Server]\r\n                                   ([ServerID]\r\n                                   ,[OpenMap]\r\n                                   ,[IsSpecial])\r\n                               VALUES\r\n                                   (@ServerID\r\n                                   ,@OpenMap\r\n                                   ,@IsSpecial)", new SqlParameter[3]
                {
          new SqlParameter("@ServerID", (object) item.ServerID),
          new SqlParameter("@OpenMap", (object) item.OpenMap),
          new SqlParameter("@IsSpecial", (object) item.IsSpecial)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddMapServer: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateMapServer(MapServerInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Map_Server]\r\n                               SET [ServerID] = @ServerID\r\n                                  ,[OpenMap] = @OpenMap\r\n                                  ,[IsSpecial] = @IsSpecial\r\n                            WHERE [ID] = @ID", new SqlParameter[3]
                {
          new SqlParameter("@ServerID", (object) item.ServerID),
          new SqlParameter("@OpenMap", (object) item.OpenMap),
          new SqlParameter("@IsSpecial", (object) item.IsSpecial)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateMapServer: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteMapServer(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Map_Server] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMapServer: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllMapServer()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Map_Server]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMapServer: " + ex.ToString());
            }
            return flag;
        }

        public MapInfo[] GetAllMap()
        {
            List<MapInfo> mapInfoList = new List<MapInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Game_Map]");
                while (Sdr.Read())
                    mapInfoList.Add(this.InitMapInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMap " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return mapInfoList.ToArray();
        }

        public MapInfo[] GetAllMapBy(int id)
        {
            List<MapInfo> mapInfoList = new List<MapInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Game_Map] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    mapInfoList.Add(this.InitMapInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMapBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return mapInfoList.ToArray();
        }

        public MapInfo GetSingleMap(int id)
        {
            List<MapInfo> mapInfoList = new List<MapInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Game_Map] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    mapInfoList.Add(this.InitMapInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleMap " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return mapInfoList.Count > 0 ? mapInfoList[0] : (MapInfo)null;
        }

        public MapInfo InitMapInfo(SqlDataReader reader) => new MapInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
            ForegroundWidth = (int)reader["ForegroundWidth"],
            ForegroundHeight = (int)reader["ForegroundHeight"],
            BackroundWidht = (int)reader["BackroundWidht"],
            BackroundHeight = (int)reader["BackroundHeight"],
            DeadWidth = (int)reader["DeadWidth"],
            DeadHeight = (int)reader["DeadHeight"],
            Weight = (int)reader["Weight"],
            DragIndex = (int)reader["DragIndex"],
            ForePic = reader["ForePic"] == null ? "" : reader["ForePic"].ToString(),
            BackPic = reader["BackPic"] == null ? "" : reader["BackPic"].ToString(),
            DeadPic = reader["DeadPic"] == null ? "" : reader["DeadPic"].ToString(),
            Pic = reader["Pic"] == null ? "" : reader["Pic"].ToString(),
            Remark = reader["Remark"] == null ? "" : reader["Remark"].ToString(),
            BackMusic = reader["BackMusic"] == null ? "" : reader["BackMusic"].ToString(),
            PosX = reader["PosX"] == null ? "" : reader["PosX"].ToString(),
            Type = (byte)reader["Type"],
            PosX1 = reader["PosX1"] == null ? "" : reader["PosX1"].ToString()
        };

        public bool AddMap(MapInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Game_Map]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[Description]\r\n                                   ,[ForegroundWidth]\r\n                                   ,[ForegroundHeight]\r\n                                   ,[BackroundWidht]\r\n                                   ,[BackroundHeight]\r\n                                   ,[DeadWidth]\r\n                                   ,[DeadHeight]\r\n                                   ,[Weight]\r\n                                   ,[DragIndex]\r\n                                   ,[ForePic]\r\n                                   ,[BackPic]\r\n                                   ,[DeadPic]\r\n                                   ,[Pic]\r\n                                   ,[Remark]\r\n                                   ,[BackMusic]\r\n                                   ,[PosX]\r\n                                   ,[Type]\r\n                                   ,[PosX1])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@Description\r\n                                   ,@ForegroundWidth\r\n                                   ,@ForegroundHeight\r\n                                   ,@BackroundWidht\r\n                                   ,@BackroundHeight\r\n                                   ,@DeadWidth\r\n                                   ,@DeadHeight\r\n                                   ,@Weight\r\n                                   ,@DragIndex\r\n                                   ,@ForePic\r\n                                   ,@BackPic\r\n                                   ,@DeadPic\r\n                                   ,@Pic\r\n                                   ,@Remark\r\n                                   ,@BackMusic\r\n                                   ,@PosX\r\n                                   ,@Type\r\n                                   ,@PosX1)", new SqlParameter[20]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@ForegroundWidth", (object) item.ForegroundWidth),
          new SqlParameter("@ForegroundHeight", (object) item.ForegroundHeight),
          new SqlParameter("@BackroundWidht", (object) item.BackroundWidht),
          new SqlParameter("@BackroundHeight", (object) item.BackroundHeight),
          new SqlParameter("@DeadWidth", (object) item.DeadWidth),
          new SqlParameter("@DeadHeight", (object) item.DeadHeight),
          new SqlParameter("@Weight", (object) item.Weight),
          new SqlParameter("@DragIndex", (object) item.DragIndex),
          new SqlParameter("@ForePic", (object) item.ForePic),
          new SqlParameter("@BackPic", (object) item.BackPic),
          new SqlParameter("@DeadPic", (object) item.DeadPic),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@Remark", (object) item.Remark),
          new SqlParameter("@BackMusic", (object) item.BackMusic),
          new SqlParameter("@PosX", (object) item.PosX),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@PosX1", (object) item.PosX1)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddMap: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateMap(MapInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Game_Map]\r\n                               SET [ID] = @ID\r\n                                  ,[Name] = @Name\r\n                                  ,[Description] = @Description\r\n                                  ,[ForegroundWidth] = @ForegroundWidth\r\n                                  ,[ForegroundHeight] = @ForegroundHeight\r\n                                  ,[BackroundWidht] = @BackroundWidht\r\n                                  ,[BackroundHeight] = @BackroundHeight\r\n                                  ,[DeadWidth] = @DeadWidth\r\n                                  ,[DeadHeight] = @DeadHeight\r\n                                  ,[Weight] = @Weight\r\n                                  ,[DragIndex] = @DragIndex\r\n                                  ,[ForePic] = @ForePic\r\n                                  ,[BackPic] = @BackPic\r\n                                  ,[DeadPic] = @DeadPic\r\n                                  ,[Pic] = @Pic\r\n                                  ,[Remark] = @Remark\r\n                                  ,[BackMusic] = @BackMusic\r\n                                  ,[PosX] = @PosX\r\n                                  ,[Type] = @Type\r\n                                  ,[PosX1] = @PosX1\r\n                            WHERE [ID] = @ID", new SqlParameter[20]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@ForegroundWidth", (object) item.ForegroundWidth),
          new SqlParameter("@ForegroundHeight", (object) item.ForegroundHeight),
          new SqlParameter("@BackroundWidht", (object) item.BackroundWidht),
          new SqlParameter("@BackroundHeight", (object) item.BackroundHeight),
          new SqlParameter("@DeadWidth", (object) item.DeadWidth),
          new SqlParameter("@DeadHeight", (object) item.DeadHeight),
          new SqlParameter("@Weight", (object) item.Weight),
          new SqlParameter("@DragIndex", (object) item.DragIndex),
          new SqlParameter("@ForePic", (object) item.ForePic),
          new SqlParameter("@BackPic", (object) item.BackPic),
          new SqlParameter("@DeadPic", (object) item.DeadPic),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@Remark", (object) item.Remark),
          new SqlParameter("@BackMusic", (object) item.BackMusic),
          new SqlParameter("@PosX", (object) item.PosX),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@PosX1", (object) item.PosX1)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateMap: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteMap(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Game_Map] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMap: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllMap()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Game_Map]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMap: " + ex.ToString());
            }
            return flag;
        }

        public NewTitleInfo[] GetAllNewTitle()
        {
            List<NewTitleInfo> newTitleInfoList = new List<NewTitleInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[New_Title]");
                while (Sdr.Read())
                    newTitleInfoList.Add(this.InitNewTitleInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllNewTitle " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return newTitleInfoList.ToArray();
        }

        public NewTitleInfo[] GetAllNewTitleBy(int id)
        {
            List<NewTitleInfo> newTitleInfoList = new List<NewTitleInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[New_Title] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    newTitleInfoList.Add(this.InitNewTitleInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllNewTitleBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return newTitleInfoList.ToArray();
        }

        public NewTitleInfo GetSingleNewTitle(int id)
        {
            List<NewTitleInfo> newTitleInfoList = new List<NewTitleInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[New_Title] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    newTitleInfoList.Add(this.InitNewTitleInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleNewTitle " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return newTitleInfoList.Count > 0 ? newTitleInfoList[0] : (NewTitleInfo)null;
        }

        public NewTitleInfo InitNewTitleInfo(SqlDataReader reader) => new NewTitleInfo()
        {
            ID = (int)reader["ID"],
            Show = (int)reader["Show"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Pic = (int)reader["Pic"],
            Att = (int)reader["Att"],
            Def = (int)reader["Def"],
            Agi = (int)reader["Agi"],
            Luck = (int)reader["Luck"]
        };

        public bool AddNewTitle(NewTitleInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[New_Title]\r\n                                   ([ID]\r\n                                   ,[Show]\r\n                                   ,[Name]\r\n                                   ,[Pic]\r\n                                   ,[Att]\r\n                                   ,[Def]\r\n                                   ,[Agi]\r\n                                   ,[Luck])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Show\r\n                                   ,@Name\r\n                                   ,@Pic\r\n                                   ,@Att\r\n                                   ,@Def\r\n                                   ,@Agi\r\n                                   ,@Luck)", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Show", (object) item.Show),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@Att", (object) item.Att),
          new SqlParameter("@Def", (object) item.Def),
          new SqlParameter("@Agi", (object) item.Agi),
          new SqlParameter("@Luck", (object) item.Luck)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddNewTitle: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateNewTitle(NewTitleInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[New_Title]\r\n                               SET [ID] = @ID\r\n                                  ,[Show] = @Show\r\n                                  ,[Name] = @Name\r\n                                  ,[Pic] = @Pic\r\n                                  ,[Att] = @Att\r\n                                  ,[Def] = @Def\r\n                                  ,[Agi] = @Agi\r\n                                  ,[Luck] = @Luck\r\n                            WHERE [ID] = @ID", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Show", (object) item.Show),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@Att", (object) item.Att),
          new SqlParameter("@Def", (object) item.Def),
          new SqlParameter("@Agi", (object) item.Agi),
          new SqlParameter("@Luck", (object) item.Luck)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateNewTitle: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteNewTitle(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[New_Title] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteNewTitle: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllNewTitle()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[New_Title]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteNewTitle: " + ex.ToString());
            }
            return flag;
        }

        public GoldEquipTemplateInfo[] GetAllGoldEquipTemplate()
        {
            List<GoldEquipTemplateInfo> equipTemplateInfoList = new List<GoldEquipTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[GoldEquipTemplateLoad]");
                while (Sdr.Read())
                    equipTemplateInfoList.Add(this.InitGoldEquipTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllGoldEquipTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return equipTemplateInfoList.ToArray();
        }

        public GoldEquipTemplateInfo[] GetAllGoldEquipTemplateBy(int id)
        {
            List<GoldEquipTemplateInfo> equipTemplateInfoList = new List<GoldEquipTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[GoldEquipTemplateLoad] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    equipTemplateInfoList.Add(this.InitGoldEquipTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllGoldEquipTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return equipTemplateInfoList.ToArray();
        }

        public GoldEquipTemplateInfo GetSingleGoldEquipTemplate(int id)
        {
            List<GoldEquipTemplateInfo> equipTemplateInfoList = new List<GoldEquipTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[GoldEquipTemplateLoad] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    equipTemplateInfoList.Add(this.InitGoldEquipTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleGoldEquipTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return equipTemplateInfoList.Count > 0 ? equipTemplateInfoList[0] : (GoldEquipTemplateInfo)null;
        }

        public GoldEquipTemplateInfo InitGoldEquipTemplateInfo(SqlDataReader reader) => new GoldEquipTemplateInfo()
        {
            ID = (int)reader["ID"],
            OldTemplateId = (int)reader["OldTemplateId"],
            NewTemplateId = (int)reader["NewTemplateId"],
            CategoryID = (int)reader["CategoryID"],
            Strengthen = (int)reader["Strengthen"],
            Attack = (int)reader["Attack"],
            Defence = (int)reader["Defence"],
            Agility = (int)reader["Agility"],
            Luck = (int)reader["Luck"],
            Damage = (int)reader["Damage"],
            Guard = (int)reader["Guard"],
            Boold = (int)reader["Boold"],
            BlessID = (int)reader["BlessID"],
            Pic = reader["Pic"] == null ? "" : reader["Pic"].ToString()
        };

        public bool AddGoldEquipTemplate(GoldEquipTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[GoldEquipTemplateLoad]\r\n                                   ([ID]\r\n                                   ,[OldTemplateId]\r\n                                   ,[NewTemplateId]\r\n                                   ,[CategoryID]\r\n                                   ,[Strengthen]\r\n                                   ,[Attack]\r\n                                   ,[Defence]\r\n                                   ,[Agility]\r\n                                   ,[Luck]\r\n                                   ,[Damage]\r\n                                   ,[Guard]\r\n                                   ,[Boold]\r\n                                   ,[BlessID]\r\n                                   ,[Pic])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@OldTemplateId\r\n                                   ,@NewTemplateId\r\n                                   ,@CategoryID\r\n                                   ,@Strengthen\r\n                                   ,@Attack\r\n                                   ,@Defence\r\n                                   ,@Agility\r\n                                   ,@Luck\r\n                                   ,@Damage\r\n                                   ,@Guard\r\n                                   ,@Boold\r\n                                   ,@BlessID\r\n                                   ,@Pic)", new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@OldTemplateId", (object) item.OldTemplateId),
          new SqlParameter("@NewTemplateId", (object) item.NewTemplateId),
          new SqlParameter("@CategoryID", (object) item.CategoryID),
          new SqlParameter("@Strengthen", (object) item.Strengthen),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Luck", (object) item.Luck),
          new SqlParameter("@Damage", (object) item.Damage),
          new SqlParameter("@Guard", (object) item.Guard),
          new SqlParameter("@Boold", (object) item.Boold),
          new SqlParameter("@BlessID", (object) item.BlessID),
          new SqlParameter("@Pic", (object) item.Pic)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddGoldEquipTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateGoldEquipTemplate(GoldEquipTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[GoldEquipTemplateLoad]\r\n                               SET [ID] = @ID\r\n                                  ,[OldTemplateId] = @OldTemplateId\r\n                                  ,[NewTemplateId] = @NewTemplateId\r\n                                  ,[CategoryID] = @CategoryID\r\n                                  ,[Strengthen] = @Strengthen\r\n                                  ,[Attack] = @Attack\r\n                                  ,[Defence] = @Defence\r\n                                  ,[Agility] = @Agility\r\n                                  ,[Luck] = @Luck\r\n                                  ,[Damage] = @Damage\r\n                                  ,[Guard] = @Guard\r\n                                  ,[Boold] = @Boold\r\n                                  ,[BlessID] = @BlessID\r\n                                  ,[Pic] = @Pic\r\n                            WHERE [ID] = @ID", new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@OldTemplateId", (object) item.OldTemplateId),
          new SqlParameter("@NewTemplateId", (object) item.NewTemplateId),
          new SqlParameter("@CategoryID", (object) item.CategoryID),
          new SqlParameter("@Strengthen", (object) item.Strengthen),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Luck", (object) item.Luck),
          new SqlParameter("@Damage", (object) item.Damage),
          new SqlParameter("@Guard", (object) item.Guard),
          new SqlParameter("@Boold", (object) item.Boold),
          new SqlParameter("@BlessID", (object) item.BlessID),
          new SqlParameter("@Pic", (object) item.Pic)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateGoldEquipTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteGoldEquipTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[GoldEquipTemplateLoad] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteGoldEquipTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllGoldEquipTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[GoldEquipTemplateLoad]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteGoldEquipTemplate: " + ex.ToString());
            }
            return flag;
        }

        public FusionInfo[] GetAllFusion()
        {
            List<FusionInfo> fusionInfoList = new List<FusionInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Item_Fusion]");
                while (Sdr.Read())
                    fusionInfoList.Add(this.InitFusionInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllFusion " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return fusionInfoList.ToArray();
        }

        public FusionInfo[] GetAllFusionBy(int id)
        {
            List<FusionInfo> fusionInfoList = new List<FusionInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Item_Fusion] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    fusionInfoList.Add(this.InitFusionInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllFusionBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return fusionInfoList.ToArray();
        }

        public FusionInfo GetSingleFusion(int id)
        {
            List<FusionInfo> fusionInfoList = new List<FusionInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Item_Fusion] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    fusionInfoList.Add(this.InitFusionInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleFusion " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return fusionInfoList.Count > 0 ? fusionInfoList[0] : (FusionInfo)null;
        }

        public FusionInfo InitFusionInfo(SqlDataReader reader) => new FusionInfo()
        {
            FusionID = (int)reader["FusionID"],
            Item1 = (int)reader["Item1"],
            Item2 = (int)reader["Item2"],
            Item3 = (int)reader["Item3"],
            Item4 = (int)reader["Item4"],
            Count1 = (int)reader["Count1"],
            Count2 = (int)reader["Count2"],
            Count3 = (int)reader["Count3"],
            Count4 = (int)reader["Count4"],
            Formula = (int)reader["Formula"],
            FusionRate = (int)reader["FusionRate"],
            FusionType = (int)reader["FusionType"],
            Reward = (int)reader["Reward"],
            NeedPower = (int)reader["NeedPower"]
        };

        public bool AddFusion(FusionInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Item_Fusion]\r\n                                   ([FusionID]\r\n                                   ,[Item1]\r\n                                   ,[Item2]\r\n                                   ,[Item3]\r\n                                   ,[Item4]\r\n                                   ,[Count1]\r\n                                   ,[Count2]\r\n                                   ,[Count3]\r\n                                   ,[Count4]\r\n                                   ,[Formula]\r\n                                   ,[FusionRate]\r\n                                   ,[FusionType]\r\n                                   ,[Reward]\r\n                                   ,[NeedPower])\r\n                               VALUES\r\n                                   (@FusionID\r\n                                   ,@Item1\r\n                                   ,@Item2\r\n                                   ,@Item3\r\n                                   ,@Item4\r\n                                   ,@Count1\r\n                                   ,@Count2\r\n                                   ,@Count3\r\n                                   ,@Count4\r\n                                   ,@Formula\r\n                                   ,@FusionRate\r\n                                   ,@FusionType\r\n                                   ,@Reward\r\n                                   ,@NeedPower)", new SqlParameter[14]
                {
          new SqlParameter("@FusionID", (object) item.FusionID),
          new SqlParameter("@Item1", (object) item.Item1),
          new SqlParameter("@Item2", (object) item.Item2),
          new SqlParameter("@Item3", (object) item.Item3),
          new SqlParameter("@Item4", (object) item.Item4),
          new SqlParameter("@Count1", (object) item.Count1),
          new SqlParameter("@Count2", (object) item.Count2),
          new SqlParameter("@Count3", (object) item.Count3),
          new SqlParameter("@Count4", (object) item.Count4),
          new SqlParameter("@Formula", (object) item.Formula),
          new SqlParameter("@FusionRate", (object) item.FusionRate),
          new SqlParameter("@FusionType", (object) item.FusionType),
          new SqlParameter("@Reward", (object) item.Reward),
          new SqlParameter("@NeedPower", (object) item.NeedPower)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddFusion: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateFusion(FusionInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Item_Fusion]\r\n                               SET [FusionID] = @FusionID\r\n                                  ,[Item1] = @Item1\r\n                                  ,[Item2] = @Item2\r\n                                  ,[Item3] = @Item3\r\n                                  ,[Item4] = @Item4\r\n                                  ,[Count1] = @Count1\r\n                                  ,[Count2] = @Count2\r\n                                  ,[Count3] = @Count3\r\n                                  ,[Count4] = @Count4\r\n                                  ,[Formula] = @Formula\r\n                                  ,[FusionRate] = @FusionRate\r\n                                  ,[FusionType] = @FusionType\r\n                                  ,[Reward] = @Reward\r\n                                  ,[NeedPower] = @NeedPower\r\n                            WHERE [ID] = @ID", new SqlParameter[14]
                {
          new SqlParameter("@FusionID", (object) item.FusionID),
          new SqlParameter("@Item1", (object) item.Item1),
          new SqlParameter("@Item2", (object) item.Item2),
          new SqlParameter("@Item3", (object) item.Item3),
          new SqlParameter("@Item4", (object) item.Item4),
          new SqlParameter("@Count1", (object) item.Count1),
          new SqlParameter("@Count2", (object) item.Count2),
          new SqlParameter("@Count3", (object) item.Count3),
          new SqlParameter("@Count4", (object) item.Count4),
          new SqlParameter("@Formula", (object) item.Formula),
          new SqlParameter("@FusionRate", (object) item.FusionRate),
          new SqlParameter("@FusionType", (object) item.FusionType),
          new SqlParameter("@Reward", (object) item.Reward),
          new SqlParameter("@NeedPower", (object) item.NeedPower)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateFusion: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteFusion(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Item_Fusion] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteFusion: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllFusion()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Item_Fusion]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteFusion: " + ex.ToString());
            }
            return flag;
        }

        public StrengthenGoodsInfo[] GetAllStrengthenGoods()
        {
            List<StrengthenGoodsInfo> strengthenGoodsInfoList = new List<StrengthenGoodsInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Item_Strengthen_Goods]");
                while (Sdr.Read())
                    strengthenGoodsInfoList.Add(this.InitStrengthenGoodsInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllStrengthenGoods " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return strengthenGoodsInfoList.ToArray();
        }

        public StrengthenGoodsInfo[] GetAllStrengthenGoodsBy(int id)
        {
            List<StrengthenGoodsInfo> strengthenGoodsInfoList = new List<StrengthenGoodsInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Item_Strengthen_Goods] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    strengthenGoodsInfoList.Add(this.InitStrengthenGoodsInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllStrengthenGoodsBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return strengthenGoodsInfoList.ToArray();
        }

        public StrengthenGoodsInfo GetSingleStrengthenGoods(int id)
        {
            List<StrengthenGoodsInfo> strengthenGoodsInfoList = new List<StrengthenGoodsInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Item_Strengthen_Goods] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    strengthenGoodsInfoList.Add(this.InitStrengthenGoodsInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleStrengthenGoods " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return strengthenGoodsInfoList.Count > 0 ? strengthenGoodsInfoList[0] : (StrengthenGoodsInfo)null;
        }

        public StrengthenGoodsInfo InitStrengthenGoodsInfo(SqlDataReader reader) => new StrengthenGoodsInfo()
        {
            ID = (int)reader["ID"],
            Level = (int)reader["Level"],
            CurrentEquip = (int)reader["CurrentEquip"],
            GainEquip = (int)reader["GainEquip"],
            OriginalEquip = (int)reader["OriginalEquip"]
        };

        public bool AddStrengthenGoods(StrengthenGoodsInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Item_Strengthen_Goods]\r\n                                   ([Level]\r\n                                   ,[CurrentEquip]\r\n                                   ,[GainEquip]\r\n                                   ,[OriginalEquip])\r\n                               VALUES\r\n                                   (@Level\r\n                                   ,@CurrentEquip\r\n                                   ,@GainEquip\r\n                                   ,@OriginalEquip)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          null,
          null,
          null,
          null
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Level", (object)item.Level);
                SqlParameters[2] = new SqlParameter("@CurrentEquip", (object)item.CurrentEquip);
                SqlParameters[3] = new SqlParameter("@GainEquip", (object)item.GainEquip);
                SqlParameters[4] = new SqlParameter("@OriginalEquip", (object)item.OriginalEquip);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddStrengthenGoods: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateStrengthenGoods(StrengthenGoodsInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Item_Strengthen_Goods]\r\n                               SET [Level] = @Level\r\n                                  ,[CurrentEquip] = @CurrentEquip\r\n                                  ,[GainEquip] = @GainEquip\r\n                                  ,[OriginalEquip] = @OriginalEquip\r\n                            WHERE [ID] = @ID", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@CurrentEquip", (object) item.CurrentEquip),
          new SqlParameter("@GainEquip", (object) item.GainEquip),
          new SqlParameter("@OriginalEquip", (object) item.OriginalEquip)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateStrengthenGoods: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteStrengthenGoods(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Item_Strengthen_Goods] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteStrengthenGoods: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllStrengthenGoods()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Item_Strengthen_Goods]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteStrengthenGoods: " + ex.ToString());
            }
            return flag;
        }

        public NpcInfo[] GetAllNpc()
        {
            List<NpcInfo> npcInfoList = new List<NpcInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[NPC_Info]");
                while (Sdr.Read())
                    npcInfoList.Add(this.InitNpcInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllNpc " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return npcInfoList.ToArray();
        }

        public NpcInfo[] GetAllNpcBy(int id)
        {
            List<NpcInfo> npcInfoList = new List<NpcInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[NPC_Info] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    npcInfoList.Add(this.InitNpcInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllNpcBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return npcInfoList.ToArray();
        }

        public NpcInfo GetSingleNpc(int id)
        {
            List<NpcInfo> npcInfoList = new List<NpcInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[NPC_Info] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    npcInfoList.Add(this.InitNpcInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleNpc " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return npcInfoList.Count > 0 ? npcInfoList[0] : (NpcInfo)null;
        }

        public NpcInfo InitNpcInfo(SqlDataReader reader) => new NpcInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Level = (int)reader["Level"],
            Camp = (int)reader["Camp"],
            Type = (int)reader["Type"],
            X = (int)reader["X"],
            Y = (int)reader["Y"],
            Width = (int)reader["Width"],
            Height = (int)reader["Height"],
            Blood = (int)reader["Blood"],
            MoveMin = (int)reader["MoveMin"],
            MoveMax = (int)reader["MoveMax"],
            BaseDamage = (int)reader["BaseDamage"],
            BaseGuard = (int)reader["BaseGuard"],
            Defence = (int)reader["Defence"],
            Agility = (int)reader["Agility"],
            Lucky = (int)reader["Lucky"],
            Attack = (int)reader["Attack"],
            ModelID = reader["ModelID"] == null ? "" : reader["ModelID"].ToString(),
            ResourcesPath = reader["ResourcesPath"] == null ? "" : reader["ResourcesPath"].ToString(),
            DropRate = reader["DropRate"] == null ? "" : reader["DropRate"].ToString(),
            Experience = (int)reader["Experience"],
            Delay = (int)reader["Delay"],
            Immunity = (int)reader["Immunity"],
            Alert = (int)reader["Alert"],
            Range = (int)reader["Range"],
            Preserve = (int)reader["Preserve"],
            Script = reader["Script"] == null ? "" : reader["Script"].ToString(),
            FireX = (int)reader["FireX"],
            FireY = (int)reader["FireY"],
            DropId = (int)reader["DropId"],
            CurrentBallId = (int)reader["CurrentBallId"],
            speed = (int)reader["speed"],
            MagicAttack = 0,
            MagicDefence = 0
        };

        public bool AddNpc(NpcInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[NPC_Info]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[Level]\r\n                                   ,[Camp]\r\n                                   ,[Type]\r\n                                   ,[X]\r\n                                   ,[Y]\r\n                                   ,[Width]\r\n                                   ,[Height]\r\n                                   ,[Blood]\r\n                                   ,[MoveMin]\r\n                                   ,[MoveMax]\r\n                                   ,[BaseDamage]\r\n                                   ,[BaseGuard]\r\n                                   ,[Defence]\r\n                                   ,[Agility]\r\n                                   ,[Lucky]\r\n                                   ,[Attack]\r\n                                   ,[ModelID]\r\n                                   ,[ResourcesPath]\r\n                                   ,[DropRate]\r\n                                   ,[Experience]\r\n                                   ,[Delay]\r\n                                   ,[Immunity]\r\n                                   ,[Alert]\r\n                                   ,[Range]\r\n                                   ,[Preserve]\r\n                                   ,[Script]\r\n                                   ,[FireX]\r\n                                   ,[FireY]\r\n                                   ,[DropId]\r\n                                   ,[CurrentBallId]\r\n                                   ,[speed])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@Level\r\n                                   ,@Camp\r\n                                   ,@Type\r\n                                   ,@X\r\n                                   ,@Y\r\n                                   ,@Width\r\n                                   ,@Height\r\n                                   ,@Blood\r\n                                   ,@MoveMin\r\n                                   ,@MoveMax\r\n                                   ,@BaseDamage\r\n                                   ,@BaseGuard\r\n                                   ,@Defence\r\n                                   ,@Agility\r\n                                   ,@Lucky\r\n                                   ,@Attack\r\n                                   ,@ModelID\r\n                                   ,@ResourcesPath\r\n                                   ,@DropRate\r\n                                   ,@Experience\r\n                                   ,@Delay\r\n                                   ,@Immunity\r\n                                   ,@Alert\r\n                                   ,@Range\r\n                                   ,@Preserve\r\n                                   ,@Script\r\n                                   ,@FireX\r\n                                   ,@FireY\r\n                                   ,@DropId\r\n                                   ,@CurrentBallId\r\n                                   ,@speed)", new SqlParameter[33]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Camp", (object) item.Camp),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@X", (object) item.X),
          new SqlParameter("@Y", (object) item.Y),
          new SqlParameter("@Width", (object) item.Width),
          new SqlParameter("@Height", (object) item.Height),
          new SqlParameter("@Blood", (object) item.Blood),
          new SqlParameter("@MoveMin", (object) item.MoveMin),
          new SqlParameter("@MoveMax", (object) item.MoveMax),
          new SqlParameter("@BaseDamage", (object) item.BaseDamage),
          new SqlParameter("@BaseGuard", (object) item.BaseGuard),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Lucky", (object) item.Lucky),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@ModelID", (object) item.ModelID),
          new SqlParameter("@ResourcesPath", (object) item.ResourcesPath),
          new SqlParameter("@DropRate", (object) item.DropRate),
          new SqlParameter("@Experience", (object) item.Experience),
          new SqlParameter("@Delay", (object) item.Delay),
          new SqlParameter("@Immunity", (object) item.Immunity),
          new SqlParameter("@Alert", (object) item.Alert),
          new SqlParameter("@Range", (object) item.Range),
          new SqlParameter("@Preserve", (object) item.Preserve),
          new SqlParameter("@Script", (object) item.Script),
          new SqlParameter("@FireX", (object) item.FireX),
          new SqlParameter("@FireY", (object) item.FireY),
          new SqlParameter("@DropId", (object) item.DropId),
          new SqlParameter("@CurrentBallId", (object) item.CurrentBallId),
          new SqlParameter("@speed", (object) item.speed)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddNpc: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateNpc(NpcInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[NPC_Info]\r\n                               SET [ID] = @ID\r\n                                  ,[Name] = @Name\r\n                                  ,[Level] = @Level\r\n                                  ,[Camp] = @Camp\r\n                                  ,[Type] = @Type\r\n                                  ,[X] = @X\r\n                                  ,[Y] = @Y\r\n                                  ,[Width] = @Width\r\n                                  ,[Height] = @Height\r\n                                  ,[Blood] = @Blood\r\n                                  ,[MoveMin] = @MoveMin\r\n                                  ,[MoveMax] = @MoveMax\r\n                                  ,[BaseDamage] = @BaseDamage\r\n                                  ,[BaseGuard] = @BaseGuard\r\n                                  ,[Defence] = @Defence\r\n                                  ,[Agility] = @Agility\r\n                                  ,[Lucky] = @Lucky\r\n                                  ,[Attack] = @Attack\r\n                                  ,[ModelID] = @ModelID\r\n                                  ,[ResourcesPath] = @ResourcesPath\r\n                                  ,[DropRate] = @DropRate\r\n                                  ,[Experience] = @Experience\r\n                                  ,[Delay] = @Delay\r\n                                  ,[Immunity] = @Immunity\r\n                                  ,[Alert] = @Alert\r\n                                  ,[Range] = @Range\r\n                                  ,[Preserve] = @Preserve\r\n                                  ,[Script] = @Script\r\n                                  ,[FireX] = @FireX\r\n                                  ,[FireY] = @FireY\r\n                                  ,[DropId] = @DropId\r\n                                  ,[CurrentBallId] = @CurrentBallId\r\n                                  ,[speed] = @speed\r\n                            WHERE [ID] = @ID", new SqlParameter[33]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Camp", (object) item.Camp),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@X", (object) item.X),
          new SqlParameter("@Y", (object) item.Y),
          new SqlParameter("@Width", (object) item.Width),
          new SqlParameter("@Height", (object) item.Height),
          new SqlParameter("@Blood", (object) item.Blood),
          new SqlParameter("@MoveMin", (object) item.MoveMin),
          new SqlParameter("@MoveMax", (object) item.MoveMax),
          new SqlParameter("@BaseDamage", (object) item.BaseDamage),
          new SqlParameter("@BaseGuard", (object) item.BaseGuard),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Lucky", (object) item.Lucky),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@ModelID", (object) item.ModelID),
          new SqlParameter("@ResourcesPath", (object) item.ResourcesPath),
          new SqlParameter("@DropRate", (object) item.DropRate),
          new SqlParameter("@Experience", (object) item.Experience),
          new SqlParameter("@Delay", (object) item.Delay),
          new SqlParameter("@Immunity", (object) item.Immunity),
          new SqlParameter("@Alert", (object) item.Alert),
          new SqlParameter("@Range", (object) item.Range),
          new SqlParameter("@Preserve", (object) item.Preserve),
          new SqlParameter("@Script", (object) item.Script),
          new SqlParameter("@FireX", (object) item.FireX),
          new SqlParameter("@FireY", (object) item.FireY),
          new SqlParameter("@DropId", (object) item.DropId),
          new SqlParameter("@CurrentBallId", (object) item.CurrentBallId),
          new SqlParameter("@speed", (object) item.speed)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateNpc: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteNpc(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[NPC_Info] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteNpc: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllNpc()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[NPC_Info]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteNpc: " + ex.ToString());
            }
            return flag;
        }

        public MountDrawTemplateInfo[] GetAllMountDrawTemplate()
        {
            List<MountDrawTemplateInfo> drawTemplateInfoList = new List<MountDrawTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_Draw_Template]");
                while (Sdr.Read())
                    drawTemplateInfoList.Add(this.InitMountDrawTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMountDrawTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return drawTemplateInfoList.ToArray();
        }

        public MountDrawTemplateInfo[] GetAllMountDrawTemplateBy(int id)
        {
            List<MountDrawTemplateInfo> drawTemplateInfoList = new List<MountDrawTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_Draw_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    drawTemplateInfoList.Add(this.InitMountDrawTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMountDrawTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return drawTemplateInfoList.ToArray();
        }

        public MountDrawTemplateInfo GetSingleMountDrawTemplate(int id)
        {
            List<MountDrawTemplateInfo> drawTemplateInfoList = new List<MountDrawTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mount_Draw_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    drawTemplateInfoList.Add(this.InitMountDrawTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleMountDrawTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return drawTemplateInfoList.Count > 0 ? drawTemplateInfoList[0] : (MountDrawTemplateInfo)null;
        }

        public MountDrawTemplateInfo InitMountDrawTemplateInfo(SqlDataReader reader) => new MountDrawTemplateInfo()
        {
            ID = (int)reader["ID"],
            TemplateId = (int)reader["TemplateId"],
            AddHurt = (int)reader["AddHurt"],
            AddGuard = (int)reader["AddGuard"],
            MagicAttack = (int)reader["MagicAttack"],
            MagicDefence = (int)reader["MagicDefence"],
            AddBlood = (int)reader["AddBlood"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString()
        };

        public bool AddMountDrawTemplate(MountDrawTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Mount_Draw_Template]\r\n                                   ([ID]\r\n                                   ,[TemplateId]\r\n                                   ,[AddHurt]\r\n                                   ,[AddGuard]\r\n                                   ,[MagicAttack]\r\n                                   ,[MagicDefence]\r\n                                   ,[AddBlood]\r\n                                   ,[Name])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@TemplateId\r\n                                   ,@AddHurt\r\n                                   ,@AddGuard\r\n                                   ,@MagicAttack\r\n                                   ,@MagicDefence\r\n                                   ,@AddBlood\r\n                                   ,@Name)", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@TemplateId", (object) item.TemplateId),
          new SqlParameter("@AddHurt", (object) item.AddHurt),
          new SqlParameter("@AddGuard", (object) item.AddGuard),
          new SqlParameter("@MagicAttack", (object) item.MagicAttack),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence),
          new SqlParameter("@AddBlood", (object) item.AddBlood),
          new SqlParameter("@Name", (object) item.Name)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddMountDrawTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateMountDrawTemplate(MountDrawTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Mount_Draw_Template]\r\n                               SET [ID] = @ID\r\n                                  ,[TemplateId] = @TemplateId\r\n                                  ,[AddHurt] = @AddHurt\r\n                                  ,[AddGuard] = @AddGuard\r\n                                  ,[MagicAttack] = @MagicAttack\r\n                                  ,[MagicDefence] = @MagicDefence\r\n                                  ,[AddBlood] = @AddBlood\r\n                                  ,[Name] = @Name\r\n                            WHERE [ID] = @ID", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@TemplateId", (object) item.TemplateId),
          new SqlParameter("@AddHurt", (object) item.AddHurt),
          new SqlParameter("@AddGuard", (object) item.AddGuard),
          new SqlParameter("@MagicAttack", (object) item.MagicAttack),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence),
          new SqlParameter("@AddBlood", (object) item.AddBlood),
          new SqlParameter("@Name", (object) item.Name)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateMountDrawTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteMountDrawTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Mount_Draw_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMountDrawTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllMountDrawTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Mount_Draw_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteMountDrawTemplate: " + ex.ToString());
            }
            return flag;
        }

        public ClothGroupTemplateInfo[] GetAllClothGroupTemplate()
        {
            List<ClothGroupTemplateInfo> groupTemplateInfoList = new List<ClothGroupTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Cloth_Group_Template]");
                while (Sdr.Read())
                    groupTemplateInfoList.Add(this.InitClothGroupTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllClothGroupTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return groupTemplateInfoList.ToArray();
        }

        public ClothGroupTemplateInfo[] GetAllClothGroupTemplateBy(int id)
        {
            List<ClothGroupTemplateInfo> groupTemplateInfoList = new List<ClothGroupTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Cloth_Group_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    groupTemplateInfoList.Add(this.InitClothGroupTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllClothGroupTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return groupTemplateInfoList.ToArray();
        }

        public ClothGroupTemplateInfo GetSingleClothGroupTemplate(int id)
        {
            List<ClothGroupTemplateInfo> groupTemplateInfoList = new List<ClothGroupTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Cloth_Group_Template] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    groupTemplateInfoList.Add(this.InitClothGroupTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleClothGroupTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return groupTemplateInfoList.Count > 0 ? groupTemplateInfoList[0] : (ClothGroupTemplateInfo)null;
        }

        public ClothGroupTemplateInfo InitClothGroupTemplateInfo(
          SqlDataReader reader)
        {
            return new ClothGroupTemplateInfo()
            {
                ID = (int)reader["ID"],
                TemplateID = (int)reader["TemplateID"],
                Sex = (int)reader["Sex"],
                Description = (int)reader["Description"],
                Cost = (int)reader["Cost"]
            };
        }

        public bool AddClothGroupTemplate(ClothGroupTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Cloth_Group_Template]\r\n                                   ([ID]\r\n                                   ,[TemplateID]\r\n                                   ,[Sex]\r\n                                   ,[Description]\r\n                                   ,[Cost])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@TemplateID\r\n                                   ,@Sex\r\n                                   ,@Description\r\n                                   ,@Cost)", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Sex", (object) item.Sex),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Cost", (object) item.Cost)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddClothGroupTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateClothGroupTemplate(ClothGroupTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Cloth_Group_Template]\r\n                               SET [ID] = @ID\r\n                                  ,[TemplateID] = @TemplateID\r\n                                  ,[Sex] = @Sex\r\n                                  ,[Description] = @Description\r\n                                  ,[Cost] = @Cost\r\n                            WHERE [ID] = @ID", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Sex", (object) item.Sex),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Cost", (object) item.Cost)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateClothGroupTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteClothGroupTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Cloth_Group_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteClothGroupTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllClothGroupTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Cloth_Group_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteClothGroupTemplate: " + ex.ToString());
            }
            return flag;
        }

        public BallInfo[] GetAllBall()
        {
            List<BallInfo> ballInfoList = new List<BallInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Ball]");
                while (Sdr.Read())
                    ballInfoList.Add(this.InitBallInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllBall " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return ballInfoList.ToArray();
        }

        public BallInfo GetSingleBall(int id)
        {
            List<BallInfo> ballInfoList = new List<BallInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Ball] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    ballInfoList.Add(this.InitBallInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleBall " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return ballInfoList.Count > 0 ? ballInfoList[0] : (BallInfo)null;
        }

        public BallInfo InitBallInfo(SqlDataReader reader) => new BallInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Power = (double)reader["Power"],
            Radii = (int)reader["Radii"],
            FlyingPartical = reader["FlyingPartical"] == null ? "" : reader["FlyingPartical"].ToString(),
            BombPartical = reader["BombPartical"] == null ? "" : reader["BombPartical"].ToString(),
            Crater = reader["Crater"] == null ? "" : reader["Crater"].ToString(),
            AttackResponse = (int)reader["AttackResponse"],
            IsSpin = (bool)reader["IsSpin"],
            Mass = (int)reader["Mass"],
            SpinVA = (double)reader["SpinVA"],
            SpinV = (int)reader["SpinV"],
            Amount = (int)reader["Amount"],
            Wind = (int)reader["Wind"],
            DragIndex = (int)reader["DragIndex"],
            Weight = (int)reader["Weight"],
            Shake = (bool)reader["Shake"],
            ShootSound = reader["ShootSound"] == null ? "" : reader["ShootSound"].ToString(),
            BombSound = reader["BombSound"] == null ? "" : reader["BombSound"].ToString(),
            Delay = (int)reader["Delay"],
            ActionType = (int)reader["ActionType"],
            HasTunnel = (bool)reader["HasTunnel"]
        };

        public bool AddBall(BallInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Ball]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[Power]\r\n                                   ,[Radii]\r\n                                   ,[FlyingPartical]\r\n                                   ,[BombPartical]\r\n                                   ,[Crater]\r\n                                   ,[AttackResponse]\r\n                                   ,[IsSpin]\r\n                                   ,[Mass]\r\n                                   ,[SpinVA]\r\n                                   ,[SpinV]\r\n                                   ,[Amount]\r\n                                   ,[Wind]\r\n                                   ,[DragIndex]\r\n                                   ,[Weight]\r\n                                   ,[Shake]\r\n                                   ,[ShootSound]\r\n                                   ,[BombSound]\r\n                                   ,[Delay]\r\n                                   ,[ActionType]\r\n                                   ,[HasTunnel])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@Power\r\n                                   ,@Radii\r\n                                   ,@FlyingPartical\r\n                                   ,@BombPartical\r\n                                   ,@Crater\r\n                                   ,@AttackResponse\r\n                                   ,@IsSpin\r\n                                   ,@Mass\r\n                                   ,@SpinVA\r\n                                   ,@SpinV\r\n                                   ,@Amount\r\n                                   ,@Wind\r\n                                   ,@DragIndex\r\n                                   ,@Weight\r\n                                   ,@Shake\r\n                                   ,@ShootSound\r\n                                   ,@BombSound\r\n                                   ,@Delay\r\n                                   ,@ActionType\r\n                                   ,@HasTunnel)", new SqlParameter[22]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Power", (object) item.Power),
          new SqlParameter("@Radii", (object) item.Radii),
          new SqlParameter("@FlyingPartical", (object) item.FlyingPartical),
          new SqlParameter("@BombPartical", (object) item.BombPartical),
          new SqlParameter("@Crater", (object) item.Crater),
          new SqlParameter("@AttackResponse", (object) item.AttackResponse),
          new SqlParameter("@IsSpin", (object) item.IsSpin),
          new SqlParameter("@Mass", (object) item.Mass),
          new SqlParameter("@SpinVA", (object) item.SpinVA),
          new SqlParameter("@SpinV", (object) item.SpinV),
          new SqlParameter("@Amount", (object) item.Amount),
          new SqlParameter("@Wind", (object) item.Wind),
          new SqlParameter("@DragIndex", (object) item.DragIndex),
          new SqlParameter("@Weight", (object) item.Weight),
          new SqlParameter("@Shake", (object) item.Shake),
          new SqlParameter("@ShootSound", (object) item.ShootSound),
          new SqlParameter("@BombSound", (object) item.BombSound),
          new SqlParameter("@Delay", (object) item.Delay),
          new SqlParameter("@ActionType", (object) item.ActionType),
          new SqlParameter("@HasTunnel", (object) item.HasTunnel)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddBall: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateBall(BallInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Ball]\r\n                               SET [Name] = @Name\r\n                                  ,[Power] = @Power\r\n                                  ,[Radii] = @Radii\r\n                                  ,[FlyingPartical] = @FlyingPartical\r\n                                  ,[BombPartical] = @BombPartical\r\n                                  ,[Crater] = @Crater\r\n                                  ,[AttackResponse] = @AttackResponse\r\n                                  ,[IsSpin] = @IsSpin\r\n                                  ,[Mass] = @Mass\r\n                                  ,[SpinVA] = @SpinVA\r\n                                  ,[SpinV] = @SpinV\r\n                                  ,[Amount] = @Amount\r\n                                  ,[Wind] = @Wind\r\n                                  ,[DragIndex] = @DragIndex\r\n                                  ,[Weight] = @Weight\r\n                                  ,[Shake] = @Shake\r\n                                  ,[ShootSound] = @ShootSound\r\n                                  ,[BombSound] = @BombSound\r\n                                  ,[Delay] = @Delay\r\n                                  ,[ActionType] = @ActionType\r\n                                  ,[HasTunnel] = @HasTunnel\r\n                            WHERE [ID] = @ID", new SqlParameter[22]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Power", (object) item.Power),
          new SqlParameter("@Radii", (object) item.Radii),
          new SqlParameter("@FlyingPartical", (object) item.FlyingPartical),
          new SqlParameter("@BombPartical", (object) item.BombPartical),
          new SqlParameter("@Crater", (object) item.Crater),
          new SqlParameter("@AttackResponse", (object) item.AttackResponse),
          new SqlParameter("@IsSpin", (object) item.IsSpin),
          new SqlParameter("@Mass", (object) item.Mass),
          new SqlParameter("@SpinVA", (object) item.SpinVA),
          new SqlParameter("@SpinV", (object) item.SpinV),
          new SqlParameter("@Amount", (object) item.Amount),
          new SqlParameter("@Wind", (object) item.Wind),
          new SqlParameter("@DragIndex", (object) item.DragIndex),
          new SqlParameter("@Weight", (object) item.Weight),
          new SqlParameter("@Shake", (object) item.Shake),
          new SqlParameter("@ShootSound", (object) item.ShootSound),
          new SqlParameter("@BombSound", (object) item.BombSound),
          new SqlParameter("@Delay", (object) item.Delay),
          new SqlParameter("@ActionType", (object) item.ActionType),
          new SqlParameter("@HasTunnel", (object) item.HasTunnel)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateBall: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteBall(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Ball] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteBall: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllBall()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Ball]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteBall: " + ex.ToString());
            }
            return flag;
        }

        public TreeTemplateInfo[] GetAllTreeTemplate()
        {
            List<TreeTemplateInfo> treeTemplateInfoList = new List<TreeTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Tree_Template]");
                while (Sdr.Read())
                    treeTemplateInfoList.Add(this.InitTreeTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllTreeTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return treeTemplateInfoList.ToArray();
        }

        public TreeTemplateInfo InitTreeTemplateInfo(SqlDataReader reader) => new TreeTemplateInfo()
        {
            Level = (int)reader["Level"],
            AwardID = (int)reader["AwardID"],
            CostExp = (int)reader["CostExp"],
            MonsterExp = (int)reader["MonsterExp"],
            MonsterID = (int)reader["MonsterID"],
            MonsterName = reader["MonsterName"] == null ? "" : reader["MonsterName"].ToString(),
            Exp = (int)reader["Exp"]
        };

        public bool AddTreeTemplate(TreeTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Tree_Template]\r\n                                   ([Level]\r\n                                   ,[AwardID]\r\n                                   ,[CostExp]\r\n                                   ,[MonsterExp]\r\n                                   ,[MonsterID]\r\n                                   ,[MonsterName]\r\n                                   ,[Exp])\r\n                               VALUES\r\n                                   (@Level\r\n                                   ,@AwardID\r\n                                   ,@CostExp\r\n                                   ,@MonsterExp\r\n                                   ,@MonsterID\r\n                                   ,@MonsterName\r\n                                   ,@Exp)", new SqlParameter[7]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@AwardID", (object) item.AwardID),
          new SqlParameter("@CostExp", (object) item.CostExp),
          new SqlParameter("@MonsterExp", (object) item.MonsterExp),
          new SqlParameter("@MonsterID", (object) item.MonsterID),
          new SqlParameter("@MonsterName", (object) item.MonsterName),
          new SqlParameter("@Exp", (object) item.Exp)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddTreeTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateTreeTemplate(TreeTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Tree_Template]\r\n                               SET [Level] = @Level\r\n                                  ,[AwardID] = @AwardID\r\n                                  ,[CostExp] = @CostExp\r\n                                  ,[MonsterExp] = @MonsterExp\r\n                                  ,[MonsterID] = @MonsterID\r\n                                  ,[MonsterName] = @MonsterName\r\n                                  ,[Exp] = @Exp\r\n                            WHERE [ID] = @ID", new SqlParameter[7]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@AwardID", (object) item.AwardID),
          new SqlParameter("@CostExp", (object) item.CostExp),
          new SqlParameter("@MonsterExp", (object) item.MonsterExp),
          new SqlParameter("@MonsterID", (object) item.MonsterID),
          new SqlParameter("@MonsterName", (object) item.MonsterName),
          new SqlParameter("@Exp", (object) item.Exp)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateTreeTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteTreeTemplate(int level)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Tree_Template] WHERE [Level] = @Level", new SqlParameter[1]
                {
          new SqlParameter("@Level", (object) level)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteTreeTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllTreeTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Tree_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteTreeTemplate: " + ex.ToString());
            }
            return flag;
        }

        public GuardCoreTemplateInfo[] GetAllGuardCoreTemplate()
        {
            List<GuardCoreTemplateInfo> coreTemplateInfoList = new List<GuardCoreTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Guard_Core_Template]");
                while (Sdr.Read())
                    coreTemplateInfoList.Add(this.InitGuardCoreTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllGuardCoreTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return coreTemplateInfoList.ToArray();
        }

        public GuardCoreTemplateInfo InitGuardCoreTemplateInfo(SqlDataReader reader) => new GuardCoreTemplateInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
            TipsDescription = reader["TipsDescription"] == null ? "" : reader["TipsDescription"].ToString(),
            Type = (int)reader["Type"],
            GainGrade = (int)reader["GainGrade"],
            Parameter1 = (int)reader["Parameter1"],
            Parameter2 = (int)reader["Parameter2"],
            Parameter3 = (int)reader["Parameter3"],
            Parameter4 = (int)reader["Parameter4"],
            KeepTurn = (int)reader["KeepTurn"],
            GroupType = (int)reader["GroupType"],
            GuardGrade = (int)reader["GuardGrade"],
            SkillGrade = (int)reader["SkillGrade"]
        };

        public bool AddGuardCoreTemplate(GuardCoreTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Guard_Core_Template]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[Description]\r\n                                   ,[TipsDescription]\r\n                                   ,[Type]\r\n                                   ,[GainGrade]\r\n                                   ,[Parameter1]\r\n                                   ,[Parameter2]\r\n                                   ,[Parameter3]\r\n                                   ,[Parameter4]\r\n                                   ,[KeepTurn]\r\n                                   ,[GroupType]\r\n                                   ,[GuardGrade]\r\n                                   ,[SkillGrade])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@Description\r\n                                   ,@TipsDescription\r\n                                   ,@Type\r\n                                   ,@GainGrade\r\n                                   ,@Parameter1\r\n                                   ,@Parameter2\r\n                                   ,@Parameter3\r\n                                   ,@Parameter4\r\n                                   ,@KeepTurn\r\n                                   ,@GroupType\r\n                                   ,@GuardGrade\r\n                                   ,@SkillGrade)", new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@TipsDescription", (object) item.TipsDescription),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@GainGrade", (object) item.GainGrade),
          new SqlParameter("@Parameter1", (object) item.Parameter1),
          new SqlParameter("@Parameter2", (object) item.Parameter2),
          new SqlParameter("@Parameter3", (object) item.Parameter3),
          new SqlParameter("@Parameter4", (object) item.Parameter4),
          new SqlParameter("@KeepTurn", (object) item.KeepTurn),
          new SqlParameter("@GroupType", (object) item.GroupType),
          new SqlParameter("@GuardGrade", (object) item.GuardGrade),
          new SqlParameter("@SkillGrade", (object) item.SkillGrade)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddGuardCoreTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateGuardCoreTemplate(GuardCoreTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Guard_Core_Template]\r\n                               SET [Name] = @Name\r\n                                  ,[Description] = @Description\r\n                                  ,[TipsDescription] = @TipsDescription\r\n                                  ,[Type] = @Type\r\n                                  ,[GainGrade] = @GainGrade\r\n                                  ,[Parameter1] = @Parameter1\r\n                                  ,[Parameter2] = @Parameter2\r\n                                  ,[Parameter3] = @Parameter3\r\n                                  ,[Parameter4] = @Parameter4\r\n                                  ,[KeepTurn] = @KeepTurn\r\n                                  ,[GroupType] = @GroupType\r\n                                  ,[GuardGrade] = @GuardGrade\r\n                                  ,[SkillGrade] = @SkillGrade\r\n                            WHERE [ID] = @ID", new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@TipsDescription", (object) item.TipsDescription),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@GainGrade", (object) item.GainGrade),
          new SqlParameter("@Parameter1", (object) item.Parameter1),
          new SqlParameter("@Parameter2", (object) item.Parameter2),
          new SqlParameter("@Parameter3", (object) item.Parameter3),
          new SqlParameter("@Parameter4", (object) item.Parameter4),
          new SqlParameter("@KeepTurn", (object) item.KeepTurn),
          new SqlParameter("@GroupType", (object) item.GroupType),
          new SqlParameter("@GuardGrade", (object) item.GuardGrade),
          new SqlParameter("@SkillGrade", (object) item.SkillGrade)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateGuardCoreTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteGuardCoreTemplate(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Guard_Core_Template] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteGuardCoreTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllGuardCoreTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Guard_Core_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteGuardCoreTemplate: " + ex.ToString());
            }
            return flag;
        }

        public GuardCoreLevelTemplateInfo[] GetAllGuardCoreLevelTemplate()
        {
            List<GuardCoreLevelTemplateInfo> levelTemplateInfoList = new List<GuardCoreLevelTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Guard_Core_Level_Template]");
                while (Sdr.Read())
                    levelTemplateInfoList.Add(this.InitGuardCoreLevelTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllGuardCoreLevelTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return levelTemplateInfoList.ToArray();
        }

        public GuardCoreLevelTemplateInfo InitGuardCoreLevelTemplateInfo(
          SqlDataReader reader)
        {
            return new GuardCoreLevelTemplateInfo()
            {
                Grade = (int)reader["Grade"],
                Exp = (int)reader["Exp"],
                Gold = (int)reader["Gold"],
                Guard = (int)reader["Guard"]
            };
        }

        public bool AddGuardCoreLevelTemplate(GuardCoreLevelTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Guard_Core_Level_Template]\r\n                                   ([Grade]\r\n                                   ,[Exp]\r\n                                   ,[Gold]\r\n                                   ,[Guard])\r\n                               VALUES\r\n                                   (@Grade\r\n                                   ,@Exp\r\n                                   ,@Gold\r\n                                   ,@Guard)", new SqlParameter[4]
                {
          new SqlParameter("@Grade", (object) item.Grade),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@Gold", (object) item.Gold),
          new SqlParameter("@Guard", (object) item.Guard)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddGuardCoreLevelTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateGuardCoreLevelTemplate(GuardCoreLevelTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Guard_Core_Level_Template]\r\n                               SET [Grade] = @Grade\r\n                                  ,[Exp] = @Exp\r\n                                  ,[Gold] = @Gold\r\n                                  ,[Guard] = @Guard\r\n                            WHERE [Grade] = @Grade", new SqlParameter[4]
                {
          new SqlParameter("@Grade", (object) item.Grade),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@Gold", (object) item.Gold),
          new SqlParameter("@Guard", (object) item.Guard)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateGuardCoreLevelTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteGuardCoreLevelTemplate(int grade)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Guard_Core_Level_Template] WHERE [Grade] = @Grade", new SqlParameter[1]
                {
          new SqlParameter("@Grade", (object) grade)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteGuardCoreLevelTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllGuardCoreLevelTemplate()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Guard_Core_Level_Template]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteGuardCoreLevelTemplate: " + ex.ToString());
            }
            return flag;
        }

        public HomeTempPracticeInfo[] GetAllHomeTempPractice()
        {
            List<HomeTempPracticeInfo> tempPracticeInfoList = new List<HomeTempPracticeInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[HomeTempPractice]");
                while (Sdr.Read())
                    tempPracticeInfoList.Add(this.InitHomeTempPracticeInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllHomeTempPractice " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return tempPracticeInfoList.ToArray();
        }

        public HomeTempPracticeInfo InitHomeTempPracticeInfo(SqlDataReader reader) => new HomeTempPracticeInfo()
        {
            Level = (int)reader["Level"],
            Exp = (int)reader["Exp"],
            Attack = (int)reader["Attack"],
            Defence = (int)reader["Defence"],
            Guard = (int)reader["Guard"],
            Luck = (int)reader["Luck"],
            Blood = (int)reader["Blood"],
            MagicDefence = (int)reader["MagicDefence"]
        };

        public bool AddHomeTempPractice(HomeTempPracticeInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Home_Temp_Practice]\r\n                                   ([Level]\r\n                                   ,[Exp]\r\n                                   ,[Attack]\r\n                                   ,[Defence]\r\n                                   ,[Guard]\r\n                                   ,[Luck]\r\n                                   ,[Blood]\r\n                                   ,[MagicDefence])\r\n                               VALUES\r\n                                   (@Level\r\n                                   ,@Exp\r\n                                   ,@Attack\r\n                                   ,@Defence\r\n                                   ,@Guard\r\n                                   ,@Luck\r\n                                   ,@Blood\r\n                                   ,@MagicDefence)", new SqlParameter[8]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Guard", (object) item.Guard),
          new SqlParameter("@Luck", (object) item.Luck),
          new SqlParameter("@Blood", (object) item.Blood),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddHomeTempPractice: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateHomeTempPractice(HomeTempPracticeInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Home_Temp_Practice]\r\n                               SET [Level] = @Level\r\n                                  ,[Exp] = @Exp\r\n                                  ,[Attack] = @Attack\r\n                                  ,[Defence] = @Defence\r\n                                  ,[Guard] = @Guard\r\n                                  ,[Luck] = @Luck\r\n                                  ,[Blood] = @Blood\r\n                                  ,[MagicDefence] = @MagicDefence\r\n                            WHERE [Level] = @Level", new SqlParameter[8]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Guard", (object) item.Guard),
          new SqlParameter("@Luck", (object) item.Luck),
          new SqlParameter("@Blood", (object) item.Blood),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateHomeTempPractice: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteHomeTempPractice(int level)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Home_Temp_Practice] WHERE [Level] = @Level", new SqlParameter[1]
                {
          new SqlParameter("@Level", (object) level)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteHomeTempPractice: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllHomeTempPractice()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Home_Temp_Practice]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteHomeTempPractice: " + ex.ToString());
            }
            return flag;
        }

        public LoveLevelInfo[] GetAllLoveLevel()
        {
            List<LoveLevelInfo> loveLevelInfoList = new List<LoveLevelInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Love_level]");
                while (Sdr.Read())
                    loveLevelInfoList.Add(this.InitLoveLevelInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllLoveLevel " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return loveLevelInfoList.ToArray();
        }

        public LoveLevelInfo GetSingleLoveLevel(int level)
        {
            List<LoveLevelInfo> loveLevelInfoList = new List<LoveLevelInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Love_level] WHERE Level = " + level.ToString());
                while (Sdr.Read())
                    loveLevelInfoList.Add(this.InitLoveLevelInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleLoveLevel " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return loveLevelInfoList.Count > 0 ? loveLevelInfoList[0] : (LoveLevelInfo)null;
        }

        public LoveLevelInfo InitLoveLevelInfo(SqlDataReader reader) => new LoveLevelInfo()
        {
            Level = (int)reader["Level"],
            Exp = (int)reader["Exp"],
            Animation = (int)reader["Animation"],
            SkillID = (int)reader["SkillID"],
            Attack = (int)reader["Attack"],
            Defence = (int)reader["Defence"],
            Agility = (int)reader["Agility"],
            Luck = (int)reader["Luck"]
        };

        public bool AddLoveLevel(LoveLevelInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Love_level]\r\n                                   ([Level]\r\n                                   ,[Exp]\r\n                                   ,[Animation]\r\n                                   ,[SkillID]\r\n                                   ,[Attack]\r\n                                   ,[Defence]\r\n                                   ,[Agility]\r\n                                   ,[Luck])\r\n                               VALUES\r\n                                   (@Level\r\n                                   ,@Exp\r\n                                   ,@Animation\r\n                                   ,@SkillID\r\n                                   ,@Attack\r\n                                   ,@Defence\r\n                                   ,@Agility\r\n                                   ,@Luck)", new SqlParameter[8]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@Animation", (object) item.Animation),
          new SqlParameter("@SkillID", (object) item.SkillID),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Luck", (object) item.Luck)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddLoveLevel: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateLoveLevel(LoveLevelInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Love_level]\r\n                               SET [Exp] = @Exp\r\n                                  ,[Animation] = @Animation\r\n                                  ,[SkillID] = @SkillID\r\n                                  ,[Attack] = @Attack\r\n                                  ,[Defence] = @Defence\r\n                                  ,[Agility] = @Agility\r\n                                  ,[Luck] = @Luck\r\n                            WHERE [Level] = @Level", new SqlParameter[8]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@Animation", (object) item.Animation),
          new SqlParameter("@SkillID", (object) item.SkillID),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Luck", (object) item.Luck)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateLoveLevel: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteLoveLevel(int level)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Love_level] WHERE [Level] = @Level", new SqlParameter[1]
                {
          new SqlParameter("@Level", (object) level)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteLoveLevel: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllLoveLevel()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Love_level]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteLoveLevel: " + ex.ToString());
            }
            return flag;
        }

        public SetsBuildTempInfo[] GetAllSetsBuildTemp()
        {
            List<SetsBuildTempInfo> setsBuildTempInfoList = new List<SetsBuildTempInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Sets_Build_Temp]");
                while (Sdr.Read())
                    setsBuildTempInfoList.Add(this.InitSetsBuildTempInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllSetsBuildTemp " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return setsBuildTempInfoList.ToArray();
        }

        public SetsBuildTempInfo GetSingleSetsBuildTemp(int id)
        {
            List<SetsBuildTempInfo> setsBuildTempInfoList = new List<SetsBuildTempInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Sets_Build_Temp] WHERE Level = " + id.ToString());
                while (Sdr.Read())
                    setsBuildTempInfoList.Add(this.InitSetsBuildTempInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleSetsBuildTemp " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return setsBuildTempInfoList.Count > 0 ? setsBuildTempInfoList[0] : (SetsBuildTempInfo)null;
        }

        public SetsBuildTempInfo InitSetsBuildTempInfo(SqlDataReader reader) => new SetsBuildTempInfo()
        {
            Level = (int)reader["Level"],
            SetsType = (int)reader["SetsType"],
            UseItemTemplate = (int)reader["UseItemTemplate"],
            Exp = (int)reader["Exp"],
            DefenceGrow = (int)reader["DefenceGrow"],
            BloodGrow = (int)reader["BloodGrow"],
            LuckGrow = (int)reader["LuckGrow"],
            AgilityGrow = (int)reader["AgilityGrow"],
            MagicDefenceGrow = (int)reader["MagicDefenceGrow"],
            GuardGrow = (int)reader["GuardGrow"]
        };

        public bool AddSetsBuildTemp(SetsBuildTempInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Sets_Build_Temp]\r\n                                   ([Level]\r\n                                   ,[SetsType]\r\n                                   ,[UseItemTemplate]\r\n                                   ,[Exp]\r\n                                   ,[DefenceGrow]\r\n                                   ,[BloodGrow]\r\n                                   ,[LuckGrow]\r\n                                   ,[AgilityGrow]\r\n                                   ,[MagicDefenceGrow]\r\n                                   ,[GuardGrow])\r\n                               VALUES\r\n                                   (@Level\r\n                                   ,@SetsType\r\n                                   ,@UseItemTemplate\r\n                                   ,@Exp\r\n                                   ,@DefenceGrow\r\n                                   ,@BloodGrow\r\n                                   ,@LuckGrow\r\n                                   ,@AgilityGrow\r\n                                   ,@MagicDefenceGrow\r\n                                   ,@GuardGrow)", new SqlParameter[10]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@SetsType", (object) item.SetsType),
          new SqlParameter("@UseItemTemplate", (object) item.UseItemTemplate),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@DefenceGrow", (object) item.DefenceGrow),
          new SqlParameter("@BloodGrow", (object) item.BloodGrow),
          new SqlParameter("@LuckGrow", (object) item.LuckGrow),
          new SqlParameter("@AgilityGrow", (object) item.AgilityGrow),
          new SqlParameter("@MagicDefenceGrow", (object) item.MagicDefenceGrow),
          new SqlParameter("@GuardGrow", (object) item.GuardGrow)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddSetsBuildTemp: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateSetsBuildTemp(SetsBuildTempInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Sets_Build_Temp]\r\n                               SET [Level] = @Level\r\n                                  ,[SetsType] = @SetsType\r\n                                  ,[UseItemTemplate] = @UseItemTemplate\r\n                                  ,[Exp] = @Exp\r\n                                  ,[DefenceGrow] = @DefenceGrow\r\n                                  ,[BloodGrow] = @BloodGrow\r\n                                  ,[LuckGrow] = @LuckGrow\r\n                                  ,[AgilityGrow] = @AgilityGrow\r\n                                  ,[MagicDefenceGrow] = @MagicDefenceGrow\r\n                                  ,[GuardGrow] = @GuardGrow\r\n                            WHERE [Level] = @Level", new SqlParameter[10]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@SetsType", (object) item.SetsType),
          new SqlParameter("@UseItemTemplate", (object) item.UseItemTemplate),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@DefenceGrow", (object) item.DefenceGrow),
          new SqlParameter("@BloodGrow", (object) item.BloodGrow),
          new SqlParameter("@LuckGrow", (object) item.LuckGrow),
          new SqlParameter("@AgilityGrow", (object) item.AgilityGrow),
          new SqlParameter("@MagicDefenceGrow", (object) item.MagicDefenceGrow),
          new SqlParameter("@GuardGrow", (object) item.GuardGrow)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateSetsBuildTemp: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteSetsBuildTemp(int level)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Sets_Build_Temp] WHERE [Level] = @Level", new SqlParameter[1]
                {
          new SqlParameter("@Level", (object) level)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteSetsBuildTemp: " + ex.ToString());
            }
            return flag;
        }

        public VipStoreInfo[] GetAllVipStore()
        {
            List<VipStoreInfo> vipStoreInfoList = new List<VipStoreInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Vip_Store]");
                while (Sdr.Read())
                    vipStoreInfoList.Add(this.InitVipStoreInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllVipStore " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return vipStoreInfoList.ToArray();
        }

        public VipStoreInfo GetSingleVipStore(int id)
        {
            List<VipStoreInfo> vipStoreInfoList = new List<VipStoreInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Vip_Store] WHERE [ID] = " + id.ToString());
                while (Sdr.Read())
                    vipStoreInfoList.Add(this.InitVipStoreInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleVipStore " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return vipStoreInfoList.Count > 0 ? vipStoreInfoList[0] : (VipStoreInfo)null;
        }

        public VipStoreInfo InitVipStoreInfo(SqlDataReader reader) => new VipStoreInfo()
        {
            ID = (int)reader["ID"],
            Type = (int)reader["Type"],
            GoodsID = (int)reader["GoodsID"],
            Discount = (int)reader["Discount"],
            Price = (int)reader["Price"],
            ValidDate = (int)reader["ValidDate"],
            Vip1Quantity = (int)reader["Vip1Quantity"],
            Vip2Quantity = (int)reader["Vip2Quantity"],
            Vip3Quantity = (int)reader["Vip3Quantity"],
            Vip4Quantity = (int)reader["Vip4Quantity"],
            Vip5Quantity = (int)reader["Vip5Quantity"],
            Vip6Quantity = (int)reader["Vip6Quantity"],
            Vip7Quantity = (int)reader["Vip7Quantity"],
            Vip8Quantity = (int)reader["Vip8Quantity"],
            Vip9Quantity = (int)reader["Vip9Quantity"],
            Vip10Quantity = (int)reader["Vip10Quantity"],
            Vip11Quantity = (int)reader["Vip11Quantity"],
            Vip12Quantity = (int)reader["Vip12Quantity"]
        };

        public bool AddVipStore(VipStoreInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Vip_Store]\r\n                                   ([ID]\r\n                                   ,[Type]\r\n                                   ,[GoodsID]\r\n                                   ,[Discount]\r\n                                   ,[Price]\r\n                                   ,[ValidDate]\r\n                                   ,[Vip1Quantity]\r\n                                   ,[Vip2Quantity]\r\n                                   ,[Vip3Quantity]\r\n                                   ,[Vip4Quantity]\r\n                                   ,[Vip5Quantity]\r\n                                   ,[Vip6Quantity]\r\n                                   ,[Vip7Quantity]\r\n                                   ,[Vip8Quantity]\r\n                                   ,[Vip9Quantity]\r\n                                   ,[Vip10Quantity]\r\n                                   ,[Vip11Quantity]\r\n                                   ,[Vip12Quantity])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Type\r\n                                   ,@GoodsID\r\n                                   ,@Discount\r\n                                   ,@Price\r\n                                   ,@ValidDate\r\n                                   ,@Vip1Quantity\r\n                                   ,@Vip2Quantity\r\n                                   ,@Vip3Quantity\r\n                                   ,@Vip4Quantity\r\n                                   ,@Vip5Quantity\r\n                                   ,@Vip6Quantity\r\n                                   ,@Vip7Quantity\r\n                                   ,@Vip8Quantity\r\n                                   ,@Vip9Quantity\r\n                                   ,@Vip10Quantity\r\n                                   ,@Vip11Quantity\r\n                                   ,@Vip12Quantity)", new SqlParameter[18]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@GoodsID", (object) item.GoodsID),
          new SqlParameter("@Discount", (object) item.Discount),
          new SqlParameter("@Price", (object) item.Price),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@Vip1Quantity", (object) item.Vip1Quantity),
          new SqlParameter("@Vip2Quantity", (object) item.Vip2Quantity),
          new SqlParameter("@Vip3Quantity", (object) item.Vip3Quantity),
          new SqlParameter("@Vip4Quantity", (object) item.Vip4Quantity),
          new SqlParameter("@Vip5Quantity", (object) item.Vip5Quantity),
          new SqlParameter("@Vip6Quantity", (object) item.Vip6Quantity),
          new SqlParameter("@Vip7Quantity", (object) item.Vip7Quantity),
          new SqlParameter("@Vip8Quantity", (object) item.Vip8Quantity),
          new SqlParameter("@Vip9Quantity", (object) item.Vip9Quantity),
          new SqlParameter("@Vip10Quantity", (object) item.Vip10Quantity),
          new SqlParameter("@Vip11Quantity", (object) item.Vip11Quantity),
          new SqlParameter("@Vip12Quantity", (object) item.Vip12Quantity)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddVipStore: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateVipStore(VipStoreInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Vip_Store]\r\n                               SET [ID] = @ID\r\n                                  ,[Type] = @Type\r\n                                  ,[GoodsID] = @GoodsID\r\n                                  ,[Discount] = @Discount\r\n                                  ,[Price] = @Price\r\n                                  ,[ValidDate] = @ValidDate\r\n                                  ,[Vip1Quantity] = @Vip1Quantity\r\n                                  ,[Vip2Quantity] = @Vip2Quantity\r\n                                  ,[Vip3Quantity] = @Vip3Quantity\r\n                                  ,[Vip4Quantity] = @Vip4Quantity\r\n                                  ,[Vip5Quantity] = @Vip5Quantity\r\n                                  ,[Vip6Quantity] = @Vip6Quantity\r\n                                  ,[Vip7Quantity] = @Vip7Quantity\r\n                                  ,[Vip8Quantity] = @Vip8Quantity\r\n                                  ,[Vip9Quantity] = @Vip9Quantity\r\n                                  ,[Vip10Quantity] = @Vip10Quantity\r\n                                  ,[Vip11Quantity] = @Vip11Quantity\r\n                                  ,[Vip12Quantity] = @Vip12Quantity\r\n                            WHERE [ID] = @ID", new SqlParameter[18]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@GoodsID", (object) item.GoodsID),
          new SqlParameter("@Discount", (object) item.Discount),
          new SqlParameter("@Price", (object) item.Price),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@Vip1Quantity", (object) item.Vip1Quantity),
          new SqlParameter("@Vip2Quantity", (object) item.Vip2Quantity),
          new SqlParameter("@Vip3Quantity", (object) item.Vip3Quantity),
          new SqlParameter("@Vip4Quantity", (object) item.Vip4Quantity),
          new SqlParameter("@Vip5Quantity", (object) item.Vip5Quantity),
          new SqlParameter("@Vip6Quantity", (object) item.Vip6Quantity),
          new SqlParameter("@Vip7Quantity", (object) item.Vip7Quantity),
          new SqlParameter("@Vip8Quantity", (object) item.Vip8Quantity),
          new SqlParameter("@Vip9Quantity", (object) item.Vip9Quantity),
          new SqlParameter("@Vip10Quantity", (object) item.Vip10Quantity),
          new SqlParameter("@Vip11Quantity", (object) item.Vip11Quantity),
          new SqlParameter("@Vip12Quantity", (object) item.Vip12Quantity)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateVipStore: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteVipStore(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Vip_Store] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteVipStore: " + ex.ToString());
            }
            return flag;
        }

        public DailyAwardInfo[] GetAllDailyAward()
        {
            List<DailyAwardInfo> dailyAwardInfoList = new List<DailyAwardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Daily_Award]");
                while (Sdr.Read())
                    dailyAwardInfoList.Add(this.InitDailyAwardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllDailyAward " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return dailyAwardInfoList.ToArray();
        }

        public DailyAwardInfo GetSingleDailyAward(int id)
        {
            List<DailyAwardInfo> dailyAwardInfoList = new List<DailyAwardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Daily_Award] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    dailyAwardInfoList.Add(this.InitDailyAwardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleDailyAward " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return dailyAwardInfoList.Count > 0 ? dailyAwardInfoList[0] : (DailyAwardInfo)null;
        }

        public DailyAwardInfo InitDailyAwardInfo(SqlDataReader reader) => new DailyAwardInfo()
        {
            ID = (int)reader["ID"],
            Type = (int)reader["Type"],
            TemplateID = (int)reader["TemplateID"],
            Count = (int)reader["Count"],
            ValidDate = (int)reader["ValidDate"],
            IsBinds = (bool)reader["IsBinds"],
            Sex = (int)reader["Sex"],
            Remark = reader["Remark"] == null ? "" : reader["Remark"].ToString(),
            CountRemark = reader["CountRemark"] == null ? "" : reader["CountRemark"].ToString(),
            GetWay = (int)reader["GetWay"],
            AwardDays = (int)reader["AwardDays"]
        };

        public bool AddDailyAward(DailyAwardInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Daily_Award]\r\n                                   ([ID]\r\n                                   ,[Type]\r\n                                   ,[TemplateID]\r\n                                   ,[Count]\r\n                                   ,[ValidDate]\r\n                                   ,[IsBinds]\r\n                                   ,[Sex]\r\n                                   ,[Remark]\r\n                                   ,[CountRemark]\r\n                                   ,[GetWay]\r\n                                   ,[AwardDays])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Type\r\n                                   ,@TemplateID\r\n                                   ,@Count\r\n                                   ,@ValidDate\r\n                                   ,@IsBinds\r\n                                   ,@Sex\r\n                                   ,@Remark\r\n                                   ,@CountRemark\r\n                                   ,@GetWay\r\n                                   ,@AwardDays)", new SqlParameter[11]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@IsBinds", (object) item.IsBinds),
          new SqlParameter("@Sex", (object) item.Sex),
          new SqlParameter("@Remark", (object) item.Remark),
          new SqlParameter("@CountRemark", (object) item.CountRemark),
          new SqlParameter("@GetWay", (object) item.GetWay),
          new SqlParameter("@AwardDays", (object) item.AwardDays)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddDailyAward: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateDailyAward(DailyAwardInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Daily_Award]\r\n                               SET [Type] = @Type\r\n                                  ,[TemplateID] = @TemplateID\r\n                                  ,[Count] = @Count\r\n                                  ,[ValidDate] = @ValidDate\r\n                                  ,[IsBinds] = @IsBinds\r\n                                  ,[Sex] = @Sex\r\n                                  ,[Remark] = @Remark\r\n                                  ,[CountRemark] = @CountRemark\r\n                                  ,[GetWay] = @GetWay\r\n                                  ,[AwardDays] = @AwardDays\r\n                            WHERE [ID] = @ID", new SqlParameter[11]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@IsBinds", (object) item.IsBinds),
          new SqlParameter("@Sex", (object) item.Sex),
          new SqlParameter("@Remark", (object) item.Remark),
          new SqlParameter("@CountRemark", (object) item.CountRemark),
          new SqlParameter("@GetWay", (object) item.GetWay),
          new SqlParameter("@AwardDays", (object) item.AwardDays)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateDailyAward: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteDailyAward(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Daily_Award] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteDailyAward: " + ex.ToString());
            }
            return flag;
        }

        public ActivitySystemItemInfo[] GetAllActivitySystemItems()
        {
            List<ActivitySystemItemInfo> activitySystemItemInfoList = new List<ActivitySystemItemInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Activity_System_Item]");
                while (Sdr.Read())
                    activitySystemItemInfoList.Add(this.InitActivitySystemItems(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllActivitySystemItems " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activitySystemItemInfoList.ToArray();
        }

        public ActivitySystemItemInfo GetSingleActivitySystemItem(int id)
        {
            List<ActivitySystemItemInfo> activitySystemItemInfoList = new List<ActivitySystemItemInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Activity_System_Item] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    activitySystemItemInfoList.Add(this.InitActivitySystemItems(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleDailyAward " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activitySystemItemInfoList.Count > 0 ? activitySystemItemInfoList[0] : (ActivitySystemItemInfo)null;
        }

        public ActivitySystemItemInfo InitActivitySystemItems(SqlDataReader reader) => new ActivitySystemItemInfo()
        {
            ID = (int)reader["ID"],
            ActivityType = (int)reader["ActivityType"],
            Quality = (int)reader["Quality"],
            TemplateID = (int)reader["TemplateID"],
            Count = (int)reader["Count"],
            ValidDate = (int)reader["ValidDate"],
            IsBind = (bool)reader["IsBind"],
            StrengthLevel = (int)reader["StrengthLevel"],
            AttackCompose = (int)reader["AttackCompose"],
            DefendCompose = (int)reader["DefendCompose"],
            AgilityCompose = (int)reader["AgilityCompose"],
            LuckCompose = (int)reader["LuckCompose"],
            Probability = (int)reader["Probability"]
        };

        public bool AddActivitySystemItems(ActivitySystemItemInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Activity_System_Item]\r\n                                   ([ActivityType]\r\n                                   ,[Quality]\r\n                                   ,[TemplateID]\r\n                                   ,[Count]\r\n                                   ,[ValidDate]\r\n                                   ,[IsBind]\r\n                                   ,[StrengthLevel]\r\n                                   ,[AttackCompose]\r\n                                   ,[DefendCompose]\r\n                                   ,[AgilityCompose]\r\n                                   ,[LuckCompose]\r\n                                   ,[Probability])\r\n                               VALUES\r\n                                   (@ActivityType\r\n                                   ,@Quality\r\n                                   ,@TemplateID\r\n                                   ,@Count\r\n                                   ,@ValidDate\r\n                                   ,@IsBind\r\n                                   ,@StrengthLevel\r\n                                   ,@AttackCompose\r\n                                   ,@DefendCompose\r\n                                   ,@AgilityCompose\r\n                                   ,@LuckCompose\r\n                                   ,@Probability)", new SqlParameter[12]
                {
          new SqlParameter("@ActivityType", (object) item.ActivityType),
          new SqlParameter("@Quality", (object) item.Quality),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@StrengthLevel", (object) item.StrengthLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@Probability", (object) item.Probability)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddDailyAward: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateActivitySystemItems(ActivitySystemItemInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Activity_System_Item]\r\n                               SET [ActivityType] = @ActivityType\r\n                                  ,[Quality] = @Quality\r\n                                  ,[TemplateID] = @TemplateID\r\n                                  ,[Count] = @Count\r\n                                  ,[IsBind] = @IsBind\r\n                                  ,[ValidDate] = @ValidDate\r\n                                  ,[StrengthLevel] = @StrengthLevel\r\n                                  ,[AttackCompose] = @AttackCompose\r\n                                  ,[DefendCompose] = @DefendCompose\r\n                                  ,[AgilityCompose] = @AgilityCompose\r\n                                  ,[LuckCompose] = @LuckCompose\r\n                                  ,[Probability] = @Probability\r\n                            WHERE [ID] = @ID", new SqlParameter[13]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@ActivityType", (object) item.ActivityType),
          new SqlParameter("@Quality", (object) item.Quality),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@StrengthLevel", (object) item.StrengthLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@Probability", (object) item.Probability)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateActivitySystemItems: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteActivitySystemItemInfo(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Activity_System_Item] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteActivitySystemItemInfo: " + ex.ToString());
            }
            return flag;
        }

        public ExerciseInfo[] GetAllExercise()
        {
            List<ExerciseInfo> exerciseInfoList = new List<ExerciseInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[ExerciseInfo]");
                while (Sdr.Read())
                    exerciseInfoList.Add(this.InitExerciseInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllExercise " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return exerciseInfoList.ToArray();
        }

        public ExerciseInfo GetSingleExercise(int id)
        {
            List<ExerciseInfo> exerciseInfoList = new List<ExerciseInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[ExerciseInfo] WHERE [Grage] = " + id.ToString());
                while (Sdr.Read())
                    exerciseInfoList.Add(this.InitExerciseInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleExercise " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return exerciseInfoList.Count > 0 ? exerciseInfoList[0] : (ExerciseInfo)null;
        }

        public ExerciseInfo InitExerciseInfo(SqlDataReader reader) => new ExerciseInfo()
        {
            Grage = (int)reader["Grage"],
            GP = (int)reader["GP"],
            ExerciseA = (int)reader["ExerciseA"],
            ExerciseAG = (int)reader["ExerciseAG"],
            ExerciseD = (int)reader["ExerciseD"],
            ExerciseH = (int)reader["ExerciseH"],
            ExerciseL = (int)reader["ExerciseL"],
            ExerciseMA = (int)reader["ExerciseMA"],
            ExerciseMD = (int)reader["ExerciseMD"]
        };

        public bool AddExercise(ExerciseInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[ExerciseInfo]\r\n                                   ([Grage]\r\n                                   ,[GP]\r\n                                   ,[ExerciseA]\r\n                                   ,[ExerciseAG]\r\n                                   ,[ExerciseD]\r\n                                   ,[ExerciseH]\r\n                                   ,[ExerciseL]\r\n                                   ,[ExerciseMA]\r\n                                   ,[ExerciseMD])\r\n                               VALUES\r\n                                   (@Grage\r\n                                   ,@GP\r\n                                   ,@ExerciseA\r\n                                   ,@ExerciseAG\r\n                                   ,@ExerciseD\r\n                                   ,@ExerciseH\r\n                                   ,@ExerciseL\r\n                                   ,@ExerciseMA\r\n                                   ,@ExerciseMD)", new SqlParameter[9]
                {
          new SqlParameter("@Grage", (object) item.Grage),
          new SqlParameter("@GP", (object) item.GP),
          new SqlParameter("@ExerciseA", (object) item.ExerciseA),
          new SqlParameter("@ExerciseAG", (object) item.ExerciseAG),
          new SqlParameter("@ExerciseD", (object) item.ExerciseD),
          new SqlParameter("@ExerciseH", (object) item.ExerciseH),
          new SqlParameter("@ExerciseL", (object) item.ExerciseL),
          new SqlParameter("@ExerciseMA", (object) item.ExerciseMA),
          new SqlParameter("@ExerciseMD", (object) item.ExerciseMD)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddExercise: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateExercise(ExerciseInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[ExerciseInfo]\r\n                               SET [GP] = @GP\r\n                                  ,[ExerciseA] = @ExerciseA\r\n                                  ,[ExerciseAG] = @ExerciseAG\r\n                                  ,[ExerciseD] = @ExerciseD\r\n                                  ,[ExerciseH] = @ExerciseH\r\n                                  ,[ExerciseL] = @ExerciseL\r\n                                  ,[ExerciseMA] = @ExerciseMA\r\n                                  ,[ExerciseMD] = @ExerciseMD\r\n                            WHERE [Grage] = @Grage", new SqlParameter[9]
                {
          new SqlParameter("@Grage", (object) item.Grage),
          new SqlParameter("@GP", (object) item.GP),
          new SqlParameter("@ExerciseA", (object) item.ExerciseA),
          new SqlParameter("@ExerciseAG", (object) item.ExerciseAG),
          new SqlParameter("@ExerciseD", (object) item.ExerciseD),
          new SqlParameter("@ExerciseH", (object) item.ExerciseH),
          new SqlParameter("@ExerciseL", (object) item.ExerciseL),
          new SqlParameter("@ExerciseMA", (object) item.ExerciseMA),
          new SqlParameter("@ExerciseMD", (object) item.ExerciseMD)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateExercise: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteExercise(int grage)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[ExerciseInfo] WHERE [Grage] = @Grage", new SqlParameter[1]
                {
          new SqlParameter("@Grage", (object) grage)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteExercise: " + ex.ToString());
            }
            return flag;
        }

        public FightSpiritTemplateInfo[] GetAllFightSpiritTemplate()
        {
            List<FightSpiritTemplateInfo> spiritTemplateInfoList = new List<FightSpiritTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Fight_Spirit_Templatelist]");
                while (Sdr.Read())
                    spiritTemplateInfoList.Add(this.InitFightSpiritTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllFightSpiritTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return spiritTemplateInfoList.ToArray();
        }

        public FightSpiritTemplateInfo GetSingleFightSpiritTemplate(int id)
        {
            List<FightSpiritTemplateInfo> spiritTemplateInfoList = new List<FightSpiritTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Fight_Spirit_Templatelist] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    spiritTemplateInfoList.Add(this.InitFightSpiritTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleFightSpiritTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return spiritTemplateInfoList.Count > 0 ? spiritTemplateInfoList[0] : (FightSpiritTemplateInfo)null;
        }

        public FightSpiritTemplateInfo InitFightSpiritTemplateInfo(
          SqlDataReader reader)
        {
            return new FightSpiritTemplateInfo()
            {
                FightSpiritID = (int)reader["FightSpiritID"],
                FightSpiritIcon = reader["FightSpiritIcon"] == null ? "" : reader["FightSpiritIcon"].ToString(),
                Level = (int)reader["Level"],
                Exp = (int)reader["Exp"],
                Attack = (int)reader["Attack"],
                Defence = (int)reader["Defence"],
                Agility = (int)reader["Agility"],
                Lucky = (int)reader["Lucky"],
                Blood = (int)reader["Blood"]
            };
        }

        public bool AddFightSpiritTemplate(FightSpiritTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Fight_Spirit_Templatelist]\r\n                                   ([FightSpiritID]\r\n                                   ,[FightSpiritIcon]\r\n                                   ,[Level]\r\n                                   ,[Exp]\r\n                                   ,[Attack]\r\n                                   ,[Defence]\r\n                                   ,[Agility]\r\n                                   ,[Lucky]\r\n                                   ,[Blood])\r\n                               VALUES\r\n                                   (@FightSpiritID\r\n                                   ,@FightSpiritIcon\r\n                                   ,@Level\r\n                                   ,@Exp\r\n                                   ,@Attack\r\n                                   ,@Defence\r\n                                   ,@Agility\r\n                                   ,@Lucky\r\n                                   ,@Blood)", new SqlParameter[9]
                {
          new SqlParameter("@FightSpiritID", (object) item.FightSpiritID),
          new SqlParameter("@FightSpiritIcon", (object) item.FightSpiritIcon),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Lucky", (object) item.Lucky),
          new SqlParameter("@Blood", (object) item.Blood)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddFightSpiritTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateFightSpiritTemplate(FightSpiritTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Fight_Spirit_Templatelist]\r\n                               SET [FightSpiritID] = @FightSpiritID\r\n                                  ,[FightSpiritIcon] = @FightSpiritIcon\r\n                                  ,[Level] = @Level\r\n                                  ,[Exp] = @Exp\r\n                                  ,[Attack] = @Attack\r\n                                  ,[Defence] = @Defence\r\n                                  ,[Agility] = @Agility\r\n                                  ,[Lucky] = @Lucky\r\n                                  ,[Blood] = @Blood\r\n                            WHERE [FightSpiritID] = @FightSpiritID AND [Level] = @Level", new SqlParameter[9]
                {
          new SqlParameter("@FightSpiritID", (object) item.FightSpiritID),
          new SqlParameter("@FightSpiritIcon", (object) item.FightSpiritIcon),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Lucky", (object) item.Lucky),
          new SqlParameter("@Blood", (object) item.Blood)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateFightSpiritTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteFightSpiritTemplate(int fightSpiritID, int level)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Fight_Spirit_Templatelist] WHERE [FightSpiritID] = @FightSpiritID AND [Level] = @Level", new SqlParameter[2]
                {
          new SqlParameter("@FightSpiritID", (object) fightSpiritID),
          new SqlParameter("@Level", (object) level)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteFightSpiritTemplate: " + ex.ToString());
            }
            return flag;
        }

        public PetTemplateInfo[] GetAllPetTemplate()
        {
            List<PetTemplateInfo> petTemplateInfoList = new List<PetTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Template_Info]");
                while (Sdr.Read())
                    petTemplateInfoList.Add(this.InitPetTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPetTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petTemplateInfoList.ToArray();
        }

        public PetTemplateInfo GetSinglePetTemplate(int id)
        {
            List<PetTemplateInfo> petTemplateInfoList = new List<PetTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Template_Info] WHERE TemplateID = " + id.ToString());
                while (Sdr.Read())
                    petTemplateInfoList.Add(this.InitPetTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePetTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petTemplateInfoList.Count > 0 ? petTemplateInfoList[0] : (PetTemplateInfo)null;
        }

        public PetTemplateInfo InitPetTemplateInfo(SqlDataReader reader) => new PetTemplateInfo()
        {
            TemplateID = (int)reader["TemplateID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            KindID = (int)reader["KindID"],
            Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
            Pic = reader["Pic"] == null ? "" : reader["Pic"].ToString(),
            RareLevel = (int)reader["RareLevel"],
            MP = (int)reader["MP"],
            StarLevel = (int)reader["StarLevel"],
            GameAssetUrl = reader["GameAssetUrl"] == null ? "" : reader["GameAssetUrl"].ToString(),
            EvolutionID = (int)reader["EvolutionID"],
            HighAgility = (int)reader["HighAgility"],
            HighAgilityGrow = (int)reader["HighAgilityGrow"],
            HighAttack = (int)reader["HighAttack"],
            HighAttackGrow = (int)reader["HighAttackGrow"],
            HighBlood = (int)reader["HighBlood"],
            HighBloodGrow = (int)reader["HighBloodGrow"],
            HighDamage = (int)reader["HighDamage"],
            HighDamageGrow = (int)reader["HighDamageGrow"],
            HighDefence = (int)reader["HighDefence"],
            HighDefenceGrow = (int)reader["HighDefenceGrow"],
            HighGuard = (int)reader["HighGuard"],
            HighGuardGrow = (int)reader["HighGuardGrow"],
            HighLuck = (int)reader["HighLuck"],
            HighLuckGrow = (int)reader["HighLuckGrow"]
        };

        public bool AddPetTemplate(PetTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Pet_Template_Info]\r\n                                   ([TemplateID]\r\n                                   ,[Name]\r\n                                   ,[KindID]\r\n                                   ,[Description]\r\n                                   ,[Pic]\r\n                                   ,[RareLevel]\r\n                                   ,[MP]\r\n                                   ,[StarLevel]\r\n                                   ,[GameAssetUrl]\r\n                                   ,[EvolutionID]\r\n                                   ,[HighAgility]\r\n                                   ,[HighAgilityGrow]\r\n                                   ,[HighAttack]\r\n                                   ,[HighAttackGrow]\r\n                                   ,[HighBlood]\r\n                                   ,[HighBloodGrow]\r\n                                   ,[HighDamage]\r\n                                   ,[HighDamageGrow]\r\n                                   ,[HighDefence]\r\n                                   ,[HighDefenceGrow]\r\n                                   ,[HighGuard]\r\n                                   ,[HighGuardGrow]\r\n                                   ,[HighLuck]\r\n                                   ,[HighLuckGrow])\r\n                               VALUES\r\n                                   (@TemplateID\r\n                                   ,@Name\r\n                                   ,@KindID\r\n                                   ,@Description\r\n                                   ,@Pic\r\n                                   ,@RareLevel\r\n                                   ,@MP\r\n                                   ,@StarLevel\r\n                                   ,@GameAssetUrl\r\n                                   ,@EvolutionID\r\n                                   ,@HighAgility\r\n                                   ,@HighAgilityGrow\r\n                                   ,@HighAttack\r\n                                   ,@HighAttackGrow\r\n                                   ,@HighBlood\r\n                                   ,@HighBloodGrow\r\n                                   ,@HighDamage\r\n                                   ,@HighDamageGrow\r\n                                   ,@HighDefence\r\n                                   ,@HighDefenceGrow\r\n                                   ,@HighGuard\r\n                                   ,@HighGuardGrow\r\n                                   ,@HighLuck\r\n                                   ,@HighLuckGrow)", new SqlParameter[24]
                {
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@KindID", (object) item.KindID),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@RareLevel", (object) item.RareLevel),
          new SqlParameter("@MP", (object) item.MP),
          new SqlParameter("@StarLevel", (object) item.StarLevel),
          new SqlParameter("@GameAssetUrl", (object) item.GameAssetUrl),
          new SqlParameter("@EvolutionID", (object) item.EvolutionID),
          new SqlParameter("@HighAgility", (object) item.HighAgility),
          new SqlParameter("@HighAgilityGrow", (object) item.HighAgilityGrow),
          new SqlParameter("@HighAttack", (object) item.HighAttack),
          new SqlParameter("@HighAttackGrow", (object) item.HighAttackGrow),
          new SqlParameter("@HighBlood", (object) item.HighBlood),
          new SqlParameter("@HighBloodGrow", (object) item.HighBloodGrow),
          new SqlParameter("@HighDamage", (object) item.HighDamage),
          new SqlParameter("@HighDamageGrow", (object) item.HighDamageGrow),
          new SqlParameter("@HighDefence", (object) item.HighDefence),
          new SqlParameter("@HighDefenceGrow", (object) item.HighDefenceGrow),
          new SqlParameter("@HighGuard", (object) item.HighGuard),
          new SqlParameter("@HighGuardGrow", (object) item.HighGuardGrow),
          new SqlParameter("@HighLuck", (object) item.HighLuck),
          new SqlParameter("@HighLuckGrow", (object) item.HighLuckGrow)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddPetTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePetTemplate(PetTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pet_Template_Info]\r\n                               SET [Name] = @Name\r\n                                  ,[KindID] = @KindID\r\n                                  ,[Description] = @Description\r\n                                  ,[Pic] = @Pic\r\n                                  ,[RareLevel] = @RareLevel\r\n                                  ,[MP] = @MP\r\n                                  ,[StarLevel] = @StarLevel\r\n                                  ,[GameAssetUrl] = @GameAssetUrl\r\n                                  ,[EvolutionID] = @EvolutionID\r\n                                  ,[HighAgility] = @HighAgility\r\n                                  ,[HighAgilityGrow] = @HighAgilityGrow\r\n                                  ,[HighAttack] = @HighAttack\r\n                                  ,[HighAttackGrow] = @HighAttackGrow\r\n                                  ,[HighBlood] = @HighBlood\r\n                                  ,[HighBloodGrow] = @HighBloodGrow\r\n                                  ,[HighDamage] = @HighDamage\r\n                                  ,[HighDamageGrow] = @HighDamageGrow\r\n                                  ,[HighDefence] = @HighDefence\r\n                                  ,[HighDefenceGrow] = @HighDefenceGrow\r\n                                  ,[HighGuard] = @HighGuard\r\n                                  ,[HighGuardGrow] = @HighGuardGrow\r\n                                  ,[HighLuck] = @HighLuck\r\n                                  ,[HighLuckGrow] = @HighLuckGrow\r\n                            WHERE [TemplateID] = @TemplateID", new SqlParameter[24]
                {
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@KindID", (object) item.KindID),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@RareLevel", (object) item.RareLevel),
          new SqlParameter("@MP", (object) item.MP),
          new SqlParameter("@StarLevel", (object) item.StarLevel),
          new SqlParameter("@GameAssetUrl", (object) item.GameAssetUrl),
          new SqlParameter("@EvolutionID", (object) item.EvolutionID),
          new SqlParameter("@HighAgility", (object) item.HighAgility),
          new SqlParameter("@HighAgilityGrow", (object) item.HighAgilityGrow),
          new SqlParameter("@HighAttack", (object) item.HighAttack),
          new SqlParameter("@HighAttackGrow", (object) item.HighAttackGrow),
          new SqlParameter("@HighBlood", (object) item.HighBlood),
          new SqlParameter("@HighBloodGrow", (object) item.HighBloodGrow),
          new SqlParameter("@HighDamage", (object) item.HighDamage),
          new SqlParameter("@HighDamageGrow", (object) item.HighDamageGrow),
          new SqlParameter("@HighDefence", (object) item.HighDefence),
          new SqlParameter("@HighDefenceGrow", (object) item.HighDefenceGrow),
          new SqlParameter("@HighGuard", (object) item.HighGuard),
          new SqlParameter("@HighGuardGrow", (object) item.HighGuardGrow),
          new SqlParameter("@HighLuck", (object) item.HighLuck),
          new SqlParameter("@HighLuckGrow", (object) item.HighLuckGrow)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePetTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePetTemplate(int templateID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Template_Info] WHERE [TemplateID] = @TemplateID", new SqlParameter[1]
                {
          new SqlParameter("@TemplateID", (object) templateID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetTemplate: " + ex.ToString());
            }
            return flag;
        }

        public PetSkillElementInfo[] GetAllPetSkillElement()
        {
            List<PetSkillElementInfo> skillElementInfoList = new List<PetSkillElementInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Skill_Element_Info]");
                while (Sdr.Read())
                    skillElementInfoList.Add(this.InitPetSkillElementInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPetSkillElement " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return skillElementInfoList.ToArray();
        }

        public PetSkillElementInfo GetSinglePetSkillElement(int id)
        {
            List<PetSkillElementInfo> skillElementInfoList = new List<PetSkillElementInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Skill_Element_Info] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    skillElementInfoList.Add(this.InitPetSkillElementInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePetSkillElement " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return skillElementInfoList.Count > 0 ? skillElementInfoList[0] : (PetSkillElementInfo)null;
        }

        public PetSkillElementInfo InitPetSkillElementInfo(SqlDataReader reader) => new PetSkillElementInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            EffectPic = reader["EffectPic"] == null ? "" : reader["EffectPic"].ToString(),
            Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
            Pic = (int)reader["Pic"]
        };

        public bool AddPetSkillElement(PetSkillElementInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Pet_Skill_Element_Info]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[EffectPic]\r\n                                   ,[Description]\r\n                                   ,[Pic])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@EffectPic\r\n                                   ,@Description\r\n                                   ,@Pic)", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@EffectPic", (object) item.EffectPic),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Pic", (object) item.Pic)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddPetSkillElement: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePetSkillElement(PetSkillElementInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pet_Skill_Element_Info]\r\n                               SET [Name] = @Name\r\n                                  ,[EffectPic] = @EffectPic\r\n                                  ,[Description] = @Description\r\n                                  ,[Pic] = @Pic\r\n                            WHERE [ID] = @ID", new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@EffectPic", (object) item.EffectPic),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Pic", (object) item.Pic)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePetSkillElement: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePetSkillElement(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Skill_Element_Info] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetSkillElement: " + ex.ToString());
            }
            return flag;
        }

        public PetSkillTemplateInfo[] GetAllPetSkillTemplate()
        {
            List<PetSkillTemplateInfo> skillTemplateInfoList = new List<PetSkillTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Skill_Template_Info]");
                while (Sdr.Read())
                    skillTemplateInfoList.Add(this.InitPetSkillTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPetSkillTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return skillTemplateInfoList.ToArray();
        }

        public PetSkillTemplateInfo GetSinglePetSkillTemplate(int id)
        {
            List<PetSkillTemplateInfo> skillTemplateInfoList = new List<PetSkillTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Skill_Template_Info] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    skillTemplateInfoList.Add(this.InitPetSkillTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePetSkillTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return skillTemplateInfoList.Count > 0 ? skillTemplateInfoList[0] : (PetSkillTemplateInfo)null;
        }

        public PetSkillTemplateInfo InitPetSkillTemplateInfo(SqlDataReader reader) => new PetSkillTemplateInfo()
        {
            PetTemplateID = (int)reader["PetTemplateID"],
            KindID = (int)reader["KindID"],
            Type = (int)reader["GetType"],
            SkillID = (int)reader["SkillID"],
            SkillBookID = (int)reader["SkillBookID"],
            MinLevel = (int)reader["MinLevel"],
            DeleteSkillIDs = reader["DeleteSkillIDs"] == null ? "" : reader["DeleteSkillIDs"].ToString()
        };

        public bool AddPetSkillTemplate(PetSkillTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Pet_Skill_Template_Info]\r\n                                   ([PetTemplateID]\r\n                                   ,[KindID]\r\n                                   ,[GetType]\r\n                                   ,[SkillID]\r\n                                   ,[SkillBookID]\r\n                                   ,[MinLevel]\r\n                                   ,[DeleteSkillIDs])\r\n                               VALUES\r\n                                   (@PetTemplateID\r\n                                   ,@KindID\r\n                                   ,@GetType\r\n                                   ,@SkillID\r\n                                   ,@SkillBookID\r\n                                   ,@MinLevel\r\n                                   ,@DeleteSkillIDs)", new SqlParameter[7]
                {
          new SqlParameter("@PetTemplateID", (object) item.PetTemplateID),
          new SqlParameter("@KindID", (object) item.KindID),
          new SqlParameter("@GetType", (object) item.Type),
          new SqlParameter("@SkillID", (object) item.SkillID),
          new SqlParameter("@SkillBookID", (object) item.SkillBookID),
          new SqlParameter("@MinLevel", (object) item.MinLevel),
          new SqlParameter("@DeleteSkillIDs", (object) item.DeleteSkillIDs)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddPetSkillTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePetSkillTemplate(PetSkillTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pet_Skill_Template_Info]\r\n                               SET [KindID] = @KindID\r\n                                  ,[GetType] = @GetType\r\n                                  ,[SkillID] = @SkillID\r\n                                  ,[SkillBookID] = @SkillBookID\r\n                                  ,[MinLevel] = @MinLevel\r\n                                  ,[DeleteSkillIDs] = @DeleteSkillIDs\r\n                            WHERE [PetTemplateID] = @PetTemplateID", new SqlParameter[7]
                {
          new SqlParameter("@PetTemplateID", (object) item.PetTemplateID),
          new SqlParameter("@KindID", (object) item.KindID),
          new SqlParameter("@GetType", (object) item.Type),
          new SqlParameter("@SkillID", (object) item.SkillID),
          new SqlParameter("@SkillBookID", (object) item.SkillBookID),
          new SqlParameter("@MinLevel", (object) item.MinLevel),
          new SqlParameter("@DeleteSkillIDs", (object) item.DeleteSkillIDs)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePetSkillTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePetSkillTemplate(int petTemplateID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Skill_Template_Info] WHERE [PetTemplateID] = @PetTemplateID", new SqlParameter[1]
                {
          new SqlParameter("@PetTemplateID", (object) petTemplateID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetSkillTemplate: " + ex.ToString());
            }
            return flag;
        }

        public PetSkillInfo[] GetAllPetSkill()
        {
            List<PetSkillInfo> petSkillInfoList = new List<PetSkillInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Skill_Info]");
                while (Sdr.Read())
                    petSkillInfoList.Add(this.InitPetSkillInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPetSkill " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petSkillInfoList.ToArray();
        }

        public PetSkillInfo GetSinglePetSkill(int id)
        {
            List<PetSkillInfo> petSkillInfoList = new List<PetSkillInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Skill_Info] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    petSkillInfoList.Add(this.InitPetSkillInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePetSkill " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petSkillInfoList.Count > 0 ? petSkillInfoList[0] : (PetSkillInfo)null;
        }

        public PetSkillInfo InitPetSkillInfo(SqlDataReader reader) => new PetSkillInfo()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            ElementIDs = reader["ElementIDs"] == null ? "" : reader["ElementIDs"].ToString(),
            Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
            BallType = (int)reader["BallType"],
            NewBallID = (int)reader["NewBallID"],
            CostMP = (int)reader["CostMP"],
            Pic = (int)reader["Pic"],
            Action = reader["Action"] == null ? "" : reader["Action"].ToString(),
            EffectPic = reader["EffectPic"] == null ? "" : reader["EffectPic"].ToString(),
            Delay = (int)reader["Delay"],
            ColdDown = (int)reader["ColdDown"],
            GameType = (int)reader["GameType"],
            Probability = (int)reader["Probability"]
        };

        public bool AddPetSkill(PetSkillInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Pet_Skill_Info]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[ElementIDs]\r\n                                   ,[Description]\r\n                                   ,[BallType]\r\n                                   ,[NewBallID]\r\n                                   ,[CostMP]\r\n                                   ,[Pic]\r\n                                   ,[Action]\r\n                                   ,[EffectPic]\r\n                                   ,[Delay]\r\n                                   ,[ColdDown]\r\n                                   ,[GameType]\r\n                                   ,[Probability])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@ElementIDs\r\n                                   ,@Description\r\n                                   ,@BallType\r\n                                   ,@NewBallID\r\n                                   ,@CostMP\r\n                                   ,@Pic\r\n                                   ,@Action\r\n                                   ,@EffectPic\r\n                                   ,@Delay\r\n                                   ,@ColdDown\r\n                                   ,@GameType\r\n                                   ,@Probability)", new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@ElementIDs", (object) item.ElementIDs),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@BallType", (object) item.BallType),
          new SqlParameter("@NewBallID", (object) item.NewBallID),
          new SqlParameter("@CostMP", (object) item.CostMP),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@Action", (object) item.Action),
          new SqlParameter("@EffectPic", (object) item.EffectPic),
          new SqlParameter("@Delay", (object) item.Delay),
          new SqlParameter("@ColdDown", (object) item.ColdDown),
          new SqlParameter("@GameType", (object) item.GameType),
          new SqlParameter("@Probability", (object) item.Probability)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddPetSkill: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePetSkill(PetSkillInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pet_Skill_Info]\r\n                               SET [Name] = @Name\r\n                                  ,[ElementIDs] = @ElementIDs\r\n                                  ,[Description] = @Description\r\n                                  ,[BallType] = @BallType\r\n                                  ,[NewBallID] = @NewBallID\r\n                                  ,[CostMP] = @CostMP\r\n                                  ,[Pic] = @Pic\r\n                                  ,[Action] = @Action\r\n                                  ,[EffectPic] = @EffectPic\r\n                                  ,[Delay] = @Delay\r\n                                  ,[ColdDown] = @ColdDown\r\n                                  ,[GameType] = @GameType\r\n                                  ,[Probability] = @Probability\r\n                            WHERE [ID] = @ID", new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@ElementIDs", (object) item.ElementIDs),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@BallType", (object) item.BallType),
          new SqlParameter("@NewBallID", (object) item.NewBallID),
          new SqlParameter("@CostMP", (object) item.CostMP),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@Action", (object) item.Action),
          new SqlParameter("@EffectPic", (object) item.EffectPic),
          new SqlParameter("@Delay", (object) item.Delay),
          new SqlParameter("@ColdDown", (object) item.ColdDown),
          new SqlParameter("@GameType", (object) item.GameType),
          new SqlParameter("@Probability", (object) item.Probability)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePetSkill: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePetSkill(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Skill_Info] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetSkill: " + ex.ToString());
            }
            return flag;
        }

        public PetStarExpInfo[] GetAllPetStarExp()
        {
            List<PetStarExpInfo> petStarExpInfoList = new List<PetStarExpInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Star_Exp]");
                while (Sdr.Read())
                    petStarExpInfoList.Add(this.InitPetStarExpInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPetStarExp " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petStarExpInfoList.ToArray();
        }

        public PetStarExpInfo GetSinglePetStarExp(int id)
        {
            List<PetStarExpInfo> petStarExpInfoList = new List<PetStarExpInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Star_Exp] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    petStarExpInfoList.Add(this.InitPetStarExpInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePetStarExp " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petStarExpInfoList.Count > 0 ? petStarExpInfoList[0] : (PetStarExpInfo)null;
        }

        public PetStarExpInfo InitPetStarExpInfo(SqlDataReader reader) => new PetStarExpInfo()
        {
            ID = (int)reader["ID"],
            Exp = (int)reader["Exp"],
            OldID = (int)reader["OldID"],
            NewID = (int)reader["NewID"]
        };

        public bool AddPetStarExp(PetStarExpInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Pet_Star_Exp]\r\n                                   ([Exp]\r\n                                   ,[OldID]\r\n                                   ,[NewID])\r\n                               VALUES\r\n                                   (@Exp\r\n                                   ,@OldID\r\n                                   ,@NewID)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.ID),
          null,
          null,
          null
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Exp", (object)item.Exp);
                SqlParameters[2] = new SqlParameter("@OldID", (object)item.OldID);
                SqlParameters[3] = new SqlParameter("@NewID", (object)item.NewID);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddPetStarExp: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePetStarExp(PetStarExpInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pet_Star_Exp]\r\n                               SET [Exp] = @Exp\r\n                                  ,[OldID] = @OldID\r\n                                  ,[NewID] = @NewID\r\n                            WHERE [ID] = @ID", new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@OldID", (object) item.OldID),
          new SqlParameter("@NewID", (object) item.NewID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePetStarExp: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePetStarExp(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Star_Exp] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetStarExp: " + ex.ToString());
            }
            return flag;
        }

        public PetConfig[] GetAllPetConfig()
        {
            List<PetConfig> petConfigList = new List<PetConfig>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Config]");
                while (Sdr.Read())
                    petConfigList.Add(this.InitPetConfig(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPetConfig " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petConfigList.ToArray();
        }

        public PetConfig GetSinglePetConfig(int id)
        {
            List<PetConfig> petConfigList = new List<PetConfig>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Config] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    petConfigList.Add(this.InitPetConfig(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePetConfig " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petConfigList.Count > 0 ? petConfigList[0] : (PetConfig)null;
        }

        public PetConfig InitPetConfig(SqlDataReader reader) => new PetConfig()
        {
            ID = (int)reader["ID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Value = reader["Value"] == null ? "" : reader["Value"].ToString()
        };

        public bool AddPetConfig(PetConfig item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Pet_Config]\r\n                                   ([ID]\r\n                                   ,[Name]\r\n                                   ,[Value])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Name\r\n                                   ,@Value)", new SqlParameter[3]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Value", (object) item.Value)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddPetConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePetConfig(PetConfig item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pet_Config]\r\n                               SET [Name] = @Name\r\n                                  ,[Value] = @Value\r\n                            WHERE [ID] = @ID", new SqlParameter[3]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Value", (object) item.Value)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePetConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePetConfig(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Config] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetConfig: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllPetConfig()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Config]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetConfig: " + ex.ToString());
            }
            return flag;
        }

        public PetExpItemPriceInfo[] GetAllPetExpItemPrice()
        {
            List<PetExpItemPriceInfo> expItemPriceInfoList = new List<PetExpItemPriceInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Exp_Item_Price]");
                while (Sdr.Read())
                    expItemPriceInfoList.Add(this.InitPetExpItemPriceInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPetExpItemPrice " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return expItemPriceInfoList.ToArray();
        }

        public PetExpItemPriceInfo GetSinglePetExpItemPrice(int id)
        {
            List<PetExpItemPriceInfo> expItemPriceInfoList = new List<PetExpItemPriceInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Exp_Item_Price] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    expItemPriceInfoList.Add(this.InitPetExpItemPriceInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePetExpItemPrice " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return expItemPriceInfoList.Count > 0 ? expItemPriceInfoList[0] : (PetExpItemPriceInfo)null;
        }

        public PetExpItemPriceInfo InitPetExpItemPriceInfo(SqlDataReader reader) => new PetExpItemPriceInfo()
        {
            ID = (int)reader["ID"],
            Count = (int)reader["Count"],
            Money = (int)reader["Money"],
            ItemCount = (int)reader["ItemCount"]
        };

        public bool AddPetExpItemPrice(PetExpItemPriceInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Pet_Exp_Item_Price]\r\n                                   ([Count]\r\n                                   ,[Money]\r\n                                   ,[ItemCount])\r\n                               VALUES\r\n                                   (@Count\r\n                                   ,@Money\r\n                                   ,@ItemCount)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.ID),
          null,
          null,
          null
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Count", (object)item.Count);
                SqlParameters[2] = new SqlParameter("@Money", (object)item.Money);
                SqlParameters[3] = new SqlParameter("@ItemCount", (object)item.ItemCount);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddPetExpItemPrice: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePetExpItemPrice(PetExpItemPriceInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pet_Exp_Item_Price]\r\n                               SET [Count] = @Count\r\n                                  ,[Money] = @Money\r\n                                  ,[ItemCount] = @ItemCount\r\n                            WHERE [ID] = @ID", new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@Money", (object) item.Money),
          new SqlParameter("@ItemCount", (object) item.ItemCount)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePetExpItemPrice: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePetExpItemPrice(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Exp_Item_Price] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetExpItemPrice: " + ex.ToString());
            }
            return flag;
        }

        public PetFightPropertyInfo[] GetAllPetFightProperty()
        {
            List<PetFightPropertyInfo> fightPropertyInfoList = new List<PetFightPropertyInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Fight_Property]");
                while (Sdr.Read())
                    fightPropertyInfoList.Add(this.InitPetFightPropertyInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPetFightProperty " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return fightPropertyInfoList.ToArray();
        }

        public PetFightPropertyInfo GetSinglePetFightProperty(int id)
        {
            List<PetFightPropertyInfo> fightPropertyInfoList = new List<PetFightPropertyInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Fight_Property] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    fightPropertyInfoList.Add(this.InitPetFightPropertyInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePetFightProperty " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return fightPropertyInfoList.Count > 0 ? fightPropertyInfoList[0] : (PetFightPropertyInfo)null;
        }

        public PetFightPropertyInfo InitPetFightPropertyInfo(SqlDataReader reader) => new PetFightPropertyInfo()
        {
            ID = (int)reader["ID"],
            Exp = (int)reader["Exp"],
            Attack = (int)reader["Attack"],
            Agility = (int)reader["Agility"],
            Defence = (int)reader["Defence"],
            Lucky = (int)reader["Lucky"],
            Blood = (int)reader["Blood"]
        };

        public bool AddPetFightProperty(PetFightPropertyInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Pet_Fight_Property]\r\n                                   ([ID]\r\n                                   ,[Exp]\r\n                                   ,[Attack]\r\n                                   ,[Agility]\r\n                                   ,[Defence]\r\n                                   ,[Lucky]\r\n                                   ,[Blood])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@Exp\r\n                                   ,@Attack\r\n                                   ,@Agility\r\n                                   ,@Defence\r\n                                   ,@Lucky\r\n                                   ,@Blood)", new SqlParameter[7]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Lucky", (object) item.Lucky),
          new SqlParameter("@Blood", (object) item.Blood)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddPetFightProperty: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePetFightProperty(PetFightPropertyInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pet_Fight_Property]\r\n                               SET [Exp] = @Exp\r\n                                  ,[Attack] = @Attack\r\n                                  ,[Agility] = @Agility\r\n                                  ,[Defence] = @Defence\r\n                                  ,[Lucky] = @Lucky\r\n                                  ,[Blood] = @Blood\r\n                            WHERE [ID] = @ID", new SqlParameter[7]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@Exp", (object) item.Exp),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Lucky", (object) item.Lucky),
          new SqlParameter("@Blood", (object) item.Blood)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePetFightProperty: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePetFightProperty(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Fight_Property] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetFightProperty: " + ex.ToString());
            }
            return flag;
        }

        public PetFormDataInfo[] GetAllPetFormData()
        {
            List<PetFormDataInfo> petFormDataInfoList = new List<PetFormDataInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Form_Data]");
                while (Sdr.Read())
                    petFormDataInfoList.Add(this.InitPetFormDataInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPetFormData " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petFormDataInfoList.ToArray();
        }

        public PetFormDataInfo GetSinglePetFormData(int id)
        {
            List<PetFormDataInfo> petFormDataInfoList = new List<PetFormDataInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Form_Data] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    petFormDataInfoList.Add(this.InitPetFormDataInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePetFormData " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petFormDataInfoList.Count > 0 ? petFormDataInfoList[0] : (PetFormDataInfo)null;
        }

        public PetFormDataInfo InitPetFormDataInfo(SqlDataReader reader) => new PetFormDataInfo()
        {
            TemplateID = (int)reader["TemplateID"],
            Appearance = reader["Appearance"] == null ? "" : reader["Appearance"].ToString(),
            DamageReduce = (int)reader["DamageReduce"],
            HeathUp = (int)reader["HeathUp"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            Resource = reader["Resource"] == null ? "" : reader["Resource"].ToString()
        };

        public bool AddPetFormData(PetFormDataInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Pet_Form_Data]\r\n                                   ([TemplateID]\r\n                                   ,[Appearance]\r\n                                   ,[DamageReduce]\r\n                                   ,[HeathUp]\r\n                                   ,[Name]\r\n                                   ,[Resource])\r\n                               VALUES\r\n                                   (@TemplateID\r\n                                   ,@Appearance\r\n                                   ,@DamageReduce\r\n                                   ,@HeathUp\r\n                                   ,@Name\r\n                                   ,@Resource)", new SqlParameter[6]
                {
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Appearance", (object) item.Appearance),
          new SqlParameter("@DamageReduce", (object) item.DamageReduce),
          new SqlParameter("@HeathUp", (object) item.HeathUp),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Resource", (object) item.Resource)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddPetFormData: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePetFormData(PetFormDataInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pet_Form_Data]\r\n                               SET [Appearance] = @Appearance\r\n                                  ,[DamageReduce] = @DamageReduce\r\n                                  ,[HeathUp] = @HeathUp\r\n                                  ,[Name] = @Name\r\n                                  ,[Resource] = @Resource\r\n                            WHERE [TemplateID] = @TemplateID", new SqlParameter[6]
                {
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Appearance", (object) item.Appearance),
          new SqlParameter("@DamageReduce", (object) item.DamageReduce),
          new SqlParameter("@HeathUp", (object) item.HeathUp),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Resource", (object) item.Resource)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePetFormData: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePetFormData(int templateID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Form_Data] WHERE [TemplateID] = @TemplateID", new SqlParameter[1]
                {
          new SqlParameter("@TemplateID", (object) templateID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetFormData: " + ex.ToString());
            }
            return flag;
        }

        public PetLevel[] GetAllPetLevel()
        {
            List<PetLevel> petLevelList = new List<PetLevel>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Level]");
                while (Sdr.Read())
                    petLevelList.Add(this.InitPetLevel(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPetLevel " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petLevelList.ToArray();
        }

        public PetLevel GetSinglePetLevel(int id)
        {
            List<PetLevel> petLevelList = new List<PetLevel>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Level] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    petLevelList.Add(this.InitPetLevel(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePetLevel " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petLevelList.Count > 0 ? petLevelList[0] : (PetLevel)null;
        }

        public PetLevel InitPetLevel(SqlDataReader reader) => new PetLevel()
        {
            Level = (int)reader["Level"],
            GP = (int)reader["GP"]
        };

        public bool AddPetLevel(PetLevel item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Pet_Level]\r\n                                   ([Level]\r\n                                   ,[GP])\r\n                               VALUES\r\n                                   (@Level\r\n                                   ,@GP)", new SqlParameter[2]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@GP", (object) item.GP)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddPetLevel: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePetLevel(PetLevel item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pet_Level]\r\n                               SET [GP] = @GP\r\n                            WHERE [Level] = @Level", new SqlParameter[2]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@GP", (object) item.GP)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePetLevel: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePetLevel(int level)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Level] WHERE [Level] = @Level", new SqlParameter[1]
                {
          new SqlParameter("@Level", (object) level)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetLevel: " + ex.ToString());
            }
            return flag;
        }

        public PetMoePropertyInfo[] GetAllPetMoeProperty()
        {
            List<PetMoePropertyInfo> petMoePropertyInfoList = new List<PetMoePropertyInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Moe_Property]");
                while (Sdr.Read())
                    petMoePropertyInfoList.Add(this.InitPetMoePropertyInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllPetMoeProperty " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petMoePropertyInfoList.ToArray();
        }

        public PetMoePropertyInfo GetSinglePetMoeProperty(int id)
        {
            List<PetMoePropertyInfo> petMoePropertyInfoList = new List<PetMoePropertyInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Pet_Moe_Property] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    petMoePropertyInfoList.Add(this.InitPetMoePropertyInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSinglePetMoeProperty " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return petMoePropertyInfoList.Count > 0 ? petMoePropertyInfoList[0] : (PetMoePropertyInfo)null;
        }

        public PetMoePropertyInfo InitPetMoePropertyInfo(SqlDataReader reader) => new PetMoePropertyInfo()
        {
            Level = (int)reader["Level"],
            Attack = (int)reader["Attack"],
            Lucky = (int)reader["Lucky"],
            Agility = (int)reader["Agility"],
            Blood = (int)reader["Blood"],
            Defence = (int)reader["Defence"],
            Guard = (int)reader["Guard"],
            Exp = (int)reader["Exp"]
        };

        public bool AddPetMoeProperty(PetMoePropertyInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Pet_Moe_Property]\r\n                                   ([Level]\r\n                                   ,[Attack]\r\n                                   ,[Lucky]\r\n                                   ,[Agility]\r\n                                   ,[Blood]\r\n                                   ,[Defence]\r\n                                   ,[Guard]\r\n                                   ,[Exp])\r\n                               VALUES\r\n                                   (@Level\r\n                                   ,@Attack\r\n                                   ,@Lucky\r\n                                   ,@Agility\r\n                                   ,@Blood\r\n                                   ,@Defence\r\n                                   ,@Guard\r\n                                   ,@Exp)", new SqlParameter[8]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Lucky", (object) item.Lucky),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Blood", (object) item.Blood),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Guard", (object) item.Guard),
          new SqlParameter("@Exp", (object) item.Exp)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddPetMoeProperty: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdatePetMoeProperty(PetMoePropertyInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Pet_Moe_Property]\r\n                               SET [Attack] = @Attack\r\n                                  ,[Lucky] = @Lucky\r\n                                  ,[Agility] = @Agility\r\n                                  ,[Blood] = @Blood\r\n                                  ,[Defence] = @Defence\r\n                                  ,[Guard] = @Guard\r\n                                  ,[Exp] = @Exp\r\n                            WHERE [Level] = @Level", new SqlParameter[8]
                {
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Lucky", (object) item.Lucky),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Blood", (object) item.Blood),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Guard", (object) item.Guard),
          new SqlParameter("@Exp", (object) item.Exp)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdatePetMoeProperty: " + ex.ToString());
            }
            return flag;
        }

        public bool DeletePetMoeProperty(int level)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Pet_Moe_Property] WHERE [Level] = @Level", new SqlParameter[1]
                {
          new SqlParameter("@Level", (object) level)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeletePetMoeProperty: " + ex.ToString());
            }
            return flag;
        }

        public ActiveInfo[] GetAllActive()
        {
            List<ActiveInfo> activeInfoList = new List<ActiveInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Active] WHERE [ActiveID] > 0");
                while (Sdr.Read())
                    activeInfoList.Add(this.InitActiveInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllActive " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeInfoList.ToArray();
        }

        public ActiveInfo[] GetActiveTemplate()
        {
            List<ActiveInfo> activeInfoList = new List<ActiveInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Active] WHERE [ActiveID] < 0");
                while (Sdr.Read())
                    activeInfoList.Add(this.InitActiveInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllActive " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeInfoList.ToArray();
        }

        public ActiveInfo GetSingleActive(int id)
        {
            List<ActiveInfo> activeInfoList = new List<ActiveInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Active] WHERE [ActiveID] = " + id.ToString());
                while (Sdr.Read())
                    activeInfoList.Add(this.InitActiveInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleActive " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeInfoList.Count > 0 ? activeInfoList[0] : (ActiveInfo)null;
        }

        public ActiveInfo InitActiveInfo(SqlDataReader reader) => new ActiveInfo()
        {
            ActiveID = (int)reader["ActiveID"],
            Title = reader["Title"] == null ? "" : reader["Title"].ToString(),
            Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
            Content = reader["Content"] == null ? "" : reader["Content"].ToString(),
            AwardContent = reader["AwardContent"] == null ? "" : reader["AwardContent"].ToString(),
            HasKey = (int)reader["HasKey"],
            StartDate = (DateTime)reader["StartDate"],
            EndDate = (DateTime)reader["EndDate"],
            IsOnly = (int)reader["IsOnly"],
            Type = (int)reader["Type"],
            ActionTimeContent = reader["ActionTimeContent"] == null ? "" : reader["ActionTimeContent"].ToString(),
            IsAdvance = true,
            GoodsExchangeTypes = "",
            GoodsExchangeNum = "",
            limitType = "",
            limitValue = "",
            IsShow = true,
            ActiveType = 0,
            IconID = 0
        };

        public bool AddActive(ActiveInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Active]\r\n                                   ([ActiveID]\r\n                                   ,[Title]\r\n                                   ,[Description]\r\n                                   ,[Content]\r\n                                   ,[AwardContent]\r\n                                   ,[HasKey]\r\n                                   ,[StartDate]\r\n                                   ,[EndDate]\r\n                                   ,[IsOnly]\r\n                                   ,[Type]\r\n                                   ,[ActionTimeContent])\r\n                               VALUES\r\n                                   (@ActiveID\r\n                                   ,@Title\r\n                                   ,@Description\r\n                                   ,@Content\r\n                                   ,@AwardContent\r\n                                   ,@HasKey\r\n                                   ,@StartDate\r\n                                   ,@EndDate\r\n                                   ,@IsOnly\r\n                                   ,@Type\r\n                                   ,@ActionTimeContent)", new SqlParameter[11]
                {
          new SqlParameter("@ActiveID", (object) item.ActiveID),
          new SqlParameter("@Title", (object) item.Title),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Content", (object) item.Content),
          new SqlParameter("@AwardContent", (object) item.AwardContent),
          new SqlParameter("@HasKey", (object) item.HasKey),
          new SqlParameter("@StartDate", (object) item.StartDate),
          new SqlParameter("@EndDate", (object) item.EndDate),
          new SqlParameter("@IsOnly", (object) item.IsOnly),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@ActionTimeContent", (object) item.ActionTimeContent)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddActive: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateActive(ActiveInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Active]\r\n                               SET [ActiveID] = @ActiveID\r\n                                  ,[Title] = @Title\r\n                                  ,[Description] = @Description\r\n                                  ,[Content] = @Content\r\n                                  ,[AwardContent] = @AwardContent\r\n                                  ,[HasKey] = @HasKey\r\n                                  ,[StartDate] = @StartDate\r\n                                  ,[EndDate] = @EndDate\r\n                                  ,[IsOnly] = @IsOnly\r\n                                  ,[Type] = @Type\r\n                                  ,[ActionTimeContent] = @ActionTimeContent\r\n                           WHERE [ActiveID] = @ActiveID", new SqlParameter[11]
                {
          new SqlParameter("@ActiveID", (object) item.ActiveID),
          new SqlParameter("@Title", (object) item.Title),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Content", (object) item.Content),
          new SqlParameter("@AwardContent", (object) item.AwardContent),
          new SqlParameter("@HasKey", (object) item.HasKey),
          new SqlParameter("@StartDate", (object) item.StartDate),
          new SqlParameter("@EndDate", (object) item.EndDate),
          new SqlParameter("@IsOnly", (object) item.IsOnly),
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@ActionTimeContent", (object) item.ActionTimeContent)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateActive: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteActive(int activeID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Active] WHERE [ActiveID] = @ActiveID", new SqlParameter[1]
                {
          new SqlParameter("@ActiveID", (object) activeID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteActive: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllActive()
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Active]", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteActive: " + ex.ToString());
            }
            return flag;
        }

        public ActiveAwardInfo[] GetAllActiveAward()
        {
            List<ActiveAwardInfo> activeAwardInfoList = new List<ActiveAwardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Active_Award]");
                while (Sdr.Read())
                    activeAwardInfoList.Add(this.InitActiveAwardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllActiveAward " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeAwardInfoList.ToArray();
        }

        public ActiveAwardInfo[] GetAllActiveAwardBy(int activeID)
        {
            List<ActiveAwardInfo> activeAwardInfoList = new List<ActiveAwardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Active_Award] WHERE ActiveID = " + activeID.ToString());
                while (Sdr.Read())
                    activeAwardInfoList.Add(this.InitActiveAwardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllActiveAwardBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeAwardInfoList.ToArray();
        }

        public ActiveAwardInfo GetSingleActiveAward(int id)
        {
            List<ActiveAwardInfo> activeAwardInfoList = new List<ActiveAwardInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Active_Award] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    activeAwardInfoList.Add(this.InitActiveAwardInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleActiveAward " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeAwardInfoList.Count > 0 ? activeAwardInfoList[0] : (ActiveAwardInfo)null;
        }

        public ActiveAwardInfo InitActiveAwardInfo(SqlDataReader reader) => new ActiveAwardInfo()
        {
            ID = (int)reader["ID"],
            ActiveID = (int)reader["ActiveID"],
            ItemID = (int)reader["ItemID"],
            Count = (int)reader["Count"],
            ValidDate = (int)reader["ValidDate"],
            StrengthenLevel = (int)reader["StrengthenLevel"],
            AttackCompose = (int)reader["AttackCompose"],
            DefendCompose = (int)reader["DefendCompose"],
            LuckCompose = (int)reader["LuckCompose"],
            AgilityCompose = (int)reader["AgilityCompose"],
            Gold = (int)reader["Gold"],
            Money = (int)reader["Money"],
            Sex = (int)reader["Sex"],
            Mark = (int)reader["Mark"]
        };

        public bool AddActiveAward(ActiveAwardInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Active_Award]\r\n                                   ([ActiveID]\r\n                                   ,[ItemID]\r\n                                   ,[Count]\r\n                                   ,[ValidDate]\r\n                                   ,[StrengthenLevel]\r\n                                   ,[AttackCompose]\r\n                                   ,[DefendCompose]\r\n                                   ,[LuckCompose]\r\n                                   ,[AgilityCompose]\r\n                                   ,[Gold]\r\n                                   ,[Money]\r\n                                   ,[Sex]\r\n                                   ,[Mark])\r\n                               VALUES\r\n                                   (@ActiveID\r\n                                   ,@ItemID\r\n                                   ,@Count\r\n                                   ,@ValidDate\r\n                                   ,@StrengthenLevel\r\n                                   ,@AttackCompose\r\n                                   ,@DefendCompose\r\n                                   ,@LuckCompose\r\n                                   ,@AgilityCompose\r\n                                   ,@Gold\r\n                                   ,@Money\r\n                                   ,@Sex\r\n                                   ,@Mark)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[14];
                SqlParameters[0] = new SqlParameter("@ID", (object)item.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@ActiveID", (object)item.ActiveID);
                SqlParameters[2] = new SqlParameter("@ItemID", (object)item.ItemID);
                SqlParameters[3] = new SqlParameter("@Count", (object)item.Count);
                SqlParameters[4] = new SqlParameter("@ValidDate", (object)item.ValidDate);
                SqlParameters[5] = new SqlParameter("@StrengthenLevel", (object)item.StrengthenLevel);
                SqlParameters[6] = new SqlParameter("@AttackCompose", (object)item.AttackCompose);
                SqlParameters[7] = new SqlParameter("@DefendCompose", (object)item.DefendCompose);
                SqlParameters[8] = new SqlParameter("@LuckCompose", (object)item.LuckCompose);
                SqlParameters[9] = new SqlParameter("@AgilityCompose", (object)item.AgilityCompose);
                SqlParameters[10] = new SqlParameter("@Gold", (object)item.Gold);
                SqlParameters[11] = new SqlParameter("@Money", (object)item.Money);
                SqlParameters[12] = new SqlParameter("@Sex", (object)item.Sex);
                SqlParameters[13] = new SqlParameter("@Mark", (object)item.Mark);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddActiveAward: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateActiveAward(ActiveAwardInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Active_Award]\r\n                               SET [ActiveID] = @ActiveID\r\n                                  ,[ItemID] = @ItemID\r\n                                  ,[Count] = @Count\r\n                                  ,[ValidDate] = @ValidDate\r\n                                  ,[StrengthenLevel] = @StrengthenLevel\r\n                                  ,[AttackCompose] = @AttackCompose\r\n                                  ,[DefendCompose] = @DefendCompose\r\n                                  ,[LuckCompose] = @LuckCompose\r\n                                  ,[AgilityCompose] = @AgilityCompose\r\n                                  ,[Gold] = @Gold\r\n                                  ,[Money] = @Money\r\n                                  ,[Sex] = @Sex\r\n                                  ,[Mark] = @Mark\r\n                            WHERE [ID] = @ID", new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@ActiveID", (object) item.ActiveID),
          new SqlParameter("@ItemID", (object) item.ItemID),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@Gold", (object) item.Gold),
          new SqlParameter("@Money", (object) item.Money),
          new SqlParameter("@Sex", (object) item.Sex),
          new SqlParameter("@Mark", (object) item.Mark)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateActiveAward: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteActiveAward(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Active_Award]  WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteActiveAward: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllActiveAward(int activeID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Active_Award] WHERE [ActiveID] = @ActiveID", new SqlParameter[1]
                {
          new SqlParameter("@ActiveID", (object) activeID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteActiveAward: " + ex.ToString());
            }
            return flag;
        }

        public ActiveConvertItemInfo[] GetAllActiveConvertItem()
        {
            List<ActiveConvertItemInfo> activeConvertItemInfoList = new List<ActiveConvertItemInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Active_Convert_Item]");
                while (Sdr.Read())
                    activeConvertItemInfoList.Add(this.InitActiveConvertItemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllActiveConvertItem " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeConvertItemInfoList.ToArray();
        }

        public ActiveConvertItemInfo[] GetAllActiveConvertItemBy(int activeID)
        {
            List<ActiveConvertItemInfo> activeConvertItemInfoList = new List<ActiveConvertItemInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Active_Convert_Item] WHERE ActiveID = " + activeID.ToString());
                while (Sdr.Read())
                    activeConvertItemInfoList.Add(this.InitActiveConvertItemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllActiveConvertItemBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeConvertItemInfoList.ToArray();
        }

        public ActiveConvertItemInfo GetSingleActiveConvertItem(int id)
        {
            List<ActiveConvertItemInfo> activeConvertItemInfoList = new List<ActiveConvertItemInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Active_Convert_Item] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    activeConvertItemInfoList.Add(this.InitActiveConvertItemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleActiveConvertItem " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return activeConvertItemInfoList.Count > 0 ? activeConvertItemInfoList[0] : (ActiveConvertItemInfo)null;
        }

        public ActiveConvertItemInfo InitActiveConvertItemInfo(SqlDataReader reader) => new ActiveConvertItemInfo()
        {
            ID = (int)reader["ID"],
            ActiveID = (int)reader["ActiveID"],
            TemplateID = (int)reader["TemplateID"],
            ItemType = (int)reader["ItemType"],
            ItemCount = (int)reader["ItemCount"],
            LimitValue = (int)reader["LimitValue"],
            IsBind = (bool)reader["IsBind"],
            ValidDate = (int)reader["ValidDate"]
        };

        public bool AddActiveConvertItem(ActiveConvertItemInfo item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Active_Convert_Item]\r\n                                   ([ActiveID]\r\n                                   ,[TemplateID]\r\n                                   ,[ItemType]\r\n                                   ,[ItemCount]\r\n                                   ,[LimitValue]\r\n                                   ,[IsBind]\r\n                                   ,[ValidDate])\r\n                               VALUES\r\n                                   (@ActiveID\r\n                                   ,@TemplateID\r\n                                   ,@ItemType\r\n                                   ,@ItemCount\r\n                                   ,@LimitValue\r\n                                   ,@IsBind\r\n                                   ,@ValidDate)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @ID=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[8];
                SqlParameters[0] = new SqlParameter("@ID", (object)item.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@ActiveID", (object)item.ActiveID);
                SqlParameters[2] = new SqlParameter("@TemplateID", (object)item.TemplateID);
                SqlParameters[3] = new SqlParameter("@ItemType", (object)item.ItemType);
                SqlParameters[4] = new SqlParameter("@ItemCount", (object)item.ItemCount);
                SqlParameters[5] = new SqlParameter("@LimitValue", (object)item.LimitValue);
                SqlParameters[6] = new SqlParameter("@IsBind", (object)item.IsBind);
                SqlParameters[7] = new SqlParameter("@ValidDate", (object)item.ValidDate);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddActiveConvertItem: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateActiveConvertItem(ActiveConvertItemInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Active_Convert_Item]\r\n                               SET [ActiveID] = @ActiveID\r\n                                  ,[TemplateID] = @TemplateID\r\n                                  ,[ItemType] = @ItemType\r\n                                  ,[ItemCount] = @ItemCount\r\n                                  ,[LimitValue] = @LimitValue\r\n                                  ,[IsBind] = @IsBind\r\n                                  ,[ValidDate] = @ValidDate\r\n                            WHERE [ID] = @ID", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@ActiveID", (object) item.ActiveID),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@ItemType", (object) item.ItemType),
          new SqlParameter("@ItemCount", (object) item.ItemCount),
          new SqlParameter("@LimitValue", (object) item.LimitValue),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@ValidDate", (object) item.ValidDate)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateActiveConvertItem: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteActiveConvertItem(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Active_Convert_Item] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteActiveConvertItem: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteAllActiveConvertItem(int activeID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Active_Convert_Item] WHERE [ActiveID] = @ActiveID", new SqlParameter[1]
                {
          new SqlParameter("@ActiveID", (object) activeID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteActiveConvertItem: " + ex.ToString());
            }
            return flag;
        }

        public ShopItemInfo[] GetAllShopItem()
        {
            List<ShopItemInfo> shopItemInfoList = new List<ShopItemInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Shop]");
                while (Sdr.Read())
                    shopItemInfoList.Add(this.InitShopItemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllShopItem " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return shopItemInfoList.ToArray();
        }

        public ShopItemInfo[] GetAllShopItemBy(int shopId)
        {
            List<ShopItemInfo> shopItemInfoList = new List<ShopItemInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Shop] WHERE ShopID = " + shopId.ToString());
                while (Sdr.Read())
                    shopItemInfoList.Add(this.InitShopItemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllShopItemBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return shopItemInfoList.ToArray();
        }

        public ShopItemInfo GetSingleShopItem(int id)
        {
            List<ShopItemInfo> shopItemInfoList = new List<ShopItemInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Shop] WHERE ID = " + id.ToString());
                while (Sdr.Read())
                    shopItemInfoList.Add(this.InitShopItemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleShopItem " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return shopItemInfoList.Count > 0 ? shopItemInfoList[0] : (ShopItemInfo)null;
        }

        public ShopItemInfo InitShopItemInfo(SqlDataReader reader)
        {
            ShopItemInfo shopItemInfo = new ShopItemInfo();
            shopItemInfo.ID = int.Parse(reader["ID"].ToString());
            shopItemInfo.ShopID = int.Parse(reader["ShopID"].ToString());
            shopItemInfo.GroupID = int.Parse(reader["GroupID"].ToString());
            shopItemInfo.TemplateID = int.Parse(reader["TemplateID"].ToString());
            ItemTemplateInfo itemTemplate = ItemTemplateMgr.FindItemTemplate(shopItemInfo.TemplateID);
            if (itemTemplate == null)
            {
                shopItemInfo.Name = LanguageMgr.GetTranslation("LoadData.Null");
                shopItemInfo.CategoryID = 11;
            }
            else
            {
                shopItemInfo.Name = itemTemplate.Name;
                shopItemInfo.CategoryID = itemTemplate.CategoryID;
            }
            shopItemInfo.BuyType = int.Parse(reader["BuyType"].ToString());
            shopItemInfo.Label = int.Parse(reader["Label"].ToString());
            shopItemInfo.Beat = Decimal.Parse(reader["Beat"].ToString());
            shopItemInfo.AUnit = int.Parse(reader["AUnit"].ToString());
            shopItemInfo.APrice1 = int.Parse(reader["APrice1"].ToString());
            shopItemInfo.AValue1 = int.Parse(reader["AValue1"].ToString());
            shopItemInfo.APrice2 = int.Parse(reader["APrice2"].ToString());
            shopItemInfo.AValue2 = int.Parse(reader["AValue2"].ToString());
            shopItemInfo.APrice3 = int.Parse(reader["APrice3"].ToString());
            shopItemInfo.AValue3 = int.Parse(reader["AValue3"].ToString());
            shopItemInfo.BUnit = int.Parse(reader["BUnit"].ToString());
            shopItemInfo.BPrice1 = int.Parse(reader["BPrice1"].ToString());
            shopItemInfo.BValue1 = int.Parse(reader["BValue1"].ToString());
            shopItemInfo.BPrice2 = int.Parse(reader["BPrice2"].ToString());
            shopItemInfo.BValue2 = int.Parse(reader["BValue2"].ToString());
            shopItemInfo.BPrice3 = int.Parse(reader["BPrice3"].ToString());
            shopItemInfo.BValue3 = int.Parse(reader["BValue3"].ToString());
            shopItemInfo.CUnit = int.Parse(reader["CUnit"].ToString());
            shopItemInfo.CPrice1 = int.Parse(reader["CPrice1"].ToString());
            shopItemInfo.CValue1 = int.Parse(reader["CValue1"].ToString());
            shopItemInfo.CPrice2 = int.Parse(reader["CPrice2"].ToString());
            shopItemInfo.CValue2 = int.Parse(reader["CValue2"].ToString());
            shopItemInfo.CPrice3 = int.Parse(reader["CPrice3"].ToString());
            shopItemInfo.CValue3 = int.Parse(reader["CValue3"].ToString());
            shopItemInfo.IsContinue = bool.Parse(reader["IsContinue"].ToString());
            shopItemInfo.IsCheap = bool.Parse(reader["IsCheap"].ToString());
            shopItemInfo.LimitCount = int.Parse(reader["LimitCount"].ToString());
            shopItemInfo.StartDate = DateTime.Parse(reader["StartDate"].ToString());
            shopItemInfo.EndDate = DateTime.Parse(reader["EndDate"].ToString());
            shopItemInfo.LimitGrade = int.Parse(reader["LimitGrade"].ToString());
            shopItemInfo.CanBuy = bool.Parse(reader["CanBuy"].ToString());
            shopItemInfo.LimitPersonalCount = 0;
            return shopItemInfo;
        }

        public bool AddShopItem(ShopItemInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Shop]\r\n                                   ([ID]\r\n                                   ,[ShopID]\r\n                                   ,[GroupID]\r\n                                   ,[TemplateID]\r\n                                   ,[BuyType]\r\n                                   ,[IsContinue]\r\n                                   ,[IsBind]\r\n                                   ,[IsVouch]\r\n                                   ,[Label]\r\n                                   ,[Beat]\r\n                                   ,[AUnit]\r\n                                   ,[APrice1]\r\n                                   ,[AValue1]\r\n                                   ,[APrice2]\r\n                                   ,[AValue2]\r\n                                   ,[APrice3]\r\n                                   ,[AValue3]\r\n                                   ,[BUnit]\r\n                                   ,[BPrice1]\r\n                                   ,[BValue1]\r\n                                   ,[BPrice2]\r\n                                   ,[BValue2]\r\n                                   ,[BPrice3]\r\n                                   ,[BValue3]\r\n                                   ,[CUnit]\r\n                                   ,[CPrice1]\r\n                                   ,[CValue1]\r\n                                   ,[CPrice2]\r\n                                   ,[CValue2]\r\n                                   ,[CPrice3]\r\n                                   ,[Sort]\r\n                                   ,[CValue3]\r\n                                   ,[IsCheap]\r\n                                   ,[LimitCount]\r\n                                   ,[StartDate]\r\n                                   ,[EndDate]\r\n                                   ,[LimitGrade]\r\n                                   ,[CanBuy])\r\n                               VALUES\r\n                                   (@ID\r\n                                   ,@ShopID\r\n                                   ,@GroupID\r\n                                   ,@TemplateID\r\n                                   ,@BuyType\r\n                                   ,@IsContinue\r\n                                   ,@IsBind\r\n                                   ,@IsVouch\r\n                                   ,@Label\r\n                                   ,@Beat\r\n                                   ,@AUnit\r\n                                   ,@APrice1\r\n                                   ,@AValue1\r\n                                   ,@APrice2\r\n                                   ,@AValue2\r\n                                   ,@APrice3\r\n                                   ,@AValue3\r\n                                   ,@BUnit\r\n                                   ,@BPrice1\r\n                                   ,@BValue1\r\n                                   ,@BPrice2\r\n                                   ,@BValue2\r\n                                   ,@BPrice3\r\n                                   ,@BValue3\r\n                                   ,@CUnit\r\n                                   ,@CPrice1\r\n                                   ,@CValue1\r\n                                   ,@CPrice2\r\n                                   ,@CValue2\r\n                                   ,@CPrice3\r\n                                   ,@Sort\r\n                                   ,@CValue3\r\n                                   ,@IsCheap\r\n                                   ,@LimitCount\r\n                                   ,@StartDate\r\n                                   ,@EndDate\r\n                                   ,@LimitGrade\r\n                                   ,@CanBuy)", new SqlParameter[38]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@ShopID", (object) item.ShopID),
          new SqlParameter("@GroupID", (object) item.GroupID),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@BuyType", (object) item.BuyType),
          new SqlParameter("@IsContinue", (object) item.IsContinue),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@IsVouch", (object) "1"),
          new SqlParameter("@Label", (object) item.Label),
          new SqlParameter("@Beat", (object) item.Beat),
          new SqlParameter("@AUnit", (object) item.AUnit),
          new SqlParameter("@APrice1", (object) item.APrice1),
          new SqlParameter("@AValue1", (object) item.AValue1),
          new SqlParameter("@APrice2", (object) item.APrice2),
          new SqlParameter("@AValue2", (object) item.AValue2),
          new SqlParameter("@APrice3", (object) item.APrice3),
          new SqlParameter("@AValue3", (object) item.AValue3),
          new SqlParameter("@BUnit", (object) item.BUnit),
          new SqlParameter("@BPrice1", (object) item.BPrice1),
          new SqlParameter("@BValue1", (object) item.BValue1),
          new SqlParameter("@BPrice2", (object) item.BPrice2),
          new SqlParameter("@BValue2", (object) item.BValue2),
          new SqlParameter("@BPrice3", (object) item.BPrice3),
          new SqlParameter("@BValue3", (object) item.BValue3),
          new SqlParameter("@CUnit", (object) item.CUnit),
          new SqlParameter("@CPrice1", (object) item.CPrice1),
          new SqlParameter("@CValue1", (object) item.CValue1),
          new SqlParameter("@CPrice2", (object) item.CPrice2),
          new SqlParameter("@CValue2", (object) item.CValue2),
          new SqlParameter("@CPrice3", (object) item.CPrice3),
          new SqlParameter("@Sort", (object) "0"),
          new SqlParameter("@CValue3", (object) item.CValue3),
          new SqlParameter("@IsCheap", (object) item.IsCheap),
          new SqlParameter("@LimitCount", (object) item.LimitCount),
          new SqlParameter("@StartDate", (object) item.StartDate),
          new SqlParameter("@EndDate", (object) item.EndDate),
          new SqlParameter("@LimitGrade", (object) item.LimitGrade),
          new SqlParameter("@CanBuy", (object) item.CanBuy)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddShopItem: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateShopItem(ShopItemInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Shop]\r\n                               SET [ShopID] = @ShopID\r\n                                  ,[GroupID] = @GroupID\r\n                                  ,[TemplateID] = @TemplateID\r\n                                  ,[BuyType] = @BuyType\r\n                                  ,[IsContinue] = @IsContinue\r\n                                  ,[IsBind] = @IsBind\r\n                                  ,[IsVouch] = @IsVouch\r\n                                  ,[Label] = @Label\r\n                                  ,[Beat] = @Beat\r\n                                  ,[AUnit] = @AUnit\r\n                                  ,[APrice1] = @APrice1\r\n                                  ,[AValue1] = @AValue1\r\n                                  ,[APrice2] = @APrice2\r\n                                  ,[AValue2] = @AValue2\r\n                                  ,[APrice3] = @APrice3\r\n                                  ,[AValue3] = @AValue3\r\n                                  ,[BUnit] = @BUnit\r\n                                  ,[BPrice1] = @BPrice1\r\n                                  ,[BValue1] = @BValue1\r\n                                  ,[BPrice2] = @BPrice2\r\n                                  ,[BValue2] = @BValue2\r\n                                  ,[BPrice3] = @BPrice3\r\n                                  ,[BValue3] = @BValue3\r\n                                  ,[CUnit] = @CUnit\r\n                                  ,[CPrice1] = @CPrice1\r\n                                  ,[CValue1] = @CValue1\r\n                                  ,[CPrice2] = @CPrice2\r\n                                  ,[CValue2] = @CValue2\r\n                                  ,[CPrice3] = @CPrice3\r\n                                  ,[Sort] = @Sort\r\n                                  ,[CValue3] = @CValue3\r\n                                  ,[IsCheap] = @IsCheap\r\n                                  ,[LimitCount] = @LimitCount\r\n                                  ,[StartDate] = @StartDate\r\n                                  ,[EndDate] = @EndDate\r\n                                  ,[LimitGrade] = @LimitGrade\r\n                                  ,[CanBuy] = @CanBuy\r\n                           WHERE [ID] = @ID", new SqlParameter[38]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@ShopID", (object) item.ShopID),
          new SqlParameter("@GroupID", (object) item.GroupID),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@BuyType", (object) item.BuyType),
          new SqlParameter("@IsContinue", (object) item.IsContinue),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@IsVouch", (object) "1"),
          new SqlParameter("@Label", (object) item.Label),
          new SqlParameter("@Beat", (object) item.Beat),
          new SqlParameter("@AUnit", (object) item.AUnit),
          new SqlParameter("@APrice1", (object) item.APrice1),
          new SqlParameter("@AValue1", (object) item.AValue1),
          new SqlParameter("@APrice2", (object) item.APrice2),
          new SqlParameter("@AValue2", (object) item.AValue2),
          new SqlParameter("@APrice3", (object) item.APrice3),
          new SqlParameter("@AValue3", (object) item.AValue3),
          new SqlParameter("@BUnit", (object) item.BUnit),
          new SqlParameter("@BPrice1", (object) item.BPrice1),
          new SqlParameter("@BValue1", (object) item.BValue1),
          new SqlParameter("@BPrice2", (object) item.BPrice2),
          new SqlParameter("@BValue2", (object) item.BValue2),
          new SqlParameter("@BPrice3", (object) item.BPrice3),
          new SqlParameter("@BValue3", (object) item.BValue3),
          new SqlParameter("@CUnit", (object) item.CUnit),
          new SqlParameter("@CPrice1", (object) item.CPrice1),
          new SqlParameter("@CValue1", (object) item.CValue1),
          new SqlParameter("@CPrice2", (object) item.CPrice2),
          new SqlParameter("@CValue2", (object) item.CValue2),
          new SqlParameter("@CPrice3", (object) item.CPrice3),
          new SqlParameter("@Sort", (object) "0"),
          new SqlParameter("@CValue3", (object) item.CValue3),
          new SqlParameter("@IsCheap", (object) item.IsCheap),
          new SqlParameter("@LimitCount", (object) item.LimitCount),
          new SqlParameter("@StartDate", (object) item.StartDate),
          new SqlParameter("@EndDate", (object) item.EndDate),
          new SqlParameter("@LimitGrade", (object) item.LimitGrade),
          new SqlParameter("@CanBuy", (object) item.CanBuy)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateShopItem: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteShopItem(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Shop] WHERE [ID] = @ID", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteShopItem: " + ex.ToString());
            }
            return flag;
        }

        public ShopGoodsShowListInfo[] GetAllShopGoodsShowList()
        {
            List<ShopGoodsShowListInfo> goodsShowListInfoList = new List<ShopGoodsShowListInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[ShopGoodsShowList] ORDER BY [Type]");
                while (Sdr.Read())
                    goodsShowListInfoList.Add(this.InitShopGoodsShowListInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllShopGoodsShowList " + ex.ToString());
            }
            finally
            {
                if ((Sdr == null ? 0 : (!Sdr.IsClosed ? 1 : 0)) != 0)
                    Sdr.Close();
            }
            return goodsShowListInfoList.ToArray();
        }

        public ShopGoodsShowListInfo[] GetAllShopGoodsShowListBy(int type)
        {
            List<ShopGoodsShowListInfo> goodsShowListInfoList = new List<ShopGoodsShowListInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[ShopGoodsShowList] WHERE [Type] = " + type.ToString());
                while (Sdr.Read())
                    goodsShowListInfoList.Add(this.InitShopGoodsShowListInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllShopGoodsShowListBy " + ex.ToString());
            }
            finally
            {
                if ((Sdr == null ? 0 : (!Sdr.IsClosed ? 1 : 0)) != 0)
                    Sdr.Close();
            }
            return goodsShowListInfoList.ToArray();
        }

        public ShopGoodsShowListInfo GetSingleShopGoodsShowList(
          int type,
          int shopId)
        {
            List<ShopGoodsShowListInfo> goodsShowListInfoList = new List<ShopGoodsShowListInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[ShopGoodsShowList] WHERE [Type] =" + type.ToString() + " AND [ShopId] = " + shopId.ToString());
                while (Sdr.Read())
                    goodsShowListInfoList.Add(this.InitShopGoodsShowListInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleShopGoodsShowList " + ex.ToString());
            }
            finally
            {
                if ((Sdr == null ? 0 : (!Sdr.IsClosed ? 1 : 0)) != 0)
                    Sdr.Close();
            }
            return goodsShowListInfoList.Count <= 0 ? (ShopGoodsShowListInfo)null : goodsShowListInfoList[0];
        }

        public ShopGoodsShowListInfo InitShopGoodsShowListInfo(SqlDataReader reader) => new ShopGoodsShowListInfo()
        {
            Type = (int)reader["Type"],
            ShopId = (int)reader["ShopId"]
        };

        public bool AddShopGoodsShowList(ShopGoodsShowListInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[ShopGoodsShowList]\r\n                                   ([Type]\r\n                                   ,[ShopId])\r\n                               VALUES\r\n                                   (@Type\r\n                                   ,@ShopId)", new SqlParameter[2]
                {
          new SqlParameter("@Type", (object) item.Type),
          new SqlParameter("@ShopId", (object) item.ShopId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddShopGoodsShowList: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteShopGoodsShowList(int type, int shopId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[ShopGoodsShowList] WHERE [Type] = @Type AND [ShopId] = @ShopId", new SqlParameter[2]
                {
          new SqlParameter("@Type", (object) type),
          new SqlParameter("@ShopId", (object) shopId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteShopGoodsShowList: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteShopGoodsShowList(int type)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[ShopGoodsShowList] WHERE [Type] = @Type", new SqlParameter[1]
                {
          new SqlParameter("@Type", (object) type)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteShopGoodsShowList: " + ex.ToString());
            }
            return flag;
        }

        public MissionInfo[] GetAllMission()
        {
            List<MissionInfo> missionInfoList = new List<MissionInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mission_Info]");
                while (Sdr.Read())
                    missionInfoList.Add(this.InitMissionInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllMission " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return missionInfoList.ToArray();
        }

        public MissionInfo GetSingleMission(int id)
        {
            List<MissionInfo> missionInfoList = new List<MissionInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Mission_Info] WHERE Id = " + id.ToString());
                while (Sdr.Read())
                    missionInfoList.Add(this.InitMissionInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSingleMission " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return missionInfoList.Count > 0 ? missionInfoList[0] : (MissionInfo)null;
        }

        public MissionInfo InitMissionInfo(SqlDataReader reader) => new MissionInfo()
        {
            Id = (int)reader["Id"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            TotalCount = (int)reader["TotalCount"],
            TotalTurn = (int)reader["TotalTurn"],
            Script = reader["Script"] == null ? "" : reader["Script"].ToString(),
            Success = reader["Success"] == null ? "" : reader["Success"].ToString(),
            Failure = reader["Failure"] == null ? "" : reader["Failure"].ToString(),
            Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
            IncrementDelay = (int)reader["IncrementDelay"],
            Delay = (int)reader["Delay"],
            Title = reader["Title"] == null ? "" : reader["Title"].ToString(),
            Param1 = (int)reader["Param1"],
            Param2 = (int)reader["Param2"]
        };

        public DropCondiction[] GetAllDropCondiction()
        {
            List<DropCondiction> dropCondictionList = new List<DropCondiction>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Drop_Condiction] ORDER BY [DropID]");
                while (Sdr.Read())
                    dropCondictionList.Add(this.InitDropCondictionInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllDropCondiction " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return dropCondictionList.ToArray();
        }

        public DropCondiction GetSingleDropCondiction(int id)
        {
            List<DropCondiction> dropCondictionList = new List<DropCondiction>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Drop_Condiction] WHERE DropID = " + id.ToString());
                while (Sdr.Read())
                    dropCondictionList.Add(this.InitDropCondictionInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSigleDropCondiction " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return dropCondictionList.Count > 0 ? dropCondictionList[0] : (DropCondiction)null;
        }

        public DropCondiction InitDropCondictionInfo(SqlDataReader reader) => new DropCondiction()
        {
            DropId = (int)reader["DropID"],
            CondictionType = (int)reader["CondictionType"],
            Para1 = reader["Para1"] == null ? "" : reader["Para1"].ToString(),
            Para2 = reader["Para2"] == null ? "" : reader["Para2"].ToString(),
            Name = "",
            Detail = reader["Detail"] == null ? "" : reader["Detail"].ToString()
        };

        public bool AddDropCondiction(DropCondiction item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Drop_Condiction]\r\n                                   ([DropID]\r\n                                   ,[CondictionType]\r\n                                   ,[Para1]\r\n                                   ,[Para2])\r\n                               VALUES\r\n                                   (@DropID\r\n                                   ,@CondictionType\r\n                                   ,@Para1\r\n                                   ,@Para2\r\n)", new SqlParameter[4]
                {
          new SqlParameter("@DropID", (object) item.DropId),
          new SqlParameter("@CondictionType", (object) item.CondictionType),
          new SqlParameter("@Para1", (object) item.Para1),
          new SqlParameter("@Para2", (object) item.Para2)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddDropCondiction: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateDropCondiction(DropCondiction item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Drop_Condiction]\r\n                               SET [DropID] = @DropID\r\n                                  ,[CondictionType] = @CondictionType\r\n                                  ,[Para1] = @Para1\r\n                                  ,[Para2] = @Para2\r\n                            WHERE [DropID] = @DropID", new SqlParameter[4]
                {
          new SqlParameter("@DropID", (object) item.DropId),
          new SqlParameter("@CondictionType", (object) item.CondictionType),
          new SqlParameter("@Para1", (object) item.Para1),
          new SqlParameter("@Para2", (object) item.Para2)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateDropCondiction: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteDropCondiction(int dropID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Drop_Condiction] WHERE [DropID] = @DropID", new SqlParameter[1]
                {
          new SqlParameter("@DropID", (object) dropID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteDropCondiction: " + ex.ToString());
            }
            return flag;
        }

        public DropItem[] GetAllDropItem()
        {
            List<DropItem> dropItemList = new List<DropItem>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Drop_Item]");
                while (Sdr.Read())
                    dropItemList.Add(this.InitDropItemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllDropItem " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return dropItemList.ToArray();
        }

        public DropItem[] GetAllDropItemBy(int dropId)
        {
            List<DropItem> dropItemList = new List<DropItem>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Drop_Item] WHERE DropId = " + dropId.ToString());
                while (Sdr.Read())
                    dropItemList.Add(this.InitDropItemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllDropItemBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return dropItemList.ToArray();
        }

        public DropItem GetSingleDropItem(int id)
        {
            List<DropItem> dropItemList = new List<DropItem>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Drop_Item] WHERE Id = " + id.ToString());
                while (Sdr.Read())
                    dropItemList.Add(this.InitDropItemInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSigleDropItem " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return dropItemList.Count > 0 ? dropItemList[0] : (DropItem)null;
        }

        public DropItem InitDropItemInfo(SqlDataReader reader) => new DropItem()
        {
            Id = (int)reader["Id"],
            DropId = (int)reader["DropId"],
            ItemId = (int)reader["ItemId"],
            ValueDate = (int)reader["ValueDate"],
            IsBind = (bool)reader["IsBind"],
            Random = (int)reader["Random"],
            BeginData = (int)reader["BeginData"],
            EndData = (int)reader["EndData"],
            IsTips = (bool)reader["IsTips"],
            IsLogs = (bool)reader["IsLogs"]
        };

        public bool AddDropItem(DropItem item)
        {
            bool flag = false;
            try
            {
                string Sqlcomm = "INSERT INTO [dbo].[Drop_Item]\r\n                                   ([DropId]\r\n                                   ,[ItemId]\r\n                                   ,[ValueDate]\r\n                                   ,[IsBind]\r\n                                   ,[Random]\r\n                                   ,[BeginData]\r\n                                   ,[EndData]\r\n                                   ,[IsTips]\r\n                                   ,[IsLogs])\r\n                               VALUES\r\n                                   (@DropId\r\n                                   ,@ItemId\r\n                                   ,@ValueDate\r\n                                   ,@IsBind\r\n                                   ,@Random\r\n                                   ,@BeginData\r\n                                   ,@EndData\r\n                                   ,@IsTips\r\n                                   ,@IsLogs)\r\n                            SELECT @@IDENTITY AS 'IDENTITY'\r\n                            SET @Id=@@IDENTITY";
                SqlParameter[] SqlParameters = new SqlParameter[10];
                SqlParameters[0] = new SqlParameter("@Id", (object)item.Id);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@DropId", (object)item.DropId);
                SqlParameters[2] = new SqlParameter("@ItemId", (object)item.ItemId);
                SqlParameters[3] = new SqlParameter("@ValueDate", (object)item.ValueDate);
                SqlParameters[4] = new SqlParameter("@IsBind", (object)item.IsBind);
                SqlParameters[5] = new SqlParameter("@Random", (object)item.Random);
                SqlParameters[6] = new SqlParameter("@BeginData", (object)item.BeginData);
                SqlParameters[7] = new SqlParameter("@EndData", (object)item.EndData);
                SqlParameters[8] = new SqlParameter("@IsTips", (object)item.IsTips);
                SqlParameters[9] = new SqlParameter("@IsLogs", (object)item.IsLogs);
                flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
                item.Id = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                Logger.Error("AddDropItem: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateDropItem(DropItem item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Drop_Item]\r\n                               SET [DropId] = @DropId\r\n                                  ,[ItemId] = @ItemId\r\n                                  ,[ValueDate] = @ValueDate\r\n                                  ,[IsBind] = @IsBind\r\n                                  ,[Random] = @Random\r\n                                  ,[BeginData] = @BeginData\r\n                                  ,[EndData] = @EndData\r\n                                  ,[IsTips] = @IsTips\r\n                                  ,[IsLogs] = @IsLogs\r\n                            WHERE [Id] = @Id", new SqlParameter[10]
                {
          new SqlParameter("@Id", (object) item.Id),
          new SqlParameter("@DropId", (object) item.DropId),
          new SqlParameter("@ItemId", (object) item.ItemId),
          new SqlParameter("@ValueDate", (object) item.ValueDate),
          new SqlParameter("@IsBind", (object) item.IsBind),
          new SqlParameter("@Random", (object) item.Random),
          new SqlParameter("@BeginData", (object) item.BeginData),
          new SqlParameter("@EndData", (object) item.EndData),
          new SqlParameter("@IsTips", (object) item.IsTips),
          new SqlParameter("@IsLogs", (object) item.IsLogs)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateDropItem: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteDropItem(int id)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Drop_Item] WHERE [Id] = @Id", new SqlParameter[1]
                {
          new SqlParameter("@Id", (object) id)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteDropItem: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteDropItemBy(int dropId)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Drop_Item] WHERE [DropId] = @DropId", new SqlParameter[1]
                {
          new SqlParameter("@DropId", (object) dropId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteDropItem: " + ex.ToString());
            }
            return flag;
        }

        public RuneTemplateInfo[] GetAllRuneTemplate()
        {
            List<RuneTemplateInfo> runeTemplateInfoList = new List<RuneTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Rune_Template]");
                while (Sdr.Read())
                    runeTemplateInfoList.Add(this.InitRuneTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllRuneTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return runeTemplateInfoList.ToArray();
        }

        public RuneTemplateInfo GetSingleRuneTemplate(int templateID)
        {
            List<RuneTemplateInfo> runeTemplateInfoList = new List<RuneTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Rune_Template] WHERE TemplateID = " + templateID.ToString());
                while (Sdr.Read())
                    runeTemplateInfoList.Add(this.InitRuneTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSigleRuneTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return runeTemplateInfoList.Count > 0 ? runeTemplateInfoList[0] : (RuneTemplateInfo)null;
        }

        public RuneTemplateInfo InitRuneTemplateInfo(SqlDataReader reader) => new RuneTemplateInfo()
        {
            TemplateID = (int)reader["TemplateID"],
            NextTemplateID = (int)reader["NextTemplateID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            BaseLevel = (int)reader["BaseLevel"],
            MaxLevel = (int)reader["MaxLevel"],
            Type1 = (int)reader["Type1"],
            Attribute1 = reader["Attribute1"] == null ? "" : reader["Attribute1"].ToString(),
            Turn1 = (int)reader["Turn1"],
            Rate1 = (int)reader["Rate1"],
            Type2 = (int)reader["Type2"],
            Attribute2 = reader["Attribute2"] == null ? "" : reader["Attribute2"].ToString(),
            Turn2 = (int)reader["Turn2"],
            Rate2 = (int)reader["Rate2"],
            Type3 = (int)reader["Type3"],
            Attribute3 = reader["Attribute3"] == null ? "" : reader["Attribute3"].ToString(),
            Turn3 = (int)reader["Turn3"],
            Rate3 = (int)reader["Rate3"]
        };

        public bool AddRuneTemplate(RuneTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Rune_Template]\r\n                                   ([TemplateID]\r\n                                   ,[NextTemplateID]\r\n                                   ,[Name]\r\n                                   ,[BaseLevel]\r\n                                   ,[MaxLevel]\r\n                                   ,[Type1]\r\n                                   ,[Attribute1]\r\n                                   ,[Turn1]\r\n                                   ,[Rate1]\r\n                                   ,[Type2]\r\n                                   ,[Attribute2]\r\n                                   ,[Turn2]\r\n                                   ,[Rate2]\r\n                                   ,[Type3]\r\n                                   ,[Attribute3]\r\n                                   ,[Turn3]\r\n                                   ,[Rate3])\r\n                               VALUES\r\n                                   (@TemplateID\r\n                                   ,@NextTemplateID\r\n                                   ,@Name\r\n                                   ,@BaseLevel\r\n                                   ,@MaxLevel\r\n                                   ,@Type1\r\n                                   ,@Attribute1\r\n                                   ,@Turn1\r\n                                   ,@Rate1\r\n                                   ,@Type2\r\n                                   ,@Attribute2\r\n                                   ,@Turn2\r\n                                   ,@Rate2\r\n                                   ,@Type3\r\n                                   ,@Attribute3\r\n                                   ,@Turn3\r\n                                   ,@Rate3)", new SqlParameter[17]
                {
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@NextTemplateID", (object) item.NextTemplateID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@BaseLevel", (object) item.BaseLevel),
          new SqlParameter("@MaxLevel", (object) item.MaxLevel),
          new SqlParameter("@Type1", (object) item.Type1),
          new SqlParameter("@Attribute1", (object) item.Attribute1),
          new SqlParameter("@Turn1", (object) item.Turn1),
          new SqlParameter("@Rate1", (object) item.Rate1),
          new SqlParameter("@Type2", (object) item.Type2),
          new SqlParameter("@Attribute2", (object) item.Attribute2),
          new SqlParameter("@Turn2", (object) item.Turn2),
          new SqlParameter("@Rate2", (object) item.Rate2),
          new SqlParameter("@Type3", (object) item.Type3),
          new SqlParameter("@Attribute3", (object) item.Attribute3),
          new SqlParameter("@Turn3", (object) item.Turn3),
          new SqlParameter("@Rate3", (object) item.Rate3)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddRuneTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateRuneTemplate(RuneTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Rune_Template]\r\n                               SET [TemplateID] = @TemplateID\r\n                                  ,[NextTemplateID] = @NextTemplateID\r\n                                  ,[Name] = @Name\r\n                                  ,[BaseLevel] = @BaseLevel\r\n                                  ,[MaxLevel] = @MaxLevel\r\n                                  ,[Type1] = @Type1\r\n                                  ,[Attribute1] = @Attribute1\r\n                                  ,[Turn1] = @Turn1\r\n                                  ,[Rate1] = @Rate1\r\n                                  ,[Type2] = @Type2\r\n                                  ,[Attribute2] = @Attribute2\r\n                                  ,[Turn2] = @Turn2\r\n                                  ,[Rate2] = @Rate2\r\n                                  ,[Type3] = @Type3\r\n                                  ,[Attribute3] = @Attribute3\r\n                                  ,[Turn3] = @Turn3\r\n                                  ,[Rate3] = @Rate3\r\n                            WHERE [TemplateID] = @TemplateID", new SqlParameter[17]
                {
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@NextTemplateID", (object) item.NextTemplateID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@BaseLevel", (object) item.BaseLevel),
          new SqlParameter("@MaxLevel", (object) item.MaxLevel),
          new SqlParameter("@Type1", (object) item.Type1),
          new SqlParameter("@Attribute1", (object) item.Attribute1),
          new SqlParameter("@Turn1", (object) item.Turn1),
          new SqlParameter("@Rate1", (object) item.Rate1),
          new SqlParameter("@Type2", (object) item.Type2),
          new SqlParameter("@Attribute2", (object) item.Attribute2),
          new SqlParameter("@Turn2", (object) item.Turn2),
          new SqlParameter("@Rate2", (object) item.Rate2),
          new SqlParameter("@Type3", (object) item.Type3),
          new SqlParameter("@Attribute3", (object) item.Attribute3),
          new SqlParameter("@Turn3", (object) item.Turn3),
          new SqlParameter("@Rate3", (object) item.Rate3)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateRuneTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteRuneTemplate(int templateID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Rune_Template] WHERE [TemplateID] = @TemplateID", new SqlParameter[1]
                {
          new SqlParameter("@TemplateID", (object) templateID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteRuneTemplate: " + ex.ToString());
            }
            return flag;
        }

        public ItemTemplateInfo[] GetAllItemTemplate()
        {
            List<ItemTemplateInfo> itemTemplateInfoList = new List<ItemTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Shop_Goods]");
                while (Sdr.Read())
                    itemTemplateInfoList.Add(this.InitItemTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllItemTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemTemplateInfoList.ToArray();
        }

        public ItemTemplateInfo[] GetAllItemTemplateBy(int categoryID)
        {
            List<ItemTemplateInfo> itemTemplateInfoList = new List<ItemTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Shop_Goods] WHERE CategoryID = " + categoryID.ToString());
                while (Sdr.Read())
                    itemTemplateInfoList.Add(this.InitItemTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetAllItemTemplateBy " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemTemplateInfoList.ToArray();
        }

        public ItemTemplateInfo GetSingleItemTemplate(int templateID)
        {
            List<ItemTemplateInfo> itemTemplateInfoList = new List<ItemTemplateInfo>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT * FROM [dbo].[Shop_Goods] WHERE TemplateID = " + templateID.ToString());
                while (Sdr.Read())
                    itemTemplateInfoList.Add(this.InitItemTemplateInfo(Sdr));
            }
            catch (Exception ex)
            {
                Logger.Error("GetSigleItemTemplate " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return itemTemplateInfoList.Count > 0 ? itemTemplateInfoList[0] : (ItemTemplateInfo)null;
        }

        public ItemTemplateInfo InitItemTemplateInfo(SqlDataReader reader) => new ItemTemplateInfo()
        {
            TemplateID = (int)reader["TemplateID"],
            Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
            CategoryID = (int)reader["CategoryID"],
            Description = reader["Description"] == null ? "" : reader["Description"].ToString(),
            Attack = (int)reader["Attack"],
            Defence = (int)reader["Defence"],
            Agility = (int)reader["Agility"],
            Luck = (int)reader["Luck"],
            Level = (int)reader["Level"],
            Quality = (int)reader["Quality"],
            Pic = reader["Pic"] == null ? "" : reader["Pic"].ToString(),
            MaxCount = (int)reader["MaxCount"],
            NeedSex = (int)reader["NeedSex"],
            NeedLevel = (int)reader["NeedLevel"],
            CanStrengthen = (bool)reader["CanStrengthen"],
            CanCompose = (bool)reader["CanCompose"],
            CanDrop = (bool)reader["CanDrop"],
            CanEquip = (bool)reader["CanEquip"],
            CanUse = (bool)reader["CanUse"],
            CanDelete = (bool)reader["CanDelete"],
            Script = reader["Script"] == null ? "" : reader["Script"].ToString(),
            Data = reader["Data"] == null ? "" : reader["Data"].ToString(),
            Colors = reader["Colors"] == null ? "" : reader["Colors"].ToString(),
            Property1 = (int)reader["Property1"],
            Property2 = (int)reader["Property2"],
            Property3 = (int)reader["Property3"],
            Property4 = (int)reader["Property4"],
            Property5 = (int)reader["Property5"],
            Property6 = (int)reader["Property6"],
            Property7 = (int)reader["Property7"],
            Property8 = (int)reader["Property8"],
            AddTime = reader["AddTime"] == null ? "" : reader["AddTime"].ToString(),
            BindType = (int)reader["BindType"],
            FusionType = (int)reader["FusionType"],
            FusionRate = (int)reader["FusionRate"],
            FusionNeedRate = (int)reader["FusionNeedRate"],
            Hole = reader["Hole"] == null ? "" : reader["Hole"].ToString(),
            RefineryLevel = (int)reader["RefineryLevel"],
            ReclaimValue = (int)reader["ReclaimValue"],
            ReclaimType = (int)reader["ReclaimType"],
            CanRecycle = (int)reader["CanRecycle"],
            FloorPrice = 0,
            SuitId = (int)reader["SuitId"],
            CanTransfer = 0
        };

        public bool AddItemTemplate(ItemTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("INSERT INTO [dbo].[Shop_Goods]\r\n                                   ([TemplateID]\r\n                                   ,[Name]\r\n                                   ,[Remark]\r\n                                   ,[CategoryID]\r\n                                   ,[Description]\r\n                                   ,[Attack]\r\n                                   ,[Defence]\r\n                                   ,[Agility]\r\n                                   ,[Luck]\r\n                                   ,[Level]\r\n                                   ,[Quality]\r\n                                   ,[Pic]\r\n                                   ,[MaxCount]\r\n                                   ,[NeedSex]\r\n                                   ,[NeedLevel]\r\n                                   ,[CanStrengthen]\r\n                                   ,[CanCompose]\r\n                                   ,[CanDrop]\r\n                                   ,[CanEquip]\r\n                                   ,[CanUse]\r\n                                   ,[CanDelete]\r\n                                   ,[Script]\r\n                                   ,[Data]\r\n                                   ,[Colors]\r\n                                   ,[Property1]\r\n                                   ,[Property2]\r\n                                   ,[Property3]\r\n                                   ,[Property4]\r\n                                   ,[Property5]\r\n                                   ,[Property6]\r\n                                   ,[Property7]\r\n                                   ,[Property8]\r\n                                   ,[Valid]\r\n                                   ,[Count]\r\n                                   ,[AddTime]\r\n                                   ,[BindType]\r\n                                   ,[FusionType]\r\n                                   ,[FusionRate]\r\n                                   ,[FusionNeedRate]\r\n                                   ,[Hole]\r\n                                   ,[RefineryLevel]\r\n                                   ,[ReclaimValue]\r\n                                   ,[ReclaimType]\r\n                                   ,[CanRecycle]\r\n                                   ,[FloorPrice]\r\n                                   ,[SuitId]\r\n                                   )\r\n                               VALUES\r\n                                   (@TemplateID\r\n                                   ,@Name\r\n                                   ,@Remark\r\n                                   ,@CategoryID\r\n                                   ,@Description\r\n                                   ,@Attack\r\n                                   ,@Defence\r\n                                   ,@Agility\r\n                                   ,@Luck\r\n                                   ,@Level\r\n                                   ,@Quality\r\n                                   ,@Pic\r\n                                   ,@MaxCount\r\n                                   ,@NeedSex\r\n                                   ,@NeedLevel\r\n                                   ,@CanStrengthen\r\n                                   ,@CanCompose\r\n                                   ,@CanDrop\r\n                                   ,@CanEquip\r\n                                   ,@CanUse\r\n                                   ,@CanDelete\r\n                                   ,@Script\r\n                                   ,@Data\r\n                                   ,@Colors\r\n                                   ,@Property1\r\n                                   ,@Property2\r\n                                   ,@Property3\r\n                                   ,@Property4\r\n                                   ,@Property5\r\n                                   ,@Property6\r\n                                   ,@Property7\r\n                                   ,@Property8\r\n                                   ,@Valid\r\n                                   ,@Count\r\n                                   ,@AddTime\r\n                                   ,@BindType\r\n                                   ,@FusionType\r\n                                   ,@FusionRate\r\n                                   ,@FusionNeedRate\r\n                                   ,@Hole\r\n                                   ,@RefineryLevel\r\n                                   ,@ReclaimValue\r\n                                   ,@ReclaimType\r\n                                   ,@CanRecycle\r\n                                   ,@FloorPrice\r\n                                   ,@SuitId\r\n                                  )", new SqlParameter[46]
                {
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Remark", (object) ""),
          new SqlParameter("@CategoryID", (object) item.CategoryID),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Luck", (object) item.Luck),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Quality", (object) item.Quality),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@MaxCount", (object) item.MaxCount),
          new SqlParameter("@NeedSex", (object) item.NeedSex),
          new SqlParameter("@NeedLevel", (object) item.NeedLevel),
          new SqlParameter("@CanStrengthen", (object) item.CanStrengthen),
          new SqlParameter("@CanCompose", (object) item.CanCompose),
          new SqlParameter("@CanDrop", (object) item.CanDrop),
          new SqlParameter("@CanEquip", (object) item.CanEquip),
          new SqlParameter("@CanUse", (object) item.CanUse),
          new SqlParameter("@CanDelete", (object) item.CanDelete),
          new SqlParameter("@Script", (object) item.Script),
          new SqlParameter("@Data", (object) item.Data),
          new SqlParameter("@Colors", (object) item.Colors),
          new SqlParameter("@Property1", (object) item.Property1),
          new SqlParameter("@Property2", (object) item.Property2),
          new SqlParameter("@Property3", (object) item.Property3),
          new SqlParameter("@Property4", (object) item.Property4),
          new SqlParameter("@Property5", (object) item.Property5),
          new SqlParameter("@Property6", (object) item.Property6),
          new SqlParameter("@Property7", (object) item.Property7),
          new SqlParameter("@Property8", (object) item.Property8),
          new SqlParameter("@Valid", (object) "0"),
          new SqlParameter("@Count", (object) "1"),
          new SqlParameter("@AddTime", (object) item.AddTime),
          new SqlParameter("@BindType", (object) item.BindType),
          new SqlParameter("@FusionType", (object) item.FusionType),
          new SqlParameter("@FusionRate", (object) item.FusionRate),
          new SqlParameter("@FusionNeedRate", (object) item.FusionNeedRate),
          new SqlParameter("@Hole", (object) item.Hole),
          new SqlParameter("@RefineryLevel", (object) item.RefineryLevel),
          new SqlParameter("@ReclaimValue", (object) item.ReclaimValue),
          new SqlParameter("@ReclaimType", (object) item.ReclaimType),
          new SqlParameter("@CanRecycle", (object) item.CanRecycle),
          new SqlParameter("@FloorPrice", (object) item.FloorPrice),
          new SqlParameter("@SuitId", (object) item.SuitId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("AddItemTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool UpdateItemTemplate(ItemTemplateInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("UPDATE [dbo].[Shop_Goods]\r\n                               SET [TemplateID] = @TemplateID\r\n                                  ,[Name] = @Name\r\n                                  ,[Remark] = @Remark\r\n                                  ,[CategoryID] = @CategoryID\r\n                                  ,[Description] = @Description\r\n                                  ,[Attack] = @Attack\r\n                                  ,[Defence] = @Defence\r\n                                  ,[Agility] = @Agility\r\n                                  ,[Luck] = @Luck\r\n                                  ,[Level] = @Level\r\n                                  ,[Quality] = @Quality\r\n                                  ,[Pic] = @Pic\r\n                                  ,[MaxCount] = @MaxCount\r\n                                  ,[NeedSex] = @NeedSex\r\n                                  ,[NeedLevel] = @NeedLevel\r\n                                  ,[CanStrengthen] = @CanStrengthen\r\n                                  ,[CanCompose] = @CanCompose\r\n                                  ,[CanDrop] = @CanDrop\r\n                                  ,[CanEquip] = @CanEquip\r\n                                  ,[CanUse] = @CanUse\r\n                                  ,[CanDelete] = @CanDelete\r\n                                  ,[Script] = @Script\r\n                                  ,[Data] = @Data\r\n                                  ,[Colors] = @Colors\r\n                                  ,[Property1] = @Property1\r\n                                  ,[Property2] = @Property2\r\n                                  ,[Property3] = @Property3\r\n                                  ,[Property4] = @Property4\r\n                                  ,[Property5] = @Property5\r\n                                  ,[Property6] = @Property6\r\n                                  ,[Property7] = @Property7\r\n                                  ,[Property8] = @Property8\r\n                                  ,[Valid] = @Valid\r\n                                  ,[Count] = @Count\r\n                                  ,[AddTime] = @AddTime\r\n                                  ,[BindType] = @BindType\r\n                                  ,[FusionType] = @FusionType\r\n                                  ,[FusionRate] = @FusionRate\r\n                                  ,[FusionNeedRate] = @FusionNeedRate\r\n                                  ,[Hole] = @Hole\r\n                                  ,[RefineryLevel] = @RefineryLevel\r\n                                  ,[ReclaimValue] = @ReclaimValue\r\n                                  ,[ReclaimType] = @ReclaimType\r\n                                  ,[CanRecycle] = @CanRecycle\r\n                                  ,[FloorPrice] = @FloorPrice\r\n                                  ,[SuitId] = @SuitId\r\n                                                             WHERE [TemplateID] = @TemplateID", new SqlParameter[46]
                {
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Remark", (object) ""),
          new SqlParameter("@CategoryID", (object) item.CategoryID),
          new SqlParameter("@Description", (object) item.Description),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@Luck", (object) item.Luck),
          new SqlParameter("@Level", (object) item.Level),
          new SqlParameter("@Quality", (object) item.Quality),
          new SqlParameter("@Pic", (object) item.Pic),
          new SqlParameter("@MaxCount", (object) item.MaxCount),
          new SqlParameter("@NeedSex", (object) item.NeedSex),
          new SqlParameter("@NeedLevel", (object) item.NeedLevel),
          new SqlParameter("@CanStrengthen", (object) item.CanStrengthen),
          new SqlParameter("@CanCompose", (object) item.CanCompose),
          new SqlParameter("@CanDrop", (object) item.CanDrop),
          new SqlParameter("@CanEquip", (object) item.CanEquip),
          new SqlParameter("@CanUse", (object) item.CanUse),
          new SqlParameter("@CanDelete", (object) item.CanDelete),
          new SqlParameter("@Script", (object) item.Script),
          new SqlParameter("@Data", (object) item.Data),
          new SqlParameter("@Colors", (object) item.Colors),
          new SqlParameter("@Property1", (object) item.Property1),
          new SqlParameter("@Property2", (object) item.Property2),
          new SqlParameter("@Property3", (object) item.Property3),
          new SqlParameter("@Property4", (object) item.Property4),
          new SqlParameter("@Property5", (object) item.Property5),
          new SqlParameter("@Property6", (object) item.Property6),
          new SqlParameter("@Property7", (object) item.Property7),
          new SqlParameter("@Property8", (object) item.Property8),
          new SqlParameter("@Valid", (object) "0"),
          new SqlParameter("@Count", (object) "1"),
          new SqlParameter("@AddTime", (object) item.AddTime),
          new SqlParameter("@BindType", (object) item.BindType),
          new SqlParameter("@FusionType", (object) item.FusionType),
          new SqlParameter("@FusionRate", (object) item.FusionRate),
          new SqlParameter("@FusionNeedRate", (object) item.FusionNeedRate),
          new SqlParameter("@Hole", (object) item.Hole),
          new SqlParameter("@RefineryLevel", (object) item.RefineryLevel),
          new SqlParameter("@ReclaimValue", (object) item.ReclaimValue),
          new SqlParameter("@ReclaimType", (object) item.ReclaimType),
          new SqlParameter("@CanRecycle", (object) item.CanRecycle),
          new SqlParameter("@FloorPrice", (object) item.FloorPrice),
          new SqlParameter("@SuitId", (object) item.SuitId)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("UpdateItemTemplate: " + ex.ToString());
            }
            return flag;
        }

        public bool DeleteItemTemplate(int templateID)
        {
            bool flag = false;
            try
            {
                flag = this.db.Exesqlcomm("DELETE FROM [dbo].[Shop_Goods] WHERE [TemplateID] = @TemplateID", new SqlParameter[1]
                {
          new SqlParameter("@TemplateID", (object) templateID)
                });
            }
            catch (Exception ex)
            {
                Logger.Error("DeleteItemTemplate: " + ex.ToString());
            }
            return flag;
        }
    }
}
