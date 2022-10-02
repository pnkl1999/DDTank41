// Decompiled with JetBrains decompiler
// Type: Tank.Data.CombineBussiness
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using Helpers;
using SqlDataProvider.BaseClass;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;

namespace Tank.Data
{
  public class CombineBussiness : BaseBussiness
  {
    private static AreaConfigInfo _serverB;

    public CombineBussiness(AreaConfigInfo configA, AreaConfigInfo configB)
    {
      StringBuilder stringBuilder = new StringBuilder();
      stringBuilder.Append("Data Source=");
      stringBuilder.Append(configA.DataSource);
      stringBuilder.Append("; Initial Catalog=");
      stringBuilder.Append(configA.Catalog);
      stringBuilder.Append("; Persist Security Info=True;User ID=");
      stringBuilder.Append(configA.UserID);
      stringBuilder.Append("; Password=");
      stringBuilder.Append(configA.Password);
      stringBuilder.Append(";");
      this.db = new Sql_DbObject("AreaConfig", stringBuilder.ToString());
      CombineBussiness._serverB = configB;
    }

    public bool Combine(
      string tableName,
      CombineTableInfo info,
      Dictionary<string, int> tableIdentity)
    {
      bool flag = false;
      SqlDataReader sdr = (SqlDataReader) null;
      try
      {
        using (PlayerBussiness playerBussiness = new PlayerBussiness(CombineBussiness._serverB))
        {
          playerBussiness.FillSqlReader(ref sdr, "SELECT * FROM [dbo].[" + tableName + "]");
          bool onOff = !string.IsNullOrEmpty(info.IdEntityColumn);
          while (sdr.Read())
          {
            string Sqlcomm = this.BuildInsert(sdr, tableName, onOff);
            SqlParameter[] SqlParameters = new SqlParameter[sdr.FieldCount];
            for (int ordinal = 0; ordinal < sdr.FieldCount; ++ordinal)
            {
              string name = sdr.GetName(ordinal);
              string str = string.IsNullOrEmpty(sdr[name].ToString()) ? "0" : sdr[name].ToString();
              if (onOff && info.IdEntityColumn == name)
              {
                int num = int.Parse(str) + tableIdentity[info.Name];
                SqlParameters[ordinal] = new SqlParameter("@" + name, (object) num);
              }
              else
              {
                int num1;
                if (!string.IsNullOrEmpty(info.ConditionColumn1))
                  num1 = info.ConditionColumn1.Split('|')[0] == name ? 1 : 0;
                else
                  num1 = 0;
                if (num1 != 0)
                {
                  string key = info.ConditionColumn1.Split('|')[1];
                  if (info.Name == "Active_Number")
                  {
                    SqlParameters[ordinal] = new SqlParameter("@" + name, (object) CombineBussiness.PlusActiveNumber(str, tableIdentity[key]));
                  }
                  else
                  {
                    int num2 = int.Parse(str) + tableIdentity[key];
                    SqlParameters[ordinal] = num2 != tableIdentity[key] ? new SqlParameter("@" + name, (object) num2) : new SqlParameter("@" + name, sdr[name]);
                  }
                }
                else
                {
                  int num3;
                  if (!string.IsNullOrEmpty(info.ConditionColumn2))
                    num3 = info.ConditionColumn2.Split('|')[0] == name ? 1 : 0;
                  else
                    num3 = 0;
                  if (num3 != 0)
                  {
                    string key = info.ConditionColumn2.Split('|')[1];
                    int num4 = int.Parse(str) + tableIdentity[key];
                    SqlParameters[ordinal] = num4 != tableIdentity[key] ? new SqlParameter("@" + name, (object) num4) : new SqlParameter("@" + name, sdr[name]);
                  }
                  else
                  {
                    int num5;
                    if (!string.IsNullOrEmpty(info.ConditionColumn3))
                      num5 = info.ConditionColumn3.Split('|')[0] == name ? 1 : 0;
                    else
                      num5 = 0;
                    if (num5 != 0)
                    {
                      string key = info.ConditionColumn3.Split('|')[1];
                      int num6 = int.Parse(str) + tableIdentity[key];
                      SqlParameters[ordinal] = num6 != tableIdentity[key] ? new SqlParameter("@" + name, (object) num6) : new SqlParameter("@" + name, sdr[name]);
                    }
                    else
                    {
                      int num7;
                      if (!string.IsNullOrEmpty(info.ConditionColumn4))
                        num7 = info.ConditionColumn4.Split('|')[0] == name ? 1 : 0;
                      else
                        num7 = 0;
                      if (num7 != 0)
                      {
                        string key = info.ConditionColumn4.Split('|')[1];
                        int num8 = int.Parse(str) + tableIdentity[key];
                        SqlParameters[ordinal] = num8 != tableIdentity[key] ? new SqlParameter("@" + name, (object) num8) : new SqlParameter("@" + name, sdr[name]);
                      }
                      else
                      {
                        int num9;
                        if (!string.IsNullOrEmpty(info.ConditionColumn5))
                          num9 = info.ConditionColumn5.Split('|')[0] == name ? 1 : 0;
                        else
                          num9 = 0;
                        if (num9 != 0)
                        {
                          string key = info.ConditionColumn5.Split('|')[1];
                          int num10 = int.Parse(str) + tableIdentity[key];
                          SqlParameters[ordinal] = num10 != tableIdentity[key] ? new SqlParameter("@" + name, (object) num10) : new SqlParameter("@" + name, sdr[name]);
                        }
                        else
                        {
                          int num11;
                          if (!string.IsNullOrEmpty(info.ConditionColumn6))
                            num11 = info.ConditionColumn6.Split('|')[0] == name ? 1 : 0;
                          else
                            num11 = 0;
                          if (num11 != 0)
                          {
                            string key = info.ConditionColumn6.Split('|')[1];
                            int num12 = int.Parse(str) + tableIdentity[key];
                            SqlParameters[ordinal] = num12 != tableIdentity[key] ? new SqlParameter("@" + name, (object) num12) : new SqlParameter("@" + name, sdr[name]);
                          }
                          else
                          {
                            int num13;
                            if (!string.IsNullOrEmpty(info.ConditionColumn7))
                              num13 = info.ConditionColumn7.Split('|')[0] == name ? 1 : 0;
                            else
                              num13 = 0;
                            if (num13 != 0)
                            {
                              string key = info.ConditionColumn7.Split('|')[1];
                              int num14 = int.Parse(str) + tableIdentity[key];
                              SqlParameters[ordinal] = num14 != tableIdentity[key] ? new SqlParameter("@" + name, (object) num14) : new SqlParameter("@" + name, sdr[name]);
                            }
                            else
                            {
                              int num15;
                              if (!string.IsNullOrEmpty(info.ConditionColumn8))
                                num15 = info.ConditionColumn8.Split('|')[0] == name ? 1 : 0;
                              else
                                num15 = 0;
                              if (num15 != 0)
                              {
                                string key = info.ConditionColumn8.Split('|')[1];
                                int num16 = int.Parse(str) + tableIdentity[key];
                                SqlParameters[ordinal] = num16 != tableIdentity[key] ? new SqlParameter("@" + name, (object) num16) : new SqlParameter("@" + name, sdr[name]);
                              }
                              else
                                SqlParameters[ordinal] = new SqlParameter("@" + name, sdr[name]);
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
            flag = this.db.Exesqlcomm(Sqlcomm, SqlParameters);
          }
        }
      }
      catch (Exception ex)
      {
        Logger.Error("Combine: " + ex.ToString());
        return false;
      }
      finally
      {
        if (sdr != null && !sdr.IsClosed)
          sdr.Close();
      }
      return flag;
    }

    private string BuildInsert(SqlDataReader reader, string tbName, bool onOff)
    {
      StringBuilder stringBuilder = new StringBuilder();
      if (onOff)
        stringBuilder.Append("SET IDENTITY_INSERT [dbo].[" + tbName + "] ON ");
      stringBuilder.Append(" INSERT INTO ");
      stringBuilder.Append("[dbo].[");
      stringBuilder.Append(tbName);
      stringBuilder.Append("]");
      stringBuilder.Append("(");
      int num1 = 0;
      for (int ordinal = 0; ordinal < reader.FieldCount; ++ordinal)
      {
        string name = reader.GetName(ordinal);
        stringBuilder.Append("[");
        stringBuilder.Append(name);
        stringBuilder.Append("]");
        ++num1;
        if (num1 < reader.FieldCount)
          stringBuilder.Append(",");
      }
      stringBuilder.Append(")");
      stringBuilder.Append(" VALUES ");
      int num2 = 0;
      stringBuilder.Append("(");
      for (int ordinal = 0; ordinal < reader.FieldCount; ++ordinal)
      {
        string name = reader.GetName(ordinal);
        stringBuilder.Append("@");
        stringBuilder.Append(name);
        ++num2;
        if (num2 < reader.FieldCount)
          stringBuilder.Append(",");
      }
      stringBuilder.Append(")");
      if (onOff)
        stringBuilder.Append(" SET IDENTITY_INSERT [dbo].[" + tbName + "] OFF");
      return stringBuilder.ToString();
    }

    public static string PlusActiveNumber(string code, int max)
    {
      if (!CombineBussiness.IsActiveNumber(code))
        return code == null ? "" : code;
      string[] strArray = code.Split('-');
      int num = int.Parse(strArray[2]) + max;
      return strArray[0] + "-" + strArray[1] + "-" + (object) num;
    }

    public static bool IsActiveNumber(string code)
    {
      if (string.IsNullOrEmpty(code))
        return false;
      return code.Split('-').Length == 3;
    }
  }
}
