using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Bussiness
{
    public class ServiceBussiness : BaseBussiness
    {
        public FightRateInfo[] GetFightRate(int serverId)
        {
			SqlDataReader resultDataReader = null;
			List<FightRateInfo> list = new List<FightRateInfo>();
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@ServerID", serverId)
				};
				db.GetReader(ref resultDataReader, "SP_Fight_Rate", sqlParameters);
				if (resultDataReader.Read())
				{
					FightRateInfo item = new FightRateInfo
					{
						ID = (int)resultDataReader["ID"],
						ServerID = (int)resultDataReader["ServerID"],
						Rate = (int)resultDataReader["Rate"],
						BeginDay = (DateTime)resultDataReader["BeginDay"],
						EndDay = (DateTime)resultDataReader["EndDay"],
						BeginTime = (DateTime)resultDataReader["BeginTime"],
						EndTime = (DateTime)resultDataReader["EndTime"],
						SelfCue = ((resultDataReader["SelfCue"] == null) ? "" : resultDataReader["SelfCue"].ToString()),
						EnemyCue = ((resultDataReader["EnemyCue"] == null) ? "" : resultDataReader["EnemyCue"].ToString()),
						BoyTemplateID = (int)resultDataReader["BoyTemplateID"],
						GirlTemplateID = (int)resultDataReader["GirlTemplateID"],
						Name = ((resultDataReader["Name"] == null) ? "" : resultDataReader["Name"].ToString())
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("GetFightRate", exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return list.ToArray();
        }

        public string GetGameEdition()
        {
			string str = string.Empty;
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Server_Edition");
				if (resultDataReader.Read())
				{
					return (resultDataReader["value"] == null) ? "" : resultDataReader["value"].ToString();
				}
				return str;
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("Init", exception);
					return str;
				}
				return str;
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
        }

        public ArrayList GetRate(int serverId)
        {
			SqlDataReader resultDataReader = null;
			try
			{
				ArrayList list = new ArrayList();
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@ServerID", serverId)
				};
				db.GetReader(ref resultDataReader, "SP_Rate", sqlParameters);
				while (resultDataReader.Read())
				{
					RateInfo info = new RateInfo
					{
						ServerID = (int)resultDataReader["ServerID"],
						Rate = (float)(decimal)resultDataReader["Rate"],
						BeginDay = (DateTime)resultDataReader["BeginDay"],
						EndDay = (DateTime)resultDataReader["EndDay"],
						BeginTime = (DateTime)resultDataReader["BeginTime"],
						EndTime = (DateTime)resultDataReader["EndTime"],
						Type = (int)resultDataReader["Type"]
					};
					list.Add(info);
				}
				list.TrimToSize();
				return list;
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("GetRates", exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return null;
        }

        public RateInfo GetRateWithType(int serverId, int type)
        {
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[2]
				{
					new SqlParameter("@ServerID", serverId),
					new SqlParameter("@Type", type)
				};
				db.GetReader(ref resultDataReader, "SP_Rate_WithType", sqlParameters);
				if (resultDataReader.Read())
				{
					return new RateInfo
					{
						ServerID = (int)resultDataReader["ServerID"],
						Type = type,
						Rate = (float)resultDataReader["Rate"],
						BeginDay = (DateTime)resultDataReader["BeginDay"],
						EndDay = (DateTime)resultDataReader["EndDay"],
						BeginTime = (DateTime)resultDataReader["BeginTime"],
						EndTime = (DateTime)resultDataReader["EndTime"]
					};
				}
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("GetRate type: " + type, exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return null;
        }

        public RecordInfo GetRecordInfo(DateTime date, int SaveRecordSecond)
        {
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[2]
				{
					new SqlParameter("@Date", date.ToString("yyyy-MM-dd HH:mm:ss")),
					new SqlParameter("@Second", SaveRecordSecond)
				};
				db.GetReader(ref resultDataReader, "SP_Server_Record", sqlParameters);
				if (resultDataReader.Read())
				{
					return new RecordInfo
					{
						ActiveExpendBoy = (int)resultDataReader["ActiveExpendBoy"],
						ActiveExpendGirl = (int)resultDataReader["ActiveExpendGirl"],
						ActviePayBoy = (int)resultDataReader["ActviePayBoy"],
						ActviePayGirl = (int)resultDataReader["ActviePayGirl"],
						ExpendBoy = (int)resultDataReader["ExpendBoy"],
						ExpendGirl = (int)resultDataReader["ExpendGirl"],
						OnlineBoy = (int)resultDataReader["OnlineBoy"],
						OnlineGirl = (int)resultDataReader["OnlineGirl"],
						TotalBoy = (int)resultDataReader["TotalBoy"],
						TotalGirl = (int)resultDataReader["TotalGirl"],
						ActiveOnlineBoy = (int)resultDataReader["ActiveOnlineBoy"],
						ActiveOnlineGirl = (int)resultDataReader["ActiveOnlineGirl"]
					};
				}
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("Init", exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return null;
        }

        public Dictionary<string, string> GetServerConfig()
        {
			Dictionary<string, string> dictionary = new Dictionary<string, string>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Server_Config");
				while (resultDataReader.Read())
				{
					if (!dictionary.ContainsKey(resultDataReader["Name"].ToString()))
					{
						dictionary.Add(resultDataReader["Name"].ToString(), resultDataReader["Value"].ToString());
					}
				}
				return dictionary;
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("GetServerConfig", exception);
					return dictionary;
				}
				return dictionary;
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
        }

        public ServerInfo[] GetServerList()
        {
			List<ServerInfo> list = new List<ServerInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Service_List");
				while (resultDataReader.Read())
				{
					ServerInfo item = new ServerInfo
					{
						ID = (int)resultDataReader["ID"],
						IP = resultDataReader["IP"].ToString(),
						Name = resultDataReader["Name"].ToString(),
						Online = (int)resultDataReader["Online"],
						Port = (int)resultDataReader["Port"],
						Remark = resultDataReader["Remark"].ToString(),
						Room = (int)resultDataReader["Room"],
						State = (int)resultDataReader["State"],
						Total = (int)resultDataReader["Total"],
						RSA = resultDataReader["RSA"].ToString(),
						MustLevel = (int)resultDataReader["MustLevel"],
						LowestLevel = (int)resultDataReader["LowestLevel"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("Init", exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return list.ToArray();
        }

		//SP_Server_Config

		public ServerProperty[] GetAllServerProperty()
		{
			List<ServerProperty> result = new List<ServerProperty>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Server_Config");
				while (resultDataReader.Read())
				{
					result.Add(new ServerProperty
					{
						Key = resultDataReader["Name"].ToString(),
						Value = resultDataReader["Value"].ToString()
					});
				}
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("GetServerConfig", exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return result.ToArray();
		}
		public ServerProperty GetServerPropertyByKey(string key)
        {
			ServerProperty property = null;
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@Key", key)
				};
				db.GetReader(ref resultDataReader, "SP_Server_Config_Single", sqlParameters);
				while (resultDataReader.Read())
				{
					property = new ServerProperty
					{
						Key = resultDataReader["Name"].ToString(),
						Value = resultDataReader["Value"].ToString()
					};
				}
				return property;
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("GetServerConfig", exception);
					return property;
				}
				return property;
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
        }

        public ServerInfo[] GetServiceByIP(string IP)
        {
			List<ServerInfo> list = new List<ServerInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@IP", SqlDbType.NVarChar, 50)
				};
				sqlParameters[0].Value = IP;
				db.GetReader(ref resultDataReader, "SP_Service_ListByIP", sqlParameters);
				while (resultDataReader.Read())
				{
					ServerInfo item = new ServerInfo
					{
						ID = (int)resultDataReader["ID"],
						IP = resultDataReader["IP"].ToString(),
						Name = resultDataReader["Name"].ToString(),
						Online = (int)resultDataReader["Online"],
						Port = (int)resultDataReader["Port"],
						Remark = resultDataReader["Remark"].ToString(),
						Room = (int)resultDataReader["Room"],
						State = (int)resultDataReader["State"],
						Total = (int)resultDataReader["Total"],
						RSA = resultDataReader["RSA"].ToString()
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("Init", exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return list.ToArray();
        }

        public ServerInfo GetServiceSingle(int ID)
        {
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@ID", SqlDbType.Int, 4)
				};
				sqlParameters[0].Value = ID;
				db.GetReader(ref resultDataReader, "SP_Service_Single", sqlParameters);
				if (resultDataReader.Read())
				{
					return new ServerInfo
					{
						ID = (int)resultDataReader["ID"],
						IP = resultDataReader["IP"].ToString(),
						Name = resultDataReader["Name"].ToString(),
						Online = (int)resultDataReader["Online"],
						Port = (int)resultDataReader["Port"],
						Remark = resultDataReader["Remark"].ToString(),
						Room = (int)resultDataReader["Room"],
						State = (int)resultDataReader["State"],
						Total = (int)resultDataReader["Total"],
						RSA = resultDataReader["RSA"].ToString(),
						NewerServer = (bool)resultDataReader["NewerServer"],
						ZoneId = (int)resultDataReader["ZoneId"],
						ZoneName = resultDataReader["ZoneName"].ToString()
					};
				}
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("Init", exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return null;
        }

        public bool UpdateRSA(int ID, string RSA)
        {
			bool flag = false;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[2]
				{
					new SqlParameter("@ID", ID),
					new SqlParameter("@RSA", RSA)
				};
				flag = db.RunProcedure("SP_Service_UpdateRSA", sqlParameters);
				return flag;
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("Init", exception);
					return flag;
				}
				return flag;
			}
        }

        public bool UpdateServerPropertyByKey(string key, string value)
        {
			bool flag = false;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[2]
				{
					new SqlParameter("@Key", key),
					new SqlParameter("@Value", value)
				};
				flag = db.RunProcedure("SP_Server_Config_Update", sqlParameters);
				return flag;
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("Init", exception);
					return flag;
				}
				return flag;
			}
        }

        public bool UpdateService(ServerInfo info)
        {
			bool flag = false;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[3]
				{
					new SqlParameter("@ID", info.ID),
					new SqlParameter("@Online", info.Online),
					new SqlParameter("@State", info.State)
				};
				flag = db.RunProcedure("SP_Service_Update", sqlParameters);
				return flag;
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("Init", exception);
					return flag;
				}
				return flag;
			}
        }
    }
}
