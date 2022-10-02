// Decompiled with JetBrains decompiler
// Type: Tank.Data.PetSkillTemplateMgr
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
  public class PetSkillTemplateMgr
  {
    private static Dictionary<int, PetSkillTemplateInfo> m_petSkillTemplates = new Dictionary<int, PetSkillTemplateInfo>();

    public static bool Init() => PetSkillTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, PetSkillTemplateInfo> dictionary = PetSkillTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, PetSkillTemplateInfo>>(ref PetSkillTemplateMgr.m_petSkillTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("PetSkillTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, PetSkillTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, PetSkillTemplateInfo> dictionary = new Dictionary<int, PetSkillTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (PetSkillTemplateInfo skillTemplateInfo in produceBussiness.GetAllPetSkillTemplate())
        {
          if (!dictionary.ContainsKey(skillTemplateInfo.SkillID))
            dictionary.Add(skillTemplateInfo.SkillID, skillTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<PetSkillTemplateInfo> GetAllPetSkillTemplate()
    {
      if (PetSkillTemplateMgr.m_petSkillTemplates.Count == 0)
        PetSkillTemplateMgr.Init();
      return PetSkillTemplateMgr.m_petSkillTemplates.Values.ToList<PetSkillTemplateInfo>();
    }

    public static PetSkillTemplateInfo FindPetSkillTemplate(int id)
    {
      if (PetSkillTemplateMgr.m_petSkillTemplates.Count == 0)
        PetSkillTemplateMgr.Init();
      return PetSkillTemplateMgr.m_petSkillTemplates.ContainsKey(id) ? PetSkillTemplateMgr.m_petSkillTemplates[id] : (PetSkillTemplateInfo) null;
    }
  }
}
