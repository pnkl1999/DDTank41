// Decompiled with JetBrains decompiler
// Type: Tank.Data.RuneTemplateMgr
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
  public class RuneTemplateMgr
  {
    private static Dictionary<int, RuneTemplateInfo> m_runeTemplates = new Dictionary<int, RuneTemplateInfo>();

    public static bool Init() => RuneTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, RuneTemplateInfo> dictionary = RuneTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, RuneTemplateInfo>>(ref RuneTemplateMgr.m_runeTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("RuneTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, RuneTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, RuneTemplateInfo> dictionary = new Dictionary<int, RuneTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (RuneTemplateInfo runeTemplateInfo in produceBussiness.GetAllRuneTemplate())
        {
          if (!dictionary.ContainsKey(runeTemplateInfo.TemplateID))
            dictionary.Add(runeTemplateInfo.TemplateID, runeTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<RuneTemplateInfo> GetAllRuneTemplate()
    {
      if (RuneTemplateMgr.m_runeTemplates.Count == 0)
        RuneTemplateMgr.Init();
      return RuneTemplateMgr.m_runeTemplates.Values.ToList<RuneTemplateInfo>();
    }

    public static RuneTemplateInfo FindRuneTemplate(int id)
    {
      if (RuneTemplateMgr.m_runeTemplates.Count == 0)
        RuneTemplateMgr.Init();
      return RuneTemplateMgr.m_runeTemplates.ContainsKey(id) ? RuneTemplateMgr.m_runeTemplates[id] : (RuneTemplateInfo) null;
    }
  }
}
