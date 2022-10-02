using Bussiness.CenterService;
using SqlDataProvider.Data;
using System;
using System.Data;
using System.Data.SqlClient;

namespace Bussiness
{
    public class ManageBussiness : BaseBussiness
    {
        private bool ForbidPlayer(string userName, string nickName, int userID, DateTime forbidDate, bool isExist)
        {
			return ForbidPlayer(userName, nickName, userID, forbidDate, isExist, "");
        }

        private bool ForbidPlayer(string userName, string nickName, int userID, DateTime forbidDate, bool isExist, string ForbidReason)
        {
			bool flag = false;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[6]
				{
					new SqlParameter("@UserName", userName),
					new SqlParameter("@NickName", nickName),
					new SqlParameter("@UserID", userID),
					null,
					null,
					null
				};
				sqlParameters[2].Direction = ParameterDirection.InputOutput;
				sqlParameters[3] = new SqlParameter("@ForbidDate", forbidDate);
				sqlParameters[4] = new SqlParameter("@IsExist", isExist);
				sqlParameters[5] = new SqlParameter("@ForbidReason", ForbidReason);
				db.RunProcedure("SP_Admin_ForbidUser", sqlParameters);
				userID = (int)sqlParameters[2].Value;
				if (userID <= 0)
				{
					return flag;
				}
				flag = true;
				if (!isExist)
				{
					KitoffUser(userID, "You are kicking out by GM!!");
					return flag;
				}
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

        public bool ForbidPlayerByNickName(string nickName, DateTime date, bool isExist)
        {
			return ForbidPlayer("", nickName, 0, date, isExist);
        }

        public bool ForbidPlayerByNickName(string nickName, DateTime date, bool isExist, string ForbidReason)
        {
			return ForbidPlayer("", nickName, 0, date, isExist, ForbidReason);
        }

        public bool ForbidPlayerByUserID(int userID, DateTime date, bool isExist)
        {
			return ForbidPlayer("", "", userID, date, isExist);
        }

        public bool ForbidPlayerByUserID(int userID, DateTime date, bool isExist, string ForbidReason)
        {
			return ForbidPlayer("", "", userID, date, isExist, ForbidReason);
        }

        public bool ForbidPlayerByUserName(string userName, DateTime date, bool isExist)
        {
			return ForbidPlayer(userName, "", 0, date, isExist);
        }

        public bool ForbidPlayerByUserName(string userName, DateTime date, bool isExist, string ForbidReason)
        {
			return ForbidPlayer(userName, "", 0, date, isExist, ForbidReason);
        }

        public int GetConfigState(int type)
        {
			try
			{
				using CenterServiceClient client = new CenterServiceClient();
				return client.GetConfigState(type);
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("GetConfigState", exception);
				}
			}
			return 2;
        }

        public int KitoffUser(int id, string msg)
        {
			try
			{
				using CenterServiceClient client = new CenterServiceClient();
				if (client.KitoffUser(id, msg))
				{
					return 0;
				}
				return 3;
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("KitoffUser", exception);
				}
				return 1;
			}
        }

        public int KitoffUserByNickName(string name, string msg)
        {
			using PlayerBussiness bussiness = new PlayerBussiness();
			PlayerInfo userSingleByNickName = bussiness.GetUserSingleByNickName(name);
			if (userSingleByNickName == null)
			{
				return 2;
			}
			return KitoffUser(userSingleByNickName.ID, msg);
        }

        public int KitoffUserByUserName(string name, string msg)
        {
			using PlayerBussiness bussiness = new PlayerBussiness();
			PlayerInfo userSingleByUserName = bussiness.GetUserSingleByUserName(name);
			if (userSingleByUserName == null)
			{
				return 2;
			}
			return KitoffUser(userSingleByUserName.ID, msg);
        }

        public bool Reload(string type)
        {
			try
			{
				using CenterServiceClient client = new CenterServiceClient();
				return client.Reload(type);
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("Reload", exception);
				}
			}
			return false;
        }

        public bool ReLoadServerList()
        {
			bool flag = false;
			try
			{
				using CenterServiceClient client = new CenterServiceClient();
				if (client.ReLoadServerList())
				{
					flag = true;
					return flag;
				}
				return flag;
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("ReLoadServerList", exception);
					return flag;
				}
				return flag;
			}
        }

        public bool SystemNotice(string msg)
        {
			bool flag = false;
			try
			{
				if (string.IsNullOrEmpty(msg))
				{
					return flag;
				}
				using CenterServiceClient client = new CenterServiceClient();
				if (client.SystemNotice(msg))
				{
					flag = true;
					return flag;
				}
				return flag;
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("SystemNotice", exception);
					return flag;
				}
				return flag;
			}
        }

        public bool UpdateConfigState(int type, bool state)
        {
			try
			{
				using CenterServiceClient client = new CenterServiceClient();
				return client.UpdateConfigState(type, state);
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("UpdateConfigState", exception);
				}
			}
			return false;
        }
    }
}
