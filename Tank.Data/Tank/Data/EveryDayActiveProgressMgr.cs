// Decompiled with JetBrains decompiler
// Type: Tank.Data.EveryDayActiveProgressMgr
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
  public class EveryDayActiveProgressMgr
  {
    private static Dictionary<int, EveryDayActiveProgressInfo> m_everyDayActiveProgresss = new Dictionary<int, EveryDayActiveProgressInfo>();

    public static bool Init() => EveryDayActiveProgressMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, EveryDayActiveProgressInfo> dictionary = EveryDayActiveProgressMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, EveryDayActiveProgressInfo>>(ref EveryDayActiveProgressMgr.m_everyDayActiveProgresss, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("EveryDayActiveProgressMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, EveryDayActiveProgressInfo> LoadFromDatabase()
    {
      Dictionary<int, EveryDayActiveProgressInfo> dictionary = new Dictionary<int, EveryDayActiveProgressInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (EveryDayActiveProgressInfo activeProgressInfo in produceBussiness.GetAllEveryDayActiveProgress())
        {
          if (!dictionary.ContainsKey(activeProgressInfo.ID))
            dictionary.Add(activeProgressInfo.ID, activeProgressInfo);
        }
      }
      return dictionary;
    }

    public static List<EveryDayActiveProgressInfo> GetAllEveryDayActiveProgress()
    {
      if (EveryDayActiveProgressMgr.m_everyDayActiveProgresss.Count == 0)
        EveryDayActiveProgressMgr.Init();
      return EveryDayActiveProgressMgr.m_everyDayActiveProgresss.Values.ToList<EveryDayActiveProgressInfo>();
    }

    public static EveryDayActiveProgressInfo FindEveryDayActiveProgress(
      int id)
    {
      if (EveryDayActiveProgressMgr.m_everyDayActiveProgresss.Count == 0)
        EveryDayActiveProgressMgr.Init();
      return EveryDayActiveProgressMgr.m_everyDayActiveProgresss.ContainsKey(id) ? EveryDayActiveProgressMgr.m_everyDayActiveProgresss[id] : (EveryDayActiveProgressInfo) null;
    }
  }
}
