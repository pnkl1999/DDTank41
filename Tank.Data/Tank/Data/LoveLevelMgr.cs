// Decompiled with JetBrains decompiler
// Type: Tank.Data.LoveLevelMgr
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
  public class LoveLevelMgr
  {
    private static Dictionary<int, LoveLevelInfo> m_loveLevels = new Dictionary<int, LoveLevelInfo>();

    public static bool Init() => LoveLevelMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, LoveLevelInfo> dictionary = LoveLevelMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, LoveLevelInfo>>(ref LoveLevelMgr.m_loveLevels, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("LoveLevelMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, LoveLevelInfo> LoadFromDatabase()
    {
      Dictionary<int, LoveLevelInfo> dictionary = new Dictionary<int, LoveLevelInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (LoveLevelInfo loveLevelInfo in produceBussiness.GetAllLoveLevel())
        {
          if (!dictionary.ContainsKey(loveLevelInfo.Level))
            dictionary.Add(loveLevelInfo.Level, loveLevelInfo);
        }
      }
      return dictionary;
    }

    public static List<LoveLevelInfo> GetAllLoveLevel()
    {
      if (LoveLevelMgr.m_loveLevels.Count == 0)
        LoveLevelMgr.Init();
      return LoveLevelMgr.m_loveLevels.Values.ToList<LoveLevelInfo>();
    }

    public static LoveLevelInfo FindLoveLevel(int id)
    {
      if (LoveLevelMgr.m_loveLevels.Count == 0)
        LoveLevelMgr.Init();
      return LoveLevelMgr.m_loveLevels.ContainsKey(id) ? LoveLevelMgr.m_loveLevels[id] : (LoveLevelInfo) null;
    }
  }
}
