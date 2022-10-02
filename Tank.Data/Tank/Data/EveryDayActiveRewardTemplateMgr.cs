// Decompiled with JetBrains decompiler
// Type: Tank.Data.EveryDayActiveRewardTemplateMgr
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
  public class EveryDayActiveRewardTemplateMgr
  {
    private static Dictionary<int, EveryDayActiveRewardTemplateInfo> m_everyDayActiveRewardTemplates = new Dictionary<int, EveryDayActiveRewardTemplateInfo>();

    public static bool Init() => EveryDayActiveRewardTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, EveryDayActiveRewardTemplateInfo> dictionary = EveryDayActiveRewardTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, EveryDayActiveRewardTemplateInfo>>(ref EveryDayActiveRewardTemplateMgr.m_everyDayActiveRewardTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("EveryDayActiveRewardTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, EveryDayActiveRewardTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, EveryDayActiveRewardTemplateInfo> dictionary = new Dictionary<int, EveryDayActiveRewardTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (EveryDayActiveRewardTemplateInfo rewardTemplateInfo in produceBussiness.GetAllEveryDayActiveRewardTemplate())
        {
          if (!dictionary.ContainsKey(rewardTemplateInfo.ID))
            dictionary.Add(rewardTemplateInfo.ID, rewardTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<EveryDayActiveRewardTemplateInfo> GetAllEveryDayActiveRewardTemplate()
    {
      if (EveryDayActiveRewardTemplateMgr.m_everyDayActiveRewardTemplates.Count == 0)
        EveryDayActiveRewardTemplateMgr.Init();
      return EveryDayActiveRewardTemplateMgr.m_everyDayActiveRewardTemplates.Values.ToList<EveryDayActiveRewardTemplateInfo>();
    }

    public static EveryDayActiveRewardTemplateInfo FindEveryDayActiveRewardTemplate(
      int id)
    {
      if (EveryDayActiveRewardTemplateMgr.m_everyDayActiveRewardTemplates.Count == 0)
        EveryDayActiveRewardTemplateMgr.Init();
      return EveryDayActiveRewardTemplateMgr.m_everyDayActiveRewardTemplates.ContainsKey(id) ? EveryDayActiveRewardTemplateMgr.m_everyDayActiveRewardTemplates[id] : (EveryDayActiveRewardTemplateInfo) null;
    }
  }
}
