// Decompiled with JetBrains decompiler
// Type: Tank.Data.MountSkillElementTemplateMgr
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
  public class MountSkillElementTemplateMgr
  {
    private static Dictionary<int, MountSkillElementTemplateInfo> m_mountSkillElementTemplates = new Dictionary<int, MountSkillElementTemplateInfo>();

    public static bool Init() => MountSkillElementTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MountSkillElementTemplateInfo> dictionary = MountSkillElementTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MountSkillElementTemplateInfo>>(ref MountSkillElementTemplateMgr.m_mountSkillElementTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MountSkillElementTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MountSkillElementTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, MountSkillElementTemplateInfo> dictionary = new Dictionary<int, MountSkillElementTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MountSkillElementTemplateInfo elementTemplateInfo in produceBussiness.GetAllMountSkillElementTemplate())
        {
          if (!dictionary.ContainsKey(elementTemplateInfo.ID))
            dictionary.Add(elementTemplateInfo.ID, elementTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<MountSkillElementTemplateInfo> GetAllMountSkillElementTemplate()
    {
      if (MountSkillElementTemplateMgr.m_mountSkillElementTemplates.Count == 0)
        MountSkillElementTemplateMgr.Init();
      return MountSkillElementTemplateMgr.m_mountSkillElementTemplates.Values.ToList<MountSkillElementTemplateInfo>();
    }

    public static MountSkillElementTemplateInfo FindMountSkillElementTemplate(
      int id)
    {
      if (MountSkillElementTemplateMgr.m_mountSkillElementTemplates.Count == 0)
        MountSkillElementTemplateMgr.Init();
      return MountSkillElementTemplateMgr.m_mountSkillElementTemplates.ContainsKey(id) ? MountSkillElementTemplateMgr.m_mountSkillElementTemplates[id] : (MountSkillElementTemplateInfo) null;
    }
  }
}
