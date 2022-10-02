// Decompiled with JetBrains decompiler
// Type: Tank.Data.UrlTankMgr
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
  public class UrlTankMgr
  {
    private static Dictionary<int, UrlTankInfo> m_urlTanks = new Dictionary<int, UrlTankInfo>();

    public static bool Init() => UrlTankMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, UrlTankInfo> dictionary = UrlTankMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, UrlTankInfo>>(ref UrlTankMgr.m_urlTanks, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("UrlTankMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, UrlTankInfo> LoadFromDatabase()
    {
      Dictionary<int, UrlTankInfo> dictionary = new Dictionary<int, UrlTankInfo>();
      using (WebBussiness webBussiness = new WebBussiness())
      {
        foreach (UrlTankInfo urlTankInfo in webBussiness.GetAllUrlTank())
        {
          if (!dictionary.ContainsKey(urlTankInfo.ID))
            dictionary.Add(urlTankInfo.ID, urlTankInfo);
        }
      }
      return dictionary;
    }

    public static List<UrlTankInfo> GetAllUrlTank()
    {
      if (UrlTankMgr.m_urlTanks.Count == 0)
        UrlTankMgr.Init();
      return UrlTankMgr.m_urlTanks.Values.ToList<UrlTankInfo>();
    }

    public static UrlTankInfo FindUrlTank(int id)
    {
      if (UrlTankMgr.m_urlTanks.Count == 0)
        UrlTankMgr.Init();
      return UrlTankMgr.m_urlTanks.ContainsKey(id) ? UrlTankMgr.m_urlTanks[id] : (UrlTankInfo) null;
    }
  }
}
