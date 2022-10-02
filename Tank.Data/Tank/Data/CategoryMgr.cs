// Decompiled with JetBrains decompiler
// Type: Tank.Data.CategoryMgr
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
  public class CategoryMgr
  {
    private static Dictionary<int, CategoryInfo> m_categorys = new Dictionary<int, CategoryInfo>();

    public static bool Init() => CategoryMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, CategoryInfo> dictionary = CategoryMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, CategoryInfo>>(ref CategoryMgr.m_categorys, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("CategoryMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, CategoryInfo> LoadFromDatabase()
    {
      Dictionary<int, CategoryInfo> dictionary = new Dictionary<int, CategoryInfo>();
      using (WebBussiness webBussiness = new WebBussiness())
      {
        foreach (CategoryInfo categoryInfo in webBussiness.GetAllCategory())
        {
          if (!dictionary.ContainsKey(categoryInfo.ID))
            dictionary.Add(categoryInfo.ID, categoryInfo);
        }
      }
      return dictionary;
    }

    public static List<CategoryInfo> GetAllCategory()
    {
      if (CategoryMgr.m_categorys.Count == 0)
        CategoryMgr.Init();
      return CategoryMgr.m_categorys.Values.ToList<CategoryInfo>();
    }

    public static CategoryInfo FindCategory(int id)
    {
      if (CategoryMgr.m_categorys.Count == 0)
        CategoryMgr.Init();
      return CategoryMgr.m_categorys.ContainsKey(id) ? CategoryMgr.m_categorys[id] : (CategoryInfo) null;
    }
  }
}
