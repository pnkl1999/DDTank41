// Decompiled with JetBrains decompiler
// Type: Tank.Data.PetTemplateMgr
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
  public class PetTemplateMgr
  {
    private static Dictionary<int, PetTemplateInfo> m_petTemplates = new Dictionary<int, PetTemplateInfo>();

    public static bool Init() => PetTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, PetTemplateInfo> dictionary = PetTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, PetTemplateInfo>>(ref PetTemplateMgr.m_petTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("PetTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, PetTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, PetTemplateInfo> dictionary = new Dictionary<int, PetTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (PetTemplateInfo petTemplateInfo in produceBussiness.GetAllPetTemplate())
        {
          if (!dictionary.ContainsKey(petTemplateInfo.TemplateID))
            dictionary.Add(petTemplateInfo.TemplateID, petTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<PetTemplateInfo> GetAllPetTemplate()
    {
      if (PetTemplateMgr.m_petTemplates.Count == 0)
        PetTemplateMgr.Init();
      return PetTemplateMgr.m_petTemplates.Values.ToList<PetTemplateInfo>();
    }

    public static PetTemplateInfo FindPetTemplate(int id)
    {
      if (PetTemplateMgr.m_petTemplates.Count == 0)
        PetTemplateMgr.Init();
      return PetTemplateMgr.m_petTemplates.ContainsKey(id) ? PetTemplateMgr.m_petTemplates[id] : (PetTemplateInfo) null;
    }
  }
}
