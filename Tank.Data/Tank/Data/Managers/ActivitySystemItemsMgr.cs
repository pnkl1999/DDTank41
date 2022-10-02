// Decompiled with JetBrains decompiler
// Type: Tank.Data.Managers.ActivitySystemItemsMgr
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using Helpers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace Tank.Data.Managers
{
  public class ActivitySystemItemsMgr
  {
    private static Dictionary<int, ActivitySystemItemInfo> m_dailyAwards = new Dictionary<int, ActivitySystemItemInfo>();

    public static bool Init() => ActivitySystemItemsMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ActivitySystemItemInfo> dictionary = ActivitySystemItemsMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ActivitySystemItemInfo>>(ref ActivitySystemItemsMgr.m_dailyAwards, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("DailyAwardMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ActivitySystemItemInfo> LoadFromDatabase()
    {
      Dictionary<int, ActivitySystemItemInfo> dictionary = new Dictionary<int, ActivitySystemItemInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ActivitySystemItemInfo activitySystemItem in produceBussiness.GetAllActivitySystemItems())
        {
          if (!dictionary.ContainsKey(activitySystemItem.ID))
            dictionary.Add(activitySystemItem.ID, activitySystemItem);
        }
      }
      return dictionary;
    }

    public static List<ActivitySystemItemInfo> GetAllActivitySystemItems()
    {
      if (ActivitySystemItemsMgr.m_dailyAwards.Count == 0)
        ActivitySystemItemsMgr.Init();
      return ActivitySystemItemsMgr.m_dailyAwards.Values.ToList<ActivitySystemItemInfo>();
    }

    public static ActivitySystemItemInfo FindActivitySystemItems(
      int activeid,
      int quailty,
      int templateid)
    {
      if (ActivitySystemItemsMgr.m_dailyAwards.Count == 0)
        ActivitySystemItemsMgr.Init();
      return ActivitySystemItemsMgr.m_dailyAwards.Values.SingleOrDefault<ActivitySystemItemInfo>((Func<ActivitySystemItemInfo, bool>) (a => a.ActivityType == activeid && a.Quality == quailty && a.TemplateID == templateid));
    }
  }
}
