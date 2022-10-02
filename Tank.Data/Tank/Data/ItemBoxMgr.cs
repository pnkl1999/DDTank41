// Decompiled with JetBrains decompiler
// Type: Tank.Data.ItemBoxMgr
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
  public class ItemBoxMgr
  {
    private static Dictionary<int, List<ItemBoxInfo>> m_itemBoxs = new Dictionary<int, List<ItemBoxInfo>>();

    public static bool ReLoad()
    {
      try
      {
        ItemBoxInfo[] itemBoxs = ItemBoxMgr.LoadItemBoxDb();
        Dictionary<int, List<ItemBoxInfo>> dictionary = ItemBoxMgr.LoadItemBoxs(itemBoxs);
        if ((uint) itemBoxs.Length > 0U)
          Interlocked.Exchange<Dictionary<int, List<ItemBoxInfo>>>(ref ItemBoxMgr.m_itemBoxs, dictionary);
      }
      catch (Exception ex)
      {
        Logger.Error("ItemBoxMgr init error:" + ex.ToString());
        return false;
      }
      return true;
    }

    public static bool Init() => ItemBoxMgr.ReLoad();

    public static ItemBoxInfo[] LoadItemBoxDb()
    {
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        return produceBussiness.GetAllItemBox();
    }

    public static Dictionary<int, List<ItemBoxInfo>> LoadItemBoxs(
      ItemBoxInfo[] itemBoxs)
    {
      Dictionary<int, List<ItemBoxInfo>> dictionary = new Dictionary<int, List<ItemBoxInfo>>();
      foreach (ItemBoxInfo itemBoxInfo in itemBoxs)
      {
        ItemBoxInfo info = itemBoxInfo;
        if (!dictionary.Keys.Contains<int>(info.ID))
        {
          IEnumerable<ItemBoxInfo> source = ((IEnumerable<ItemBoxInfo>) itemBoxs).Where<ItemBoxInfo>((Func<ItemBoxInfo, bool>) (s => s.ID == info.ID));
          dictionary.Add(info.ID, source.ToList<ItemBoxInfo>());
        }
      }
      return dictionary;
    }

    public static List<ItemBoxInfo> GetAllItemBox()
    {
      if (ItemBoxMgr.m_itemBoxs.Count == 0)
        ItemBoxMgr.Init();
      List<ItemBoxInfo> itemBoxInfoList = new List<ItemBoxInfo>();
      foreach (int key in ItemBoxMgr.m_itemBoxs.Keys)
        itemBoxInfoList.AddRange((IEnumerable<ItemBoxInfo>) ItemBoxMgr.m_itemBoxs[key]);
      return itemBoxInfoList;
    }

    public static Dictionary<int, List<ItemBoxInfo>> GetAllBox()
    {
      Dictionary<int, List<ItemBoxInfo>> dictionary = new Dictionary<int, List<ItemBoxInfo>>();
      List<ItemBoxInfo> allItemBox = ItemBoxMgr.GetAllItemBox();
      foreach (ItemBoxInfo itemBoxInfo in allItemBox)
      {
        ItemBoxInfo box = itemBoxInfo;
        if (!dictionary.ContainsKey(box.ID))
        {
          IEnumerable<ItemBoxInfo> source = allItemBox.Where<ItemBoxInfo>((Func<ItemBoxInfo, bool>) (s => s.ID == box.ID));
          dictionary.Add(box.ID, source.ToList<ItemBoxInfo>());
        }
      }
      return dictionary;
    }

    public static List<ItemBoxInfo> FindItemBoxs(int id)
    {
      if (ItemBoxMgr.m_itemBoxs.Count == 0)
        ItemBoxMgr.Init();
      return ItemBoxMgr.m_itemBoxs.ContainsKey(id) ? ItemBoxMgr.m_itemBoxs[id] : (List<ItemBoxInfo>) null;
    }

    public static ItemBoxInfo GetItemBox(int id, int templateId)
    {
      foreach (ItemBoxInfo itemBoxInfo in ItemBoxMgr.FindItemBoxs(id))
      {
        if (itemBoxInfo.TemplateId == templateId)
          return itemBoxInfo;
      }
      return (ItemBoxInfo) null;
    }
  }
}
