using log4net;
using SqlDataProvider.BaseClass;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;

namespace Bussiness
{
    public class MemberShipBussiness : IDisposable
    {
        protected Sql_DbObject db = new Sql_DbObject("AppConfig", "membershipDb");

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public bool CreateUsername(string applicationname, string username, string password, string email, string passwordformat, string passwordsalt, bool usersex)
        {
			SqlParameter[] sqlParameters = new SqlParameter[8]
			{
				new SqlParameter("@ApplicationName", applicationname),
				new SqlParameter("@UserName", username),
				new SqlParameter("@password", password),
				new SqlParameter("@email", email),
				new SqlParameter("@PasswordFormat", passwordformat),
				new SqlParameter("@PasswordSalt", passwordsalt),
				new SqlParameter("@UserSex", usersex),
				new SqlParameter("@UserId", SqlDbType.Int)
			};
			sqlParameters[7].Direction = ParameterDirection.Output;
			bool flag = db.RunProcedure("Mem_Users_CreateUser", sqlParameters);
			if (flag)
			{
				flag = (int)sqlParameters[7].Value > 0;
			}
			return flag;
        }

        public bool CheckAdmin(string username)
        {
			SqlParameter[] sqlParameters = new SqlParameter[2]
			{
				new SqlParameter("@UserName", username),
				new SqlParameter("@UserCOUNT", SqlDbType.Int)
			};
			sqlParameters[1].Direction = ParameterDirection.Output;
			db.RunProcedure("Mem_UserInfo_Addmin", sqlParameters);
			return (int)sqlParameters[1].Value > 0;
        }

        public int CheckPoint(string username)
        {
			SqlParameter[] sqlParameters = new SqlParameter[2]
			{
				new SqlParameter("@UserName", username),
				new SqlParameter("@Point", SqlDbType.Int)
			};
			sqlParameters[1].Direction = ParameterDirection.Output;
			db.RunProcedure("Mem_User_Point", sqlParameters);
			return (int)sqlParameters[1].Value;
        }

        public bool CheckUsername(string username, string password)
        {
			SqlParameter[] sqlParameters = new SqlParameter[3]
			{
				new SqlParameter("@UserName", username),
				new SqlParameter("@password", password),
				new SqlParameter("@UserId", SqlDbType.Int)
			};
			sqlParameters[2].Direction = ParameterDirection.Output;
			db.RunProcedure("Check_User", sqlParameters);
			int result = 0;
			int.TryParse(sqlParameters[2].Value.ToString(), out result);
			return result > 0;
        }

        public void Dispose()
        {
			db.Dispose();
			GC.SuppressFinalize(this);
        }

        public bool ExistsUsername(string username)
        {
			SqlParameter[] sqlParameters = new SqlParameter[2]
			{
				new SqlParameter("@UserName", username),
				new SqlParameter("@UserCOUNT", SqlDbType.Int)
			};
			sqlParameters[1].Direction = ParameterDirection.Output;
			db.RunProcedure("Mem_UserInfo_SearchName", sqlParameters);
			return (int)sqlParameters[1].Value > 0;
        }

        public eStoreInfo[] GetAlleStore()
        {
			List<eStoreInfo> list = new List<eStoreInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_eStore_All");
				while (resultDataReader.Read())
				{
					eStoreInfo item = new eStoreInfo
					{
						StoreID = (int)resultDataReader["StoreID"],
						TemplateID = (int)resultDataReader["TemplateID"],
						PriceValue = (int)resultDataReader["PriceValue"],
						StrengthenLevel = (int)resultDataReader["StrengthenLevel"],
						AttackCompose = (int)resultDataReader["AttackCompose"],
						AgilityCompose = (int)resultDataReader["AgilityCompose"],
						DefendCompose = (int)resultDataReader["DefendCompose"],
						LuckCompose = (int)resultDataReader["LuckCompose"],
						IsBinds = (bool)resultDataReader["IsBinds"],
						ValidDate = (int)resultDataReader["ValidDate"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("eStore", exception);
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

        public eStoreInfo[] GetAlleStoreByDesc()
        {
			List<eStoreInfo> list = new List<eStoreInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_eStore_Desc");
				while (resultDataReader.Read())
				{
					eStoreInfo item = new eStoreInfo
					{
						StoreID = (int)resultDataReader["StoreID"],
						TemplateID = (int)resultDataReader["TemplateID"],
						PriceValue = (int)resultDataReader["PriceValue"],
						StrengthenLevel = (int)resultDataReader["StrengthenLevel"],
						AttackCompose = (int)resultDataReader["AttackCompose"],
						AgilityCompose = (int)resultDataReader["AgilityCompose"],
						DefendCompose = (int)resultDataReader["DefendCompose"],
						LuckCompose = (int)resultDataReader["LuckCompose"],
						IsBinds = (bool)resultDataReader["IsBinds"],
						ValidDate = (int)resultDataReader["ValidDate"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("eStore", exception);
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

        public eStoreInfo[] GetAlleStoreSale()
        {
			List<eStoreInfo> list = new List<eStoreInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_eStore_Desc_Sale");
				while (resultDataReader.Read())
				{
					eStoreInfo item = new eStoreInfo
					{
						StoreID = (int)resultDataReader["StoreID"],
						TemplateID = (int)resultDataReader["TemplateID"],
						PriceValue = (int)resultDataReader["PriceValue1"],
						StrengthenLevel = (int)resultDataReader["StrengthenLevel"],
						AttackCompose = (int)resultDataReader["AttackCompose"],
						AgilityCompose = (int)resultDataReader["AgilityCompose"],
						DefendCompose = (int)resultDataReader["DefendCompose"],
						LuckCompose = (int)resultDataReader["LuckCompose"],
						IsBinds = (bool)resultDataReader["IsBinds"],
						ValidDate = (int)resultDataReader["ValidDate"],
						OldPriceValue = (int)resultDataReader["PriceValue"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SP_eStore_Desc_Sale", exception);
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

        public eStoreInfo[] GetAlleStoreTopBuy()
        {
			List<eStoreInfo> list = new List<eStoreInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_eStore_Desc_Buy");
				while (resultDataReader.Read())
				{
					eStoreInfo item = new eStoreInfo
					{
						StoreID = (int)resultDataReader["StoreID"],
						TemplateID = (int)resultDataReader["TemplateID"],
						PriceValue = (int)resultDataReader["PriceValue"],
						StrengthenLevel = (int)resultDataReader["StrengthenLevel"],
						AttackCompose = (int)resultDataReader["AttackCompose"],
						AgilityCompose = (int)resultDataReader["AgilityCompose"],
						DefendCompose = (int)resultDataReader["DefendCompose"],
						LuckCompose = (int)resultDataReader["LuckCompose"],
						IsBinds = (bool)resultDataReader["IsBinds"],
						ValidDate = (int)resultDataReader["ValidDate"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SP_eStore_Desc_Buy", exception);
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

        public bool RemovePoint(string username, int Point)
        {
			SqlParameter[] sqlParameters = new SqlParameter[3]
			{
				new SqlParameter("@UserName", username),
				new SqlParameter("@Point", Point),
				new SqlParameter("@Result", SqlDbType.Int)
			};
			sqlParameters[2].Direction = ParameterDirection.ReturnValue;
			db.RunProcedure("Mem_User_Remove_Point", sqlParameters);
			return (int)sqlParameters[2].Value == 0;
        }
    }
}
