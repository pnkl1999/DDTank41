// Decompiled with JetBrains decompiler
// Type: Tank.Data.PetFightPropertyMgr
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
  public class PetFightPropertyMgr
  {
    private static Dictionary<int, PetFightPropertyInfo> m_petFightPropertys = new Dictionary<int, PetFightPropertyInfo>();

    public static bool Init() => PetFightPropertyMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, PetFightPropertyInfo> dictionary = PetFightPropertyMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, PetFightPropertyInfo>>(ref PetFightPropertyMgr.m_petFightPropertys, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("PetFightPropertyMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, PetFightPropertyInfo> LoadFromDatabase()
    {
      Dictionary<int, PetFightPropertyInfo> dictionary = new Dictionary<int, PetFightPropertyInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (PetFightPropertyInfo fightPropertyInfo in produceBussiness.GetAllPetFightProperty())
        {
          if (!dictionary.ContainsKey(fightPropertyInfo.ID))
            dictionary.Add(fightPropertyInfo.ID, fightPropertyInfo);
        }
      }
      return dictionary;
    }

    public static List<PetFightPropertyInfo> GetAllPetFightProperty()
    {
      if (PetFightPropertyMgr.m_petFightPropertys.Count == 0)
        PetFightPropertyMgr.Init();
      return PetFightPropertyMgr.m_petFightPropertys.Values.ToList<PetFightPropertyInfo>();
    }

    public static PetFightPropertyInfo FindPetFightProperty(int id)
    {
      if (PetFightPropertyMgr.m_petFightPropertys.Count == 0)
        PetFightPropertyMgr.Init();
      return PetFightPropertyMgr.m_petFightPropertys.ContainsKey(id) ? PetFightPropertyMgr.m_petFightPropertys[id] : (PetFightPropertyInfo) null;
    }
  }
}
