// Decompiled with JetBrains decompiler
// Type: Tank.Data.LevelMgr
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
  public class LevelMgr
  {
    private static Dictionary<int, LevelInfo> m_levels = new Dictionary<int, LevelInfo>();

    public static bool Init() => LevelMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, LevelInfo> dictionary = LevelMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, LevelInfo>>(ref LevelMgr.m_levels, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("LevelMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, LevelInfo> LoadFromDatabase()
    {
      Dictionary<int, LevelInfo> dictionary = new Dictionary<int, LevelInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (LevelInfo levelInfo in produceBussiness.GetAllLevel())
        {
          if (!dictionary.ContainsKey(levelInfo.Grade))
            dictionary.Add(levelInfo.Grade, levelInfo);
        }
      }
      return dictionary;
    }

    public static List<LevelInfo> GetAllLevel()
    {
      if (LevelMgr.m_levels.Count == 0)
        LevelMgr.Init();
      return LevelMgr.m_levels.Values.ToList<LevelInfo>();
    }

    public static LevelInfo FindLevel(int id)
    {
      if (LevelMgr.m_levels.Count == 0)
        LevelMgr.Init();
      return LevelMgr.m_levels.ContainsKey(id) ? LevelMgr.m_levels[id] : (LevelInfo) null;
    }
  }
}
