// Decompiled with JetBrains decompiler
// Type: Tank.Data.MountSkillGetTemplateMgr
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
  public class MountSkillGetTemplateMgr
  {
    private static Dictionary<int, MountSkillGetTemplateInfo> m_mountSkillGetTemplates = new Dictionary<int, MountSkillGetTemplateInfo>();

    public static bool Init() => MountSkillGetTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MountSkillGetTemplateInfo> dictionary = MountSkillGetTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MountSkillGetTemplateInfo>>(ref MountSkillGetTemplateMgr.m_mountSkillGetTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MountSkillGetTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MountSkillGetTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, MountSkillGetTemplateInfo> dictionary = new Dictionary<int, MountSkillGetTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MountSkillGetTemplateInfo skillGetTemplateInfo in produceBussiness.GetAllMountSkillGetTemplate())
        {
          if (!dictionary.ContainsKey(skillGetTemplateInfo.ID))
            dictionary.Add(skillGetTemplateInfo.ID, skillGetTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<MountSkillGetTemplateInfo> GetAllMountSkillGetTemplate()
    {
      if (MountSkillGetTemplateMgr.m_mountSkillGetTemplates.Count == 0)
        MountSkillGetTemplateMgr.Init();
      return MountSkillGetTemplateMgr.m_mountSkillGetTemplates.Values.ToList<MountSkillGetTemplateInfo>();
    }

    public static MountSkillGetTemplateInfo FindMountSkillGetTemplate(
      int id)
    {
      if (MountSkillGetTemplateMgr.m_mountSkillGetTemplates.Count == 0)
        MountSkillGetTemplateMgr.Init();
      return MountSkillGetTemplateMgr.m_mountSkillGetTemplates.ContainsKey(id) ? MountSkillGetTemplateMgr.m_mountSkillGetTemplates[id] : (MountSkillGetTemplateInfo) null;
    }
  }
}
