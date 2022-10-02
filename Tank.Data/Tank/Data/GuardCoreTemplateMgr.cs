// Decompiled with JetBrains decompiler
// Type: Tank.Data.GuardCoreTemplateMgr
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
  public class GuardCoreTemplateMgr
  {
    private static Dictionary<int, GuardCoreTemplateInfo> m_guardCoreTemplates = new Dictionary<int, GuardCoreTemplateInfo>();

    public static bool Init() => GuardCoreTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, GuardCoreTemplateInfo> dictionary = GuardCoreTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, GuardCoreTemplateInfo>>(ref GuardCoreTemplateMgr.m_guardCoreTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("GuardCoreTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, GuardCoreTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, GuardCoreTemplateInfo> dictionary = new Dictionary<int, GuardCoreTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (GuardCoreTemplateInfo coreTemplateInfo in produceBussiness.GetAllGuardCoreTemplate())
        {
          if (!dictionary.ContainsKey(coreTemplateInfo.ID))
            dictionary.Add(coreTemplateInfo.ID, coreTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<GuardCoreTemplateInfo> GetAllGuardCoreTemplate()
    {
      if (GuardCoreTemplateMgr.m_guardCoreTemplates.Count == 0)
        GuardCoreTemplateMgr.Init();
      return GuardCoreTemplateMgr.m_guardCoreTemplates.Values.ToList<GuardCoreTemplateInfo>();
    }

    public static GuardCoreTemplateInfo FindGuardCoreTemplate(int id)
    {
      if (GuardCoreTemplateMgr.m_guardCoreTemplates.Count == 0)
        GuardCoreTemplateMgr.Init();
      return GuardCoreTemplateMgr.m_guardCoreTemplates.ContainsKey(id) ? GuardCoreTemplateMgr.m_guardCoreTemplates[id] : (GuardCoreTemplateInfo) null;
    }
  }
}
