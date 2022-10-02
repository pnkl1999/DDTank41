// Decompiled with JetBrains decompiler
// Type: Tank.Data.CombineTableMgr
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using Helpers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace Tank.Data
{
  public class CombineTableMgr
  {
    private static Dictionary<int, CombineTableInfo> _combineTables = new Dictionary<int, CombineTableInfo>();
    private static Dictionary<string, int> _tableIdentity = new Dictionary<string, int>();
    private static CombineTableInfo[] _tBArray;
    private static StringBuilder _mainSb = new StringBuilder();
    private static int _idCount;
    private static int _step = 1;
    private static bool _running;
    private static AreaConfigInfo _serverA;
    private static AreaConfigInfo _serverB;

    public static string ProcessCombine(int serverA, int serverB)
    {
      try
      {
        CombineTableMgr._mainSb = new StringBuilder();
        if (!CombineTableMgr._running)
        {
          CombineTableMgr._tBArray = CombineTableMgr._combineTables.Values.ToArray<CombineTableInfo>();
          CombineTableMgr._serverA = AreaConfigMgr.FindAreaConfig(serverA);
          CombineTableMgr._serverB = AreaConfigMgr.FindAreaConfig(serverB);
          CombineTableMgr._step = 1;
          CombineTableMgr._idCount = 0;
          CombineTableMgr._running = true;
        }
        string name = CombineTableMgr._tBArray[CombineTableMgr._idCount].Name;
        string idEntityColumn = CombineTableMgr._tBArray[CombineTableMgr._idCount].IdEntityColumn;
        switch (CombineTableMgr._step)
        {
          case 1:
            CombineTableMgr._mainSb.AppendLine(LanguageMgr.GetTranslation("CombineTableMgr.Step1", (object) CombineTableMgr._serverA.AreaName));
            if (CombineTableMgr._tableIdentity.ContainsKey(name))
            {
              using (PlayerBussiness playerBussiness = new PlayerBussiness(CombineTableMgr._serverA))
              {
                CombineTableMgr._tableIdentity[name] = playerBussiness.GetMaxIdByTable(name, idEntityColumn);
                break;
              }
            }
            else
              break;
          case 2:
            CombineTableMgr._mainSb.AppendLine(LanguageMgr.GetTranslation("CombineTableMgr.Step1", (object) CombineTableMgr._serverA.AreaName));
            CombineTableMgr._mainSb.AppendLine(LanguageMgr.GetTranslation("CombineTableMgr.Step2", (object) CombineTableMgr._serverB.AreaName));
            if (CombineTableMgr._tableIdentity.ContainsKey(name))
            {
              using (PlayerBussiness playerBussiness = new PlayerBussiness(CombineTableMgr._serverB))
              {
                int maxIdByTable = playerBussiness.GetMaxIdByTable(name, idEntityColumn);
                if (CombineTableMgr._tableIdentity[name] < maxIdByTable)
                  CombineTableMgr._tableIdentity[name] = maxIdByTable;
              }
              break;
            }
            break;
          case 3:
            CombineTableMgr._mainSb.AppendLine(LanguageMgr.GetTranslation("CombineTableMgr.Step1", (object) CombineTableMgr._serverA.AreaName));
            CombineTableMgr._mainSb.AppendLine(LanguageMgr.GetTranslation("CombineTableMgr.Step2", (object) CombineTableMgr._serverB.AreaName));
            CombineTableMgr._mainSb.AppendLine(LanguageMgr.GetTranslation("CombineTableMgr.Step3", (object) CombineTableMgr._serverB.AreaName, (object) CombineTableMgr._serverA.AreaName));
            using (CombineBussiness combineBussiness = new CombineBussiness(CombineTableMgr._serverA, CombineTableMgr._serverB))
            {
              combineBussiness.Combine(name, CombineTableMgr._tBArray[CombineTableMgr._idCount], CombineTableMgr._tableIdentity);
              break;
            }
        }
        if (CombineTableMgr._idCount + 1 < CombineTableMgr._combineTables.Count)
          CombineTableMgr._mainSb.AppendLine("Current process: " + CombineTableMgr._tBArray[CombineTableMgr._idCount + 1].Name + "<br>");
        ++CombineTableMgr._idCount;
        if (CombineTableMgr._idCount == CombineTableMgr._combineTables.Count && CombineTableMgr._step >= 3)
        {
          CombineTableMgr._running = false;
          CombineTableMgr._mainSb.AppendLine("<p class=\"text-success\"><strong>Complete combine!</strong><p>");
        }
        if (CombineTableMgr._idCount == CombineTableMgr._combineTables.Count)
        {
          CombineTableMgr._idCount = 0;
          ++CombineTableMgr._step;
        }
      }
      catch (Exception ex)
      {
        CombineTableMgr._mainSb.AppendLine("<p class=\"text-danger\"><strong>If see this error press F5 and try again!</strong><p>");
        CombineTableMgr._mainSb.AppendLine("<div class=\"text-warning\">_idCount: " + (object) CombineTableMgr._idCount);
        CombineTableMgr._mainSb.AppendLine("<br>_tBArray: " + (object) CombineTableMgr._tBArray.Length);
        CombineTableMgr._mainSb.AppendLine("<br>_tableIdentity: " + (object) CombineTableMgr._tableIdentity.Count);
        CombineTableMgr._mainSb.AppendLine("<br><em class=\"text-danger\">Error:" + (object) ex);
        CombineTableMgr._mainSb.AppendLine("</em></div>");
        return CombineTableMgr._mainSb.ToString();
      }
      return CombineTableMgr._mainSb.ToString();
    }

    public static bool Init(int type) => CombineTableMgr.ReLoad(type);

    public static bool ReLoad(int type)
    {
      try
      {
        Dictionary<int, CombineTableInfo> dictionary = CombineTableMgr.LoadFromDatabase(type);
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, CombineTableInfo>>(ref CombineTableMgr._combineTables, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("CombineTableMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, CombineTableInfo> LoadFromDatabase(
      int type)
    {
      Dictionary<int, CombineTableInfo> dictionary = new Dictionary<int, CombineTableInfo>();
      using (WebBussiness webBussiness = new WebBussiness())
      {
        foreach (CombineTableInfo combineTableInfo in webBussiness.GetAllCombineTableBy(type))
        {
          if (!dictionary.ContainsKey(combineTableInfo.ID))
            dictionary.Add(combineTableInfo.ID, combineTableInfo);
          if (!CombineTableMgr._tableIdentity.ContainsKey(combineTableInfo.Name) && !string.IsNullOrEmpty(combineTableInfo.IdEntityColumn))
            CombineTableMgr._tableIdentity.Add(combineTableInfo.Name, 0);
        }
      }
      return dictionary;
    }

    public static List<CombineTableInfo> GetAllCombineTable() => CombineTableMgr._combineTables.Values.ToList<CombineTableInfo>();

    public static CombineTableInfo FindCombineTable(int id) => CombineTableMgr._combineTables.Count == 0 || !CombineTableMgr._combineTables.ContainsKey(id) ? (CombineTableInfo) null : CombineTableMgr._combineTables[id];
  }
}
