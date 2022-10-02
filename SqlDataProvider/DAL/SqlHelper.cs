using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

namespace DAL
{
    public sealed class SqlHelper
    {
        private enum SqlConnectionOwnership
		{
Internal,
            External		}

        private SqlHelper()
        {
        }

        private static void AttachParameters(SqlCommand command, SqlParameter[] commandParameters)
        {
			foreach (SqlParameter p in commandParameters)
			{
				if (p.Direction == ParameterDirection.InputOutput && p.Value == null)
				{
					p.Value = DBNull.Value;
				}
				command.Parameters.Add(p);
			}
        }

        public static void AssignParameterValues(SqlParameter[] commandParameters, params object[] parameterValues)
        {
			if (commandParameters == null || parameterValues == null)
			{
				return;
			}
			if (commandParameters.Length != parameterValues.Length)
			{
				throw new ArgumentException("Parameter count does not match Parameter Value count.");
			}
			int i = 0;
			for (int j = commandParameters.Length; i < j; i++)
			{
				if (parameterValues[i] != null && (commandParameters[i].Direction == ParameterDirection.Input || commandParameters[i].Direction == ParameterDirection.InputOutput))
				{
					commandParameters[i].Value = parameterValues[i];
				}
			}
        }

        public static void AssignParameterValues(SqlParameter[] commandParameters, Hashtable parameterValues)
        {
			if (commandParameters == null || parameterValues == null)
			{
				return;
			}
			if (commandParameters.Length != parameterValues.Count)
			{
				throw new ArgumentException("Parameter count does not match Parameter Value count.");
			}
			int i = 0;
			for (int j = commandParameters.Length; i < j; i++)
			{
				if (parameterValues[commandParameters[i].ParameterName] != null && (commandParameters[i].Direction == ParameterDirection.Input || commandParameters[i].Direction == ParameterDirection.InputOutput))
				{
					commandParameters[i].Value = parameterValues[commandParameters[i].ParameterName];
				}
			}
        }

        private static void PrepareCommand(SqlCommand command, SqlConnection connection, SqlTransaction transaction, CommandType commandType, string commandText, SqlParameter[] commandParameters)
        {
			if (connection.State != ConnectionState.Open)
			{
				connection.Open();
			}
			command.Connection = connection;
			command.CommandText = commandText;
			if (transaction != null)
			{
				command.Transaction = transaction;
			}
			command.CommandType = commandType;
			if (commandParameters != null)
			{
				AttachParameters(command, commandParameters);
			}
        }

        public static int ExecuteNonQuery(string connectionString, CommandType commandType, string commandText)
        {
			return ExecuteNonQuery(connectionString, commandType, commandText, (SqlParameter[])null);
        }

        public static int ExecuteNonQuery(string connectionString, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			using SqlConnection cn = new SqlConnection(connectionString);
			cn.Open();
			return ExecuteNonQuery(cn, commandType, commandText, commandParameters);
        }

        public static int ExecuteNonQuery(string connectionString, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName);
        }

        public static int ExecuteNonQuery(string connectionString, string spName, Hashtable parameterValues)
        {
			if (parameterValues != null && parameterValues.Count > 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName);
        }

        public static int ExecuteNonQuery(SqlConnection connection, CommandType commandType, string commandText)
        {
			return ExecuteNonQuery(connection, commandType, commandText, (SqlParameter[])null);
        }

        public static int ExecuteNonQuery(SqlConnection connection, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			SqlCommand sqlCommand = new SqlCommand();
			PrepareCommand(sqlCommand, connection, null, commandType, commandText, commandParameters);
			int retval = sqlCommand.ExecuteNonQuery();
			sqlCommand.Parameters.Clear();
			return retval;
        }

        public static int ExecuteNonQuery(SqlConnection connection, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(connection.ConnectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteNonQuery(connection, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteNonQuery(connection, CommandType.StoredProcedure, spName);
        }

        public static int ExecuteNonQuery(SqlTransaction transaction, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			SqlCommand sqlCommand = new SqlCommand();
			PrepareCommand(sqlCommand, transaction.Connection, transaction, commandType, commandText, commandParameters);
			int retval = sqlCommand.ExecuteNonQuery();
			sqlCommand.Parameters.Clear();
			return retval;
        }

        public static int ExecuteNonQuery(SqlTransaction transaction, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(transaction.Connection.ConnectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteNonQuery(transaction, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteNonQuery(transaction, CommandType.StoredProcedure, spName);
        }

        public static DataSet ExecuteDataset(string connectionString, CommandType commandType, string commandText)
        {
			return ExecuteDataset(connectionString, commandType, commandText, (SqlParameter[])null);
        }

        public static DataSet ExecuteDataset(string connectionString, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			using SqlConnection cn = new SqlConnection(connectionString);
			cn.Open();
			return ExecuteDataset(cn, commandType, commandText, commandParameters);
        }

        public static DataSet ExecuteDataset(string connectionString, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteDataset(connectionString, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteDataset(connectionString, CommandType.StoredProcedure, spName);
        }

        public static DataSet ExecuteDataset(SqlConnection connection, CommandType commandType, string commandText)
        {
			return ExecuteDataset(connection, commandType, commandText, (SqlParameter[])null);
        }

        public static DataSet ExecuteDataset(SqlConnection connection, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			SqlCommand sqlCommand = new SqlCommand();
			PrepareCommand(sqlCommand, connection, null, commandType, commandText, commandParameters);
			SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
			DataSet ds = new DataSet();
			sqlDataAdapter.Fill(ds);
			sqlCommand.Parameters.Clear();
			return ds;
        }

        public static DataSet ExecuteDataset(SqlConnection connection, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(connection.ConnectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteDataset(connection, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteDataset(connection, CommandType.StoredProcedure, spName);
        }

        public static DataSet ExecuteDataset(SqlTransaction transaction, CommandType commandType, string commandText)
        {
			return ExecuteDataset(transaction, commandType, commandText, (SqlParameter[])null);
        }

        public static DataSet ExecuteDataset(SqlTransaction transaction, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			SqlCommand sqlCommand = new SqlCommand();
			PrepareCommand(sqlCommand, transaction.Connection, transaction, commandType, commandText, commandParameters);
			SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
			DataSet ds = new DataSet();
			sqlDataAdapter.Fill(ds);
			sqlCommand.Parameters.Clear();
			return ds;
        }

        public static DataSet ExecuteDataset(SqlTransaction transaction, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(transaction.Connection.ConnectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteDataset(transaction, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteDataset(transaction, CommandType.StoredProcedure, spName);
        }

        private static SqlDataReader ExecuteReader(SqlConnection connection, SqlTransaction transaction, CommandType commandType, string commandText, SqlParameter[] commandParameters, SqlConnectionOwnership connectionOwnership)
        {
			SqlCommand cmd = new SqlCommand();
			PrepareCommand(cmd, connection, transaction, commandType, commandText, commandParameters);
			SqlDataReader dr = ((connectionOwnership != SqlConnectionOwnership.External) ? cmd.ExecuteReader(CommandBehavior.CloseConnection) : cmd.ExecuteReader());
			cmd.Parameters.Clear();
			return dr;
        }

        public static SqlDataReader ExecuteReader(string connectionString, CommandType commandType, string commandText)
        {
			return ExecuteReader(connectionString, commandType, commandText, (SqlParameter[])null);
        }

        public static SqlDataReader ExecuteReader(string connectionString, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			SqlConnection cn = new SqlConnection(connectionString);
			cn.Open();
			try
			{
				return ExecuteReader(cn, null, commandType, commandText, commandParameters, SqlConnectionOwnership.Internal);
			}
			catch
			{
				cn.Close();
				throw;
			}
        }

        public static SqlDataReader ExecuteReader(string connectionString, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteReader(connectionString, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteReader(connectionString, CommandType.StoredProcedure, spName);
        }

        public static SqlDataReader ExecuteReader(SqlConnection connection, CommandType commandType, string commandText)
        {
			return ExecuteReader(connection, commandType, commandText, (SqlParameter[])null);
        }

        public static SqlDataReader ExecuteReader(SqlConnection connection, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			return ExecuteReader(connection, null, commandType, commandText, commandParameters, SqlConnectionOwnership.External);
        }

        public static SqlDataReader ExecuteReader(SqlConnection connection, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(connection.ConnectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteReader(connection, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteReader(connection, CommandType.StoredProcedure, spName);
        }

        public static SqlDataReader ExecuteReader(SqlTransaction transaction, CommandType commandType, string commandText)
        {
			return ExecuteReader(transaction, commandType, commandText, (SqlParameter[])null);
        }

        public static SqlDataReader ExecuteReader(SqlTransaction transaction, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			return ExecuteReader(transaction.Connection, transaction, commandType, commandText, commandParameters, SqlConnectionOwnership.External);
        }

        public static SqlDataReader ExecuteReader(SqlTransaction transaction, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(transaction.Connection.ConnectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteReader(transaction, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteReader(transaction, CommandType.StoredProcedure, spName);
        }

        public static object ExecuteScalar(string connectionString, CommandType commandType, string commandText)
        {
			return ExecuteScalar(connectionString, commandType, commandText, (SqlParameter[])null);
        }

        public static object ExecuteScalar(string connectionString, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			using SqlConnection cn = new SqlConnection(connectionString);
			cn.Open();
			return ExecuteScalar(cn, commandType, commandText, commandParameters);
        }

        public static object ExecuteScalar(string connectionString, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteScalar(connectionString, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteScalar(connectionString, CommandType.StoredProcedure, spName);
        }

        public static object ExecuteScalar(SqlConnection connection, CommandType commandType, string commandText)
        {
			return ExecuteScalar(connection, commandType, commandText, (SqlParameter[])null);
        }

        public static object ExecuteScalar(SqlConnection connection, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			SqlCommand sqlCommand = new SqlCommand();
			PrepareCommand(sqlCommand, connection, null, commandType, commandText, commandParameters);
			object retval = sqlCommand.ExecuteScalar();
			sqlCommand.Parameters.Clear();
			return retval;
        }

        public static object ExecuteScalar(SqlConnection connection, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(connection.ConnectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteScalar(connection, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteScalar(connection, CommandType.StoredProcedure, spName);
        }

        public static object ExecuteScalar(SqlTransaction transaction, CommandType commandType, string commandText)
        {
			return ExecuteScalar(transaction, commandType, commandText, (SqlParameter[])null);
        }

        public static object ExecuteScalar(SqlTransaction transaction, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			SqlCommand sqlCommand = new SqlCommand();
			PrepareCommand(sqlCommand, transaction.Connection, transaction, commandType, commandText, commandParameters);
			object retval = sqlCommand.ExecuteScalar();
			sqlCommand.Parameters.Clear();
			return retval;
        }

        public static object ExecuteScalar(SqlTransaction transaction, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(transaction.Connection.ConnectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteScalar(transaction, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteScalar(transaction, CommandType.StoredProcedure, spName);
        }

        public static XmlReader ExecuteXmlReader(SqlConnection connection, CommandType commandType, string commandText)
        {
			return ExecuteXmlReader(connection, commandType, commandText, (SqlParameter[])null);
        }

        public static XmlReader ExecuteXmlReader(SqlConnection connection, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			SqlCommand sqlCommand = new SqlCommand();
			PrepareCommand(sqlCommand, connection, null, commandType, commandText, commandParameters);
			XmlReader retval = sqlCommand.ExecuteXmlReader();
			sqlCommand.Parameters.Clear();
			return retval;
        }

        public static XmlReader ExecuteXmlReader(SqlConnection connection, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(connection.ConnectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteXmlReader(connection, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteXmlReader(connection, CommandType.StoredProcedure, spName);
        }

        public static XmlReader ExecuteXmlReader(SqlTransaction transaction, CommandType commandType, string commandText)
        {
			return ExecuteXmlReader(transaction, commandType, commandText, (SqlParameter[])null);
        }

        public static XmlReader ExecuteXmlReader(SqlTransaction transaction, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			SqlCommand sqlCommand = new SqlCommand();
			PrepareCommand(sqlCommand, transaction.Connection, transaction, commandType, commandText, commandParameters);
			XmlReader retval = sqlCommand.ExecuteXmlReader();
			sqlCommand.Parameters.Clear();
			return retval;
        }

        public static XmlReader ExecuteXmlReader(SqlTransaction transaction, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(transaction.Connection.ConnectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				return ExecuteXmlReader(transaction, CommandType.StoredProcedure, spName, commandParameters);
			}
			return ExecuteXmlReader(transaction, CommandType.StoredProcedure, spName);
        }

        public static void BeginExecuteNonQuery(SqlConnection connection, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			SqlCommand sqlCommand = new SqlCommand();
			PrepareCommand(sqlCommand, connection, null, commandType, commandText, commandParameters);
			sqlCommand.BeginExecuteNonQuery();
			sqlCommand.Parameters.Clear();
        }

        public static void BeginExecuteNonQuery(string connectionString, CommandType commandType, string commandText, params SqlParameter[] commandParameters)
        {
			using SqlConnection cn = new SqlConnection(connectionString);
			cn.Open();
			ExecuteNonQuery(cn, commandType, commandText, commandParameters);
        }

        public static void BeginExecuteNonQuery(string connectionString, string spName, params object[] parameterValues)
        {
			if (parameterValues != null && parameterValues.Length != 0)
			{
				SqlParameter[] commandParameters = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
				AssignParameterValues(commandParameters, parameterValues);
				ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName, commandParameters);
			}
			else
			{
				ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName);
			}
        }
    }
}
