// Decompiled with JetBrains decompiler
// Type: Tank.Data.DailyAwardMgr
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
  public class DailyAwardMgr
  {
    private static Dictionary<int, DailyAwardInfo> m_dailyAwards = new Dictionary<int, DailyAwardInfo>();

    public static bool Init() => DailyAwardMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, DailyAwardInfo> dictionary = DailyAwardMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, DailyAwardInfo>>(ref DailyAwardMgr.m_dailyAwards, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("DailyAwardMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, DailyAwardInfo> LoadFromDatabase()
    {
      Dictionary<int, DailyAwardInfo> dictionary = new Dictionary<int, DailyAwardInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (DailyAwardInfo dailyAwardInfo in produceBussiness.GetAllDailyAward())
        {
          if (!dictionary.ContainsKey(dailyAwardInfo.ID))
            dictionary.Add(dailyAwardInfo.ID, dailyAwardInfo);
        }
      }
      return dictionary;
    }

    public static List<DailyAwardInfo> GetAllDailyAward()
    {
      if (DailyAwardMgr.m_dailyAwards.Count == 0)
        DailyAwardMgr.Init();
      return DailyAwardMgr.m_dailyAwards.Values.ToList<DailyAwardInfo>();
    }

    public static DailyAwardInfo FindDailyAward(int id)
    {
      if (DailyAwardMgr.m_dailyAwards.Count == 0)
        DailyAwardMgr.Init();
      return DailyAwardMgr.m_dailyAwards.ContainsKey(id) ? DailyAwardMgr.m_dailyAwards[id] : (DailyAwardInfo) null;
    }
  }
}
