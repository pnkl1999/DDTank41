// Decompiled with JetBrains decompiler
// Type: Tank.Data.FusionMgr
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
  public class FusionMgr
  {
    private static Dictionary<int, FusionInfo> m_fusions = new Dictionary<int, FusionInfo>();

    public static bool Init() => FusionMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, FusionInfo> dictionary = FusionMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, FusionInfo>>(ref FusionMgr.m_fusions, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("FusionMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, FusionInfo> LoadFromDatabase()
    {
      Dictionary<int, FusionInfo> dictionary = new Dictionary<int, FusionInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (FusionInfo fusionInfo in produceBussiness.GetAllFusion())
        {
          if (!dictionary.ContainsKey(fusionInfo.FusionID))
            dictionary.Add(fusionInfo.FusionID, fusionInfo);
        }
      }
      return dictionary;
    }

    public static List<FusionInfo> GetAllFusion()
    {
      if (FusionMgr.m_fusions.Count == 0)
        FusionMgr.Init();
      return FusionMgr.m_fusions.Values.ToList<FusionInfo>();
    }

    public static FusionInfo FindFusion(int id)
    {
      if (FusionMgr.m_fusions.Count == 0)
        FusionMgr.Init();
      return FusionMgr.m_fusions.ContainsKey(id) ? FusionMgr.m_fusions[id] : (FusionInfo) null;
    }
  }
}
