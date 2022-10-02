using System;
using System.Data;
using System.Data.SqlClient;

namespace Bussiness
{
    public class CookieInfoBussiness : BaseBussiness
    {
        public bool AddCookieInfo(string bdSigUser, string bdSigPortrait, string bdSigSessionKey)
        {
			bool flag = false;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[4]
				{
					new SqlParameter("@BdSigUser", bdSigUser),
					new SqlParameter("@BdSigPortrait", bdSigPortrait),
					new SqlParameter("@BdSigSessionKey", bdSigSessionKey),
					new SqlParameter("@Result", SqlDbType.Int)
				};
				sqlParameters[3].Direction = ParameterDirection.ReturnValue;
				db.RunProcedure("SP_Cookie_Info_Insert", sqlParameters);
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

        public bool GetFromDbByUser(string bdSigUser, ref string bdSigPortrait, ref string bdSigSessionKey)
        {
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@BdSigUser", bdSigUser)
				};
				db.GetReader(ref resultDataReader, "SP_Cookie_Info_QueryByUser", sqlParameters);
				while (resultDataReader.Read())
				{
					bdSigPortrait = ((resultDataReader["BdSigPortrait"] == null) ? "" : resultDataReader["BdSigPortrait"].ToString());
					bdSigSessionKey = ((resultDataReader["BdSigSessionKey"] == null) ? "" : resultDataReader["BdSigSessionKey"].ToString());
				}
				return !string.IsNullOrEmpty(bdSigPortrait) && !string.IsNullOrEmpty(bdSigSessionKey);
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
