using System;
using System.Data.SqlClient;

namespace DAL
{
    public delegate void AsyncComandExecuteHanle(SqlCommand cmd, IAsyncResult result, object state);
}
