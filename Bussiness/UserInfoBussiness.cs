using System;
using System.Data;
using System.Data.SqlClient;

namespace Bussiness
{
    public class UserInfoBussiness : BaseBussiness
    {
        public bool AddUserInfo(string uid, string userName, string portrait)
        {
			bool flag = false;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[4]
				{
					new SqlParameter("@Uid", uid),
					new SqlParameter("@UserName", userName),
					new SqlParameter("@Portrait", portrait),
					new SqlParameter("@Result", SqlDbType.Int)
				};
				sqlParameters[3].Direction = ParameterDirection.ReturnValue;
				db.RunProcedure("SP_User_Info_Insert", sqlParameters);
				flag = (int)sqlParameters[3].Value == 0;
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

        public bool GetFromDbByUid(string uid, ref string userName, ref string portrait)
        {
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@Uid", uid)
				};
				db.GetReader(ref resultDataReader, "SP_User_Info_QueryByUid", sqlParameters);
				while (resultDataReader.Read())
				{
					userName = ((resultDataReader["UserName"] == null) ? "" : resultDataReader["UserName"].ToString());
					portrait = ((resultDataReader["Portrait"] == null) ? "" : resultDataReader["Portrait"].ToString());
				}
				return !string.IsNullOrEmpty(userName) && !string.IsNullOrEmpty(portrait);
			}
			catch (Exception exception)
			{
				if (BaseBussiness.log.IsErrorEnabled)
				{
					BaseBussiness.log.Error("Init", exception);
				}
				return false;
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
        }
    }
}
