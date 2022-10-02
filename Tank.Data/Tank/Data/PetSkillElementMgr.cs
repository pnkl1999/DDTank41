// Decompiled with JetBrains decompiler
// Type: Tank.Data.PetSkillElementMgr
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
  public class PetSkillElementMgr
  {
    private static Dictionary<int, PetSkillElementInfo> m_petSkillElements = new Dictionary<int, PetSkillElementInfo>();

    public static bool Init() => PetSkillElementMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, PetSkillElementInfo> dictionary = PetSkillElementMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, PetSkillElementInfo>>(ref PetSkillElementMgr.m_petSkillElements, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("PetSkillElementMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, PetSkillElementInfo> LoadFromDatabase()
    {
      Dictionary<int, PetSkillElementInfo> dictionary = new Dictionary<int, PetSkillElementInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (PetSkillElementInfo skillElementInfo in produceBussiness.GetAllPetSkillElement())
        {
          if (!dictionary.ContainsKey(skillElementInfo.ID))
            dictionary.Add(skillElementInfo.ID, skillElementInfo);
        }
      }
      return dictionary;
    }

    public static List<PetSkillElementInfo> GetAllPetSkillElement()
    {
      if (PetSkillElementMgr.m_petSkillElements.Count == 0)
        PetSkillElementMgr.Init();
      return PetSkillElementMgr.m_petSkillElements.Values.ToList<PetSkillElementInfo>();
    }

    public static PetSkillElementInfo FindPetSkillElement(int id)
    {
      if (PetSkillElementMgr.m_petSkillElements.Count == 0)
        PetSkillElementMgr.Init();
      return PetSkillElementMgr.m_petSkillElements.ContainsKey(id) ? PetSkillElementMgr.m_petSkillElements[id] : (PetSkillElementInfo) null;
    }
  }
}
