// Decompiled with JetBrains decompiler
// Type: Tank.Data.SuitTemplateMgr
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
  public class SuitTemplateMgr
  {
    private static Dictionary<int, SuitTemplateInfo> m_suitTemplates = new Dictionary<int, SuitTemplateInfo>();

    public static bool Init() => SuitTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, SuitTemplateInfo> dictionary = SuitTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, SuitTemplateInfo>>(ref SuitTemplateMgr.m_suitTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("SuitTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, SuitTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, SuitTemplateInfo> dictionary = new Dictionary<int, SuitTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (SuitTemplateInfo suitTemplateInfo in produceBussiness.GetAllSuitTemplate())
        {
          if (!dictionary.ContainsKey(suitTemplateInfo.SuitId))
            dictionary.Add(suitTemplateInfo.SuitId, suitTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<SuitTemplateInfo> GetAllSuitTemplate()
    {
      if (SuitTemplateMgr.m_suitTemplates.Count == 0)
        SuitTemplateMgr.Init();
      return SuitTemplateMgr.m_suitTemplates.Values.ToList<SuitTemplateInfo>();
    }

    public static SuitTemplateInfo FindSuitTemplate(int id)
    {
      if (SuitTemplateMgr.m_suitTemplates.Count == 0)
        SuitTemplateMgr.Init();
      return SuitTemplateMgr.m_suitTemplates.ContainsKey(id) ? SuitTemplateMgr.m_suitTemplates[id] : (SuitTemplateInfo) null;
    }
  }
}
