// Decompiled with JetBrains decompiler
// Type: Tank.Data.GuardCoreLevelTemplateMgr
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
  public class GuardCoreLevelTemplateMgr
  {
    private static Dictionary<int, GuardCoreLevelTemplateInfo> m_guardCoreLevelTemplates = new Dictionary<int, GuardCoreLevelTemplateInfo>();

    public static bool Init() => GuardCoreLevelTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, GuardCoreLevelTemplateInfo> dictionary = GuardCoreLevelTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, GuardCoreLevelTemplateInfo>>(ref GuardCoreLevelTemplateMgr.m_guardCoreLevelTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("GuardCoreLevelTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, GuardCoreLevelTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, GuardCoreLevelTemplateInfo> dictionary = new Dictionary<int, GuardCoreLevelTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (GuardCoreLevelTemplateInfo levelTemplateInfo in produceBussiness.GetAllGuardCoreLevelTemplate())
        {
          if (!dictionary.ContainsKey(levelTemplateInfo.Grade))
            dictionary.Add(levelTemplateInfo.Grade, levelTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<GuardCoreLevelTemplateInfo> GetAllGuardCoreLevelTemplate()
    {
      if (GuardCoreLevelTemplateMgr.m_guardCoreLevelTemplates.Count == 0)
        GuardCoreLevelTemplateMgr.Init();
      return GuardCoreLevelTemplateMgr.m_guardCoreLevelTemplates.Values.ToList<GuardCoreLevelTemplateInfo>();
    }

    public static GuardCoreLevelTemplateInfo FindGuardCoreLevelTemplate(
      int id)
    {
      if (GuardCoreLevelTemplateMgr.m_guardCoreLevelTemplates.Count == 0)
        GuardCoreLevelTemplateMgr.Init();
      return GuardCoreLevelTemplateMgr.m_guardCoreLevelTemplates.ContainsKey(id) ? GuardCoreLevelTemplateMgr.m_guardCoreLevelTemplates[id] : (GuardCoreLevelTemplateInfo) null;
    }
  }
}
