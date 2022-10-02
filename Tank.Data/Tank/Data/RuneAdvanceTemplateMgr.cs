// Decompiled with JetBrains decompiler
// Type: Tank.Data.RuneAdvanceTemplateMgr
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
  public class RuneAdvanceTemplateMgr
  {
    private static Dictionary<int, RuneAdvanceTemplateInfo> m_runeAdvanceTemplates = new Dictionary<int, RuneAdvanceTemplateInfo>();

    public static bool Init() => RuneAdvanceTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, RuneAdvanceTemplateInfo> dictionary = RuneAdvanceTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, RuneAdvanceTemplateInfo>>(ref RuneAdvanceTemplateMgr.m_runeAdvanceTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("RuneAdvanceTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, RuneAdvanceTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, RuneAdvanceTemplateInfo> dictionary = new Dictionary<int, RuneAdvanceTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (RuneAdvanceTemplateInfo advanceTemplateInfo in produceBussiness.GetAllRuneAdvanceTemplate())
        {
          if (!dictionary.ContainsKey(advanceTemplateInfo.AdvancedTempId))
            dictionary.Add(advanceTemplateInfo.AdvancedTempId, advanceTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<RuneAdvanceTemplateInfo> GetAllRuneAdvanceTemplate()
    {
      if (RuneAdvanceTemplateMgr.m_runeAdvanceTemplates.Count == 0)
        RuneAdvanceTemplateMgr.Init();
      return RuneAdvanceTemplateMgr.m_runeAdvanceTemplates.Values.ToList<RuneAdvanceTemplateInfo>();
    }

    public static RuneAdvanceTemplateInfo FindRuneAdvanceTemplate(int id)
    {
      if (RuneAdvanceTemplateMgr.m_runeAdvanceTemplates.Count == 0)
        RuneAdvanceTemplateMgr.Init();
      return RuneAdvanceTemplateMgr.m_runeAdvanceTemplates.ContainsKey(id) ? RuneAdvanceTemplateMgr.m_runeAdvanceTemplates[id] : (RuneAdvanceTemplateInfo) null;
    }
  }
}
