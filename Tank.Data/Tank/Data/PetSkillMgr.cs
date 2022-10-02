// Decompiled with JetBrains decompiler
// Type: Tank.Data.PetSkillMgr
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
  public class PetSkillMgr
  {
    private static Dictionary<int, PetSkillInfo> m_petSkills = new Dictionary<int, PetSkillInfo>();

    public static bool Init() => PetSkillMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, PetSkillInfo> dictionary = PetSkillMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, PetSkillInfo>>(ref PetSkillMgr.m_petSkills, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("PetSkillMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, PetSkillInfo> LoadFromDatabase()
    {
      Dictionary<int, PetSkillInfo> dictionary = new Dictionary<int, PetSkillInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (PetSkillInfo petSkillInfo in produceBussiness.GetAllPetSkill())
        {
          if (!dictionary.ContainsKey(petSkillInfo.ID))
            dictionary.Add(petSkillInfo.ID, petSkillInfo);
        }
      }
      return dictionary;
    }

    public static List<PetSkillInfo> GetAllPetSkill()
    {
      if (PetSkillMgr.m_petSkills.Count == 0)
        PetSkillMgr.Init();
      return PetSkillMgr.m_petSkills.Values.ToList<PetSkillInfo>();
    }

    public static PetSkillInfo FindPetSkill(int id)
    {
      if (PetSkillMgr.m_petSkills.Count == 0)
        PetSkillMgr.Init();
      return PetSkillMgr.m_petSkills.ContainsKey(id) ? PetSkillMgr.m_petSkills[id] : (PetSkillInfo) null;
    }
  }
}
