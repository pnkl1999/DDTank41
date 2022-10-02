// Decompiled with JetBrains decompiler
// Type: Tank.Data.PetFormDataMgr
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
  public class PetFormDataMgr
  {
    private static Dictionary<int, PetFormDataInfo> m_petFormDatas = new Dictionary<int, PetFormDataInfo>();

    public static bool Init() => PetFormDataMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, PetFormDataInfo> dictionary = PetFormDataMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, PetFormDataInfo>>(ref PetFormDataMgr.m_petFormDatas, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("PetFormDataMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, PetFormDataInfo> LoadFromDatabase()
    {
      Dictionary<int, PetFormDataInfo> dictionary = new Dictionary<int, PetFormDataInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (PetFormDataInfo petFormDataInfo in produceBussiness.GetAllPetFormData())
        {
          if (!dictionary.ContainsKey(petFormDataInfo.TemplateID))
            dictionary.Add(petFormDataInfo.TemplateID, petFormDataInfo);
        }
      }
      return dictionary;
    }

    public static List<PetFormDataInfo> GetAllPetFormData()
    {
      if (PetFormDataMgr.m_petFormDatas.Count == 0)
        PetFormDataMgr.Init();
      return PetFormDataMgr.m_petFormDatas.Values.ToList<PetFormDataInfo>();
    }

    public static PetFormDataInfo FindPetFormData(int id)
    {
      if (PetFormDataMgr.m_petFormDatas.Count == 0)
        PetFormDataMgr.Init();
      return PetFormDataMgr.m_petFormDatas.ContainsKey(id) ? PetFormDataMgr.m_petFormDatas[id] : (PetFormDataInfo) null;
    }
  }
}
