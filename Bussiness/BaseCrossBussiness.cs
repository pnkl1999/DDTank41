using log4net;
using SqlDataProvider.BaseClass;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;

namespace Bussiness
{
    public class BaseCrossBussiness : IDisposable
    {
        protected readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected Sql_DbObject db = new Sql_DbObject("AppConfig", "crosszoneString");

        public DataTable GetPage(string queryStr, string queryWhere, int pageCurrent, int pageSize, string fdShow, string fdOreder, string fdKey, ref int total)
        {
			try
			{
				SqlParameter[] SqlParameters = new SqlParameter[8]
				{
					new SqlParameter("@QueryStr", queryStr),
					new SqlParameter("@QueryWhere", queryWhere),
					new SqlParameter("@PageSize", pageSize),
					new SqlParameter("@PageCurrent", pageCurrent),
					new SqlParameter("@FdShow", fdShow),
					new SqlParameter("@FdOrder", fdOreder),
					new SqlParameter("@FdKey", fdKey),
					new SqlParameter("@TotalRow", total)
				};
				SqlParameters[7].Direction = ParameterDirection.Output;
				DataTable dataTable = db.GetDataTable(queryStr, "SP_CustomPage", SqlParameters, 120);
				total = (int)SqlParameters[7].Value;
				return dataTable;
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", ex);
				}
			}
			return new DataTable(queryStr);
        }

        public void Dispose()
        {
			db.Dispose();
			GC.SuppressFinalize(this);
        }
    }
}
