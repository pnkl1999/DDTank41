// Decompiled with JetBrains decompiler
// Type: Tank.Data.ClothGroupTemplateMgr
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
  public class ClothGroupTemplateMgr
  {
    private static Dictionary<int, ClothGroupTemplateInfo> m_clothGroupTemplates = new Dictionary<int, ClothGroupTemplateInfo>();

    public static bool Init() => ClothGroupTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ClothGroupTemplateInfo> dictionary = ClothGroupTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ClothGroupTemplateInfo>>(ref ClothGroupTemplateMgr.m_clothGroupTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("ClothGroupTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ClothGroupTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, ClothGroupTemplateInfo> dictionary = new Dictionary<int, ClothGroupTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ClothGroupTemplateInfo groupTemplateInfo in produceBussiness.GetAllClothGroupTemplate())
        {
          if (!dictionary.ContainsKey(groupTemplateInfo.ID))
            dictionary.Add(groupTemplateInfo.ID, groupTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<ClothGroupTemplateInfo> GetAllClothGroupTemplate()
    {
      if (ClothGroupTemplateMgr.m_clothGroupTemplates.Count == 0)
        ClothGroupTemplateMgr.Init();
      return ClothGroupTemplateMgr.m_clothGroupTemplates.Values.ToList<ClothGroupTemplateInfo>();
    }

    public static ClothGroupTemplateInfo FindClothGroupTemplate(int id)
    {
      if (ClothGroupTemplateMgr.m_clothGroupTemplates.Count == 0)
        ClothGroupTemplateMgr.Init();
      return ClothGroupTemplateMgr.m_clothGroupTemplates.ContainsKey(id) ? ClothGroupTemplateMgr.m_clothGroupTemplates[id] : (ClothGroupTemplateInfo) null;
    }
  }
}
