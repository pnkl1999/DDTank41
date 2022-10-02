// Decompiled with JetBrains decompiler
// Type: Tank.Data.PetMoePropertyMgr
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
  public class PetMoePropertyMgr
  {
    private static Dictionary<int, PetMoePropertyInfo> m_petMoePropertys = new Dictionary<int, PetMoePropertyInfo>();

    public static bool Init() => PetMoePropertyMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, PetMoePropertyInfo> dictionary = PetMoePropertyMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, PetMoePropertyInfo>>(ref PetMoePropertyMgr.m_petMoePropertys, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("PetMoePropertyMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, PetMoePropertyInfo> LoadFromDatabase()
    {
      Dictionary<int, PetMoePropertyInfo> dictionary = new Dictionary<int, PetMoePropertyInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (PetMoePropertyInfo petMoePropertyInfo in produceBussiness.GetAllPetMoeProperty())
        {
          if (!dictionary.ContainsKey(petMoePropertyInfo.Level))
            dictionary.Add(petMoePropertyInfo.Level, petMoePropertyInfo);
        }
      }
      return dictionary;
    }

    public static List<PetMoePropertyInfo> GetAllPetMoeProperty()
    {
      if (PetMoePropertyMgr.m_petMoePropertys.Count == 0)
        PetMoePropertyMgr.Init();
      return PetMoePropertyMgr.m_petMoePropertys.Values.ToList<PetMoePropertyInfo>();
    }

    public static PetMoePropertyInfo FindPetMoeProperty(int id)
    {
      if (PetMoePropertyMgr.m_petMoePropertys.Count == 0)
        PetMoePropertyMgr.Init();
      return PetMoePropertyMgr.m_petMoePropertys.ContainsKey(id) ? PetMoePropertyMgr.m_petMoePropertys[id] : (PetMoePropertyInfo) null;
    }
  }
}
