// Decompiled with JetBrains decompiler
// Type: Tank.Data.ConsortiaBadgeConfigMgr
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
  public class ConsortiaBadgeConfigMgr
  {
    private static Dictionary<int, ConsortiaBadgeConfigInfo> m_consortiaBadgeConfigs = new Dictionary<int, ConsortiaBadgeConfigInfo>();

    public static bool Init() => ConsortiaBadgeConfigMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ConsortiaBadgeConfigInfo> dictionary = ConsortiaBadgeConfigMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ConsortiaBadgeConfigInfo>>(ref ConsortiaBadgeConfigMgr.m_consortiaBadgeConfigs, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("ConsortiaBadgeConfigMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ConsortiaBadgeConfigInfo> LoadFromDatabase()
    {
      Dictionary<int, ConsortiaBadgeConfigInfo> dictionary = new Dictionary<int, ConsortiaBadgeConfigInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ConsortiaBadgeConfigInfo consortiaBadgeConfigInfo in produceBussiness.GetAllConsortiaBadgeConfig())
        {
          if (!dictionary.ContainsKey(consortiaBadgeConfigInfo.BadgeID))
            dictionary.Add(consortiaBadgeConfigInfo.BadgeID, consortiaBadgeConfigInfo);
        }
      }
      return dictionary;
    }

    public static List<ConsortiaBadgeConfigInfo> GetAllConsortiaBadgeConfig()
    {
      if (ConsortiaBadgeConfigMgr.m_consortiaBadgeConfigs.Count == 0)
        ConsortiaBadgeConfigMgr.Init();
      return ConsortiaBadgeConfigMgr.m_consortiaBadgeConfigs.Values.ToList<ConsortiaBadgeConfigInfo>();
    }

    public static ConsortiaBadgeConfigInfo FindConsortiaBadgeConfig(int id)
    {
      if (ConsortiaBadgeConfigMgr.m_consortiaBadgeConfigs.Count == 0)
        ConsortiaBadgeConfigMgr.Init();
      return ConsortiaBadgeConfigMgr.m_consortiaBadgeConfigs.ContainsKey(id) ? ConsortiaBadgeConfigMgr.m_consortiaBadgeConfigs[id] : (ConsortiaBadgeConfigInfo) null;
    }
  }
}
