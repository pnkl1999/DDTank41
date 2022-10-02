using Helpers;
using SqlDataProvider.BaseClass;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;

namespace Tank.Data
{
    public class BaseBussiness : IDisposable
    {
        protected Sql_DbObject db;
        public string AreaName;
        public int AreaId;
        public string Version;

        public BaseBussiness()
        {
            this.AreaName = "Area 1";
            this.AreaId = 1;
            this.Version = "3.6";
            this.db = new Sql_DbObject("WebConfig", "DefaultConnection");
        }

        public DataTable GetPage(
          string queryStr,
          string queryWhere,
          int pageCurrent,
          int pageSize,
          string fdShow,
          string fdOreder,
          string fdKey,
          ref int total)
        {
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[8]
                {
          new SqlParameter("@QueryStr", (object) queryStr),
          new SqlParameter("@QueryWhere", (object) queryWhere),
          new SqlParameter("@PageSize", (object) pageSize),
          new SqlParameter("@PageCurrent", (object) pageCurrent),
          new SqlParameter("@FdShow", (object) fdShow),
          new SqlParameter("@FdOrder", (object) fdOreder),
          new SqlParameter("@FdKey", (object) fdKey),
          new SqlParameter("@TotalRow", (object) total)
                };
                SqlParameters[7].Direction = ParameterDirection.Output;
                DataTable dataTable = this.db.GetDataTable(queryStr, "SP_CustomPage", SqlParameters, 120);
                total = (int)SqlParameters[7].Value;
                return dataTable;
            }
            catch (Exception ex)
            {
                Logger.Error("Init " + ex.ToString());
            }
            return new DataTable(queryStr);
        }

        public List<string> GetColumnsName(string tableName)
        {
            List<string> stringList = new List<string>();
            SqlDataReader Sdr = (SqlDataReader)null;
            try
            {
                this.db.FillSqlDataReader(ref Sdr, "SELECT column_name FROM information_schema.columns WHERE table_name = '" + tableName + "'");
                while (Sdr.Read())
                    stringList.Add((string)Sdr["column_name"]);
            }
            catch (Exception ex)
            {
                Logger.Error("ColumnsName " + ex.ToString());
            }
            finally
            {
                if (Sdr != null && !Sdr.IsClosed)
                    Sdr.Close();
            }
            return stringList;
        }

        public T InitDataReader<T>(SqlDataReader reader) where T : new()
        {
            T obj = new T();
            for (int ordinal = 0; ordinal < reader.FieldCount; ++ordinal)
            {
                string name = reader.GetName(ordinal);
                PropertyInfo property = obj.GetType().GetProperty(name, BindingFlags.Instance | BindingFlags.Public);
                if ((PropertyInfo)null != property && property.CanWrite)
                    property.SetValue((object)obj, Convert.ChangeType(reader[name], property.PropertyType), (object[])null);
            }
            PropertyInfo property1 = obj.GetType().GetProperty("ZoneID", BindingFlags.Instance | BindingFlags.Public);
            if ((PropertyInfo)null != property1)
                property1.SetValue((object)obj, Convert.ChangeType((object)this.AreaId, property1.PropertyType), (object[])null);
            PropertyInfo property2 = obj.GetType().GetProperty("ZoneName", BindingFlags.Instance | BindingFlags.Public);
            if ((PropertyInfo)null != property2)
                property2.SetValue((object)obj, Convert.ChangeType((object)this.AreaName, property2.PropertyType), (object[])null);
            return obj;
        }

        public T InitDataRow<T>(DataRow reader) where T : new()
        {
            T obj = new T();
            for (int index = 0; index < reader.Table.Columns.Count; ++index)
            {
                string columnName = reader.Table.Columns[index].ColumnName;
                PropertyInfo property = obj.GetType().GetProperty(columnName, BindingFlags.Instance | BindingFlags.Public);
                if ((PropertyInfo)null != property && property.CanWrite)
                    property.SetValue((object)obj, Convert.ChangeType(reader[columnName], property.PropertyType), (object[])null);
            }
            PropertyInfo property1 = obj.GetType().GetProperty("ZoneID", BindingFlags.Instance | BindingFlags.Public);
            property1?.SetValue((object)obj, Convert.ChangeType((object)this.AreaId, property1.PropertyType), (object[])null);
            PropertyInfo property2 = obj.GetType().GetProperty("ZoneName", BindingFlags.Instance | BindingFlags.Public);
            property2?.SetValue((object)obj, Convert.ChangeType((object)this.AreaName, property2.PropertyType), (object[])null);
            return obj;
        }

        public void Dispose()
        {
            this.db.Dispose();
            GC.SuppressFinalize((object)this);
        }
    }
}
