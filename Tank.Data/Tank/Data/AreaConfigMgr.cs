// Decompiled with JetBrains decompiler
// Type: Tank.Data.AreaConfigMgr
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
  public class AreaConfigMgr
  {
    private static Dictionary<int, AreaConfigInfo> m_areaConfigs = new Dictionary<int, AreaConfigInfo>();

    public static bool Init() => AreaConfigMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, AreaConfigInfo> dictionary = AreaConfigMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, AreaConfigInfo>>(ref AreaConfigMgr.m_areaConfigs, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("AreaConfigMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, AreaConfigInfo> LoadFromDatabase()
    {
      Dictionary<int, AreaConfigInfo> dictionary = new Dictionary<int, AreaConfigInfo>();
      using (ServerBussiness serverBussiness = new ServerBussiness())
      {
        foreach (AreaConfigInfo areaConfigInfo in serverBussiness.GetAllAreaConfig())
        {
          if (!dictionary.ContainsKey(areaConfigInfo.AreaID))
            dictionary.Add(areaConfigInfo.AreaID, areaConfigInfo);
        }
      }
      return dictionary;
    }

    public static List<AreaConfigInfo> GetAllAreaConfig()
    {
      if (AreaConfigMgr.m_areaConfigs.Count == 0)
        AreaConfigMgr.Init();
      return AreaConfigMgr.m_areaConfigs.Values.ToList<AreaConfigInfo>();
    }

    public static AreaConfigInfo FindAreaConfig(int id)
    {
      if (AreaConfigMgr.m_areaConfigs.Count == 0)
        AreaConfigMgr.Init();
      return AreaConfigMgr.m_areaConfigs.ContainsKey(id) ? AreaConfigMgr.m_areaConfigs[id] : (AreaConfigInfo) null;
    }
  }
}
