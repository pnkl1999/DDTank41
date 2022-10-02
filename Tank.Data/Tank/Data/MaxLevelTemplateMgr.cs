// Decompiled with JetBrains decompiler
// Type: Tank.Data.MaxLevelTemplateMgr
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
  public class MaxLevelTemplateMgr
  {
    private static Dictionary<int, MaxLevelTemplateInfo> m_maxLevelTemplates = new Dictionary<int, MaxLevelTemplateInfo>();

    public static bool Init() => MaxLevelTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MaxLevelTemplateInfo> dictionary = MaxLevelTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MaxLevelTemplateInfo>>(ref MaxLevelTemplateMgr.m_maxLevelTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MaxLevelTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MaxLevelTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, MaxLevelTemplateInfo> dictionary = new Dictionary<int, MaxLevelTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MaxLevelTemplateInfo levelTemplateInfo in produceBussiness.GetAllMaxLevelTemplate())
        {
          if (!dictionary.ContainsKey(levelTemplateInfo.Level))
            dictionary.Add(levelTemplateInfo.Level, levelTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<MaxLevelTemplateInfo> GetAllMaxLevelTemplate()
    {
      if (MaxLevelTemplateMgr.m_maxLevelTemplates.Count == 0)
        MaxLevelTemplateMgr.Init();
      return MaxLevelTemplateMgr.m_maxLevelTemplates.Values.ToList<MaxLevelTemplateInfo>();
    }

    public static MaxLevelTemplateInfo FindMaxLevelTemplate(int id)
    {
      if (MaxLevelTemplateMgr.m_maxLevelTemplates.Count == 0)
        MaxLevelTemplateMgr.Init();
      return MaxLevelTemplateMgr.m_maxLevelTemplates.ContainsKey(id) ? MaxLevelTemplateMgr.m_maxLevelTemplates[id] : (MaxLevelTemplateInfo) null;
    }
  }
}
