// Decompiled with JetBrains decompiler
// Type: Tank.Data.TotemHonorTemplateMgr
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
  public class TotemHonorTemplateMgr
  {
    private static Dictionary<int, TotemHonorTemplateInfo> m_totemHonorTemplates = new Dictionary<int, TotemHonorTemplateInfo>();

    public static bool Init() => TotemHonorTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, TotemHonorTemplateInfo> dictionary = TotemHonorTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, TotemHonorTemplateInfo>>(ref TotemHonorTemplateMgr.m_totemHonorTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("TotemHonorTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, TotemHonorTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, TotemHonorTemplateInfo> dictionary = new Dictionary<int, TotemHonorTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (TotemHonorTemplateInfo honorTemplateInfo in produceBussiness.GetAllTotemHonorTemplate())
        {
          if (!dictionary.ContainsKey(honorTemplateInfo.ID))
            dictionary.Add(honorTemplateInfo.ID, honorTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<TotemHonorTemplateInfo> GetAllTotemHonorTemplate()
    {
      if (TotemHonorTemplateMgr.m_totemHonorTemplates.Count == 0)
        TotemHonorTemplateMgr.Init();
      return TotemHonorTemplateMgr.m_totemHonorTemplates.Values.ToList<TotemHonorTemplateInfo>();
    }

    public static TotemHonorTemplateInfo FindTotemHonorTemplate(int id)
    {
      if (TotemHonorTemplateMgr.m_totemHonorTemplates.Count == 0)
        TotemHonorTemplateMgr.Init();
      return TotemHonorTemplateMgr.m_totemHonorTemplates.ContainsKey(id) ? TotemHonorTemplateMgr.m_totemHonorTemplates[id] : (TotemHonorTemplateInfo) null;
    }
  }
}
