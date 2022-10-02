// Decompiled with JetBrains decompiler
// Type: Tank.Data.ClothPropertyTemplateMgr
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
  public class ClothPropertyTemplateMgr
  {
    private static Dictionary<int, ClothPropertyTemplateInfo> m_clothPropertyTemplates = new Dictionary<int, ClothPropertyTemplateInfo>();

    public static bool Init() => ClothPropertyTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ClothPropertyTemplateInfo> dictionary = ClothPropertyTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ClothPropertyTemplateInfo>>(ref ClothPropertyTemplateMgr.m_clothPropertyTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("ClothPropertyTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ClothPropertyTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, ClothPropertyTemplateInfo> dictionary = new Dictionary<int, ClothPropertyTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ClothPropertyTemplateInfo propertyTemplateInfo in produceBussiness.GetAllClothPropertyTemplate())
        {
          if (!dictionary.ContainsKey(propertyTemplateInfo.ID))
            dictionary.Add(propertyTemplateInfo.ID, propertyTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<ClothPropertyTemplateInfo> GetAllClothPropertyTemplate()
    {
      if (ClothPropertyTemplateMgr.m_clothPropertyTemplates.Count == 0)
        ClothPropertyTemplateMgr.Init();
      return ClothPropertyTemplateMgr.m_clothPropertyTemplates.Values.ToList<ClothPropertyTemplateInfo>();
    }

    public static ClothPropertyTemplateInfo FindClothPropertyTemplate(
      int id)
    {
      if (ClothPropertyTemplateMgr.m_clothPropertyTemplates.Count == 0)
        ClothPropertyTemplateMgr.Init();
      return ClothPropertyTemplateMgr.m_clothPropertyTemplates.ContainsKey(id) ? ClothPropertyTemplateMgr.m_clothPropertyTemplates[id] : (ClothPropertyTemplateInfo) null;
    }
  }
}
