// Decompiled with JetBrains decompiler
// Type: Tank.Data.MountSkillTemplateMgr
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
  public class MountSkillTemplateMgr
  {
    private static Dictionary<int, MountSkillTemplateInfo> m_mountSkillTemplates = new Dictionary<int, MountSkillTemplateInfo>();

    public static bool Init() => MountSkillTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MountSkillTemplateInfo> dictionary = MountSkillTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MountSkillTemplateInfo>>(ref MountSkillTemplateMgr.m_mountSkillTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MountSkillTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MountSkillTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, MountSkillTemplateInfo> dictionary = new Dictionary<int, MountSkillTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MountSkillTemplateInfo skillTemplateInfo in produceBussiness.GetAllMountSkillTemplate())
        {
          if (!dictionary.ContainsKey(skillTemplateInfo.ID))
            dictionary.Add(skillTemplateInfo.ID, skillTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<MountSkillTemplateInfo> GetAllMountSkillTemplate()
    {
      if (MountSkillTemplateMgr.m_mountSkillTemplates.Count == 0)
        MountSkillTemplateMgr.Init();
      return MountSkillTemplateMgr.m_mountSkillTemplates.Values.ToList<MountSkillTemplateInfo>();
    }

    public static MountSkillTemplateInfo FindMountSkillTemplate(int id)
    {
      if (MountSkillTemplateMgr.m_mountSkillTemplates.Count == 0)
        MountSkillTemplateMgr.Init();
      return MountSkillTemplateMgr.m_mountSkillTemplates.ContainsKey(id) ? MountSkillTemplateMgr.m_mountSkillTemplates[id] : (MountSkillTemplateInfo) null;
    }
  }
}
