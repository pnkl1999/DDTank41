// Decompiled with JetBrains decompiler
// Type: Tank.Data.ConsortiaBossConfigMgr
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
  public class ConsortiaBossConfigMgr
  {
    private static Dictionary<int, ConsortiaBossConfigInfo> m_consortiaBossConfigs = new Dictionary<int, ConsortiaBossConfigInfo>();

    public static bool Init() => ConsortiaBossConfigMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ConsortiaBossConfigInfo> dictionary = ConsortiaBossConfigMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ConsortiaBossConfigInfo>>(ref ConsortiaBossConfigMgr.m_consortiaBossConfigs, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("ConsortiaBossConfigMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ConsortiaBossConfigInfo> LoadFromDatabase()
    {
      Dictionary<int, ConsortiaBossConfigInfo> dictionary = new Dictionary<int, ConsortiaBossConfigInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ConsortiaBossConfigInfo consortiaBossConfigInfo in produceBussiness.GetAllConsortiaBossConfig())
        {
          if (!dictionary.ContainsKey(consortiaBossConfigInfo.NpcID))
            dictionary.Add(consortiaBossConfigInfo.NpcID, consortiaBossConfigInfo);
        }
      }
      return dictionary;
    }

    public static List<ConsortiaBossConfigInfo> GetAllConsortiaBossConfig()
    {
      if (ConsortiaBossConfigMgr.m_consortiaBossConfigs.Count == 0)
        ConsortiaBossConfigMgr.Init();
      return ConsortiaBossConfigMgr.m_consortiaBossConfigs.Values.ToList<ConsortiaBossConfigInfo>();
    }

    public static ConsortiaBossConfigInfo FindConsortiaBossConfig(int id)
    {
      if (ConsortiaBossConfigMgr.m_consortiaBossConfigs.Count == 0)
        ConsortiaBossConfigMgr.Init();
      return ConsortiaBossConfigMgr.m_consortiaBossConfigs.ContainsKey(id) ? ConsortiaBossConfigMgr.m_consortiaBossConfigs[id] : (ConsortiaBossConfigInfo) null;
    }
  }
}
