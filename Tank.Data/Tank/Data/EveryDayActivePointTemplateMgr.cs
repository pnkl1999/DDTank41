// Decompiled with JetBrains decompiler
// Type: Tank.Data.EveryDayActivePointTemplateMgr
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
  public class EveryDayActivePointTemplateMgr
  {
    private static Dictionary<int, EveryDayActivePointTemplateInfo> m_everyDayActivePointTemplates = new Dictionary<int, EveryDayActivePointTemplateInfo>();

    public static bool Init() => EveryDayActivePointTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, EveryDayActivePointTemplateInfo> dictionary = EveryDayActivePointTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, EveryDayActivePointTemplateInfo>>(ref EveryDayActivePointTemplateMgr.m_everyDayActivePointTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("EveryDayActivePointTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, EveryDayActivePointTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, EveryDayActivePointTemplateInfo> dictionary = new Dictionary<int, EveryDayActivePointTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (EveryDayActivePointTemplateInfo pointTemplateInfo in produceBussiness.GetAllEveryDayActivePointTemplate())
        {
          if (!dictionary.ContainsKey(pointTemplateInfo.ID))
            dictionary.Add(pointTemplateInfo.ID, pointTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<EveryDayActivePointTemplateInfo> GetAllEveryDayActivePointTemplate()
    {
      if (EveryDayActivePointTemplateMgr.m_everyDayActivePointTemplates.Count == 0)
        EveryDayActivePointTemplateMgr.Init();
      return EveryDayActivePointTemplateMgr.m_everyDayActivePointTemplates.Values.ToList<EveryDayActivePointTemplateInfo>();
    }

    public static EveryDayActivePointTemplateInfo FindEveryDayActivePointTemplate(
      int id)
    {
      if (EveryDayActivePointTemplateMgr.m_everyDayActivePointTemplates.Count == 0)
        EveryDayActivePointTemplateMgr.Init();
      return EveryDayActivePointTemplateMgr.m_everyDayActivePointTemplates.ContainsKey(id) ? EveryDayActivePointTemplateMgr.m_everyDayActivePointTemplates[id] : (EveryDayActivePointTemplateInfo) null;
    }
  }
}
