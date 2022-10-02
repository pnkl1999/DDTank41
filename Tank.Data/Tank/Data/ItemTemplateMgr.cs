// Decompiled with JetBrains decompiler
// Type: Tank.Data.ItemTemplateMgr
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
  public class ItemTemplateMgr
  {
    private static Dictionary<int, ItemTemplateInfo> m_itemTemplates = new Dictionary<int, ItemTemplateInfo>();

    public static bool Init() => ItemTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ItemTemplateInfo> dictionary = ItemTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ItemTemplateInfo>>(ref ItemTemplateMgr.m_itemTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("ItemTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ItemTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, ItemTemplateInfo> dictionary = new Dictionary<int, ItemTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ItemTemplateInfo itemTemplateInfo in produceBussiness.GetAllItemTemplate())
        {
          if (!dictionary.ContainsKey(itemTemplateInfo.TemplateID))
            dictionary.Add(itemTemplateInfo.TemplateID, itemTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<ItemTemplateInfo> GetAllItemTemplate()
    {
      if (ItemTemplateMgr.m_itemTemplates.Count == 0)
        ItemTemplateMgr.Init();
      return ItemTemplateMgr.m_itemTemplates.Values.ToList<ItemTemplateInfo>();
    }

    public static ItemTemplateInfo FindItemTemplate(int id)
    {
      if (ItemTemplateMgr.m_itemTemplates.Count == 0)
        ItemTemplateMgr.Init();
      return ItemTemplateMgr.m_itemTemplates.ContainsKey(id) ? ItemTemplateMgr.m_itemTemplates[id] : (ItemTemplateInfo) null;
    }
  }
}
