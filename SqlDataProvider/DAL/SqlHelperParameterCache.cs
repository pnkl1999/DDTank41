using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;

namespace DAL
{
    public sealed class SqlHelperParameterCache
    {
        private static Hashtable paramCache = Hashtable.Synchronized(new Hashtable());

        private SqlHelperParameterCache()
        {
        }

        private static SqlParameter[] DiscoverSpParameterSet(string connectionString, string spName, bool includeReturnValueParameter)
        {
			using SqlConnection cn = new SqlConnection(connectionString);
			using SqlCommand cmd = new SqlCommand(spName, cn);
			cn.Open();
			cmd.CommandType = CommandType.StoredProcedure;
			SqlCommandBuilder.DeriveParameters(cmd);
			if (!includeReturnValueParameter)
			{
				cmd.Parameters.RemoveAt(0);
			}
			SqlParameter[] discoveredParameters = new SqlParameter[cmd.Parameters.Count];
			cmd.Parameters.CopyTo(discoveredParameters, 0);
			return discoveredParameters;
        }

        private static SqlParameter[] CloneParameters(SqlParameter[] originalParameters)
        {
			SqlParameter[] clonedParameters = new SqlParameter[originalParameters.Length];
			int i = 0;
			for (int j = originalParameters.Length; i < j; i++)
			{
				clonedParameters[i] = (SqlParameter)((ICloneable)originalParameters[i]).Clone();
			}
			return clonedParameters;
        }

        public static void CacheParameterSet(string connectionString, string commandText, params SqlParameter[] commandParameters)
        {
			string hashKey = connectionString + ":" + commandText;
			paramCache[hashKey] = commandParameters;
        }

        public static SqlParameter[] GetCachedParameterSet(string connectionString, string commandText)
        {
			string hashKey = connectionString + ":" + commandText;
			SqlParameter[] cachedParameters = (SqlParameter[])paramCache[hashKey];
			if (cachedParameters == null)
			{
				return null;
			}
			return CloneParameters(cachedParameters);
        }

        public static SqlParameter[] GetSpParameterSet(string connectionString, string spName)
        {
			return GetSpParameterSet(connectionString, spName, includeReturnValueParameter: false);
        }

        public static SqlParameter[] GetSpParameterSet(string connectionString, string spName, bool includeReturnValueParameter)
        {
			string hashKey = connectionString + ":" + spName + (includeReturnValueParameter ? ":include ReturnValue Parameter" : "");
			SqlParameter[] cachedParameters = (SqlParameter[])paramCache[hashKey];
			if (cachedParameters == null)
			{
				object obj2 = (paramCache[hashKey] = DiscoverSpParameterSet(connectionString, spName, includeReturnValueParameter));
				object obj = obj2;
				cachedParameters = (SqlParameter[])obj;
			}
			return CloneParameters(cachedParameters);
        }
    }
}
