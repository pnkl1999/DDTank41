// Decompiled with JetBrains decompiler
// Type: Tank.Data.TablesMgr
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using Helpers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace Tank.Data
{
  public class TablesMgr
  {
    private static Dictionary<int, List<TableDesignInfo>> m_tableDesigns = new Dictionary<int, List<TableDesignInfo>>();
    private static Dictionary<int, TableInfo> m_tables = new Dictionary<int, TableInfo>();

    public static bool Init()
    {
      try
      {
        Dictionary<int, TableInfo> tables = TablesMgr.loadTableGamesFromDB();
        Dictionary<int, List<TableDesignInfo>> dictionary = TablesMgr.LoadTableDesignDataFromDB(tables);
        if (tables.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, TableInfo>>(ref TablesMgr.m_tables, tables);
          Interlocked.Exchange<Dictionary<int, List<TableDesignInfo>>>(ref TablesMgr.m_tableDesigns, dictionary);
        }
      }
      catch (Exception ex)
      {
        Logger.Error(ex.ToString());
      }
      return true;
    }

    private static Dictionary<int, TableInfo> loadTableGamesFromDB()
    {
      Dictionary<int, TableInfo> dictionary = new Dictionary<int, TableInfo>();
      using (WebBussiness webBussiness = new WebBussiness())
      {
        foreach (TableInfo allTable in webBussiness.GetAllTables())
        {
          if (!dictionary.ContainsKey(allTable.ID))
            dictionary.Add(allTable.ID, allTable);
        }
      }
      return dictionary;
    }

    private static Dictionary<int, List<TableDesignInfo>> LoadTableDesignDataFromDB(
      Dictionary<int, TableInfo> tables)
    {
      Dictionary<int, List<TableDesignInfo>> dictionary = new Dictionary<int, List<TableDesignInfo>>();
      using (WebBussiness webBussiness = new WebBussiness())
      {
        TableDesignInfo[] allTableDesign = webBussiness.GetAllTableDesign();
        foreach (TableInfo tableInfo in tables.Values)
        {
          TableInfo tb = tableInfo;
          IEnumerable<TableDesignInfo> source = ((IEnumerable<TableDesignInfo>) allTableDesign).Where<TableDesignInfo>((Func<TableDesignInfo, bool>) (s => s.TableID == tb.ID));
          dictionary.Add(tb.ID, source.ToList<TableDesignInfo>());
        }
      }
      return dictionary;
    }

    public static List<TableInfo> GetAllTableGames()
    {
      if (TablesMgr.m_tables.Count == 0)
        TablesMgr.Init();
      return TablesMgr.m_tables.Values.ToList<TableInfo>();
    }

    public static TableInfo GetTableGame(int key)
    {
      if (TablesMgr.m_tables.Count == 0)
        TablesMgr.Init();
      return TablesMgr.m_tables.ContainsKey(key) ? TablesMgr.m_tables[key] : (TableInfo) null;
    }

    public static List<TableDesignInfo> GetTableDesigns(int key)
    {
      if (TablesMgr.m_tables.Count == 0)
        TablesMgr.Init();
      return TablesMgr.m_tableDesigns.ContainsKey(key) ? TablesMgr.m_tableDesigns[key] : new List<TableDesignInfo>();
    }
  }
}
