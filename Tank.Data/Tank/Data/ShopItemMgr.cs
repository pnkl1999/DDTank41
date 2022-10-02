// Decompiled with JetBrains decompiler
// Type: Tank.Data.ShopItemMgr
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
  public class ShopItemMgr
  {
    private static Dictionary<int, ShopItemInfo> m_shopItems = new Dictionary<int, ShopItemInfo>();

    public static bool Init() => ShopItemMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ShopItemInfo> dictionary = ShopItemMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ShopItemInfo>>(ref ShopItemMgr.m_shopItems, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("ShopItemMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ShopItemInfo> LoadFromDatabase()
    {
      Dictionary<int, ShopItemInfo> dictionary = new Dictionary<int, ShopItemInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ShopItemInfo shopItemInfo in produceBussiness.GetAllShopItem())
        {
          if (!dictionary.ContainsKey(shopItemInfo.ID))
            dictionary.Add(shopItemInfo.ID, shopItemInfo);
        }
      }
      return dictionary;
    }

    public static List<ShopItemInfo> GetAllShopItem()
    {
      if (ShopItemMgr.m_shopItems.Count == 0)
        ShopItemMgr.Init();
      return ShopItemMgr.m_shopItems.Values.ToList<ShopItemInfo>().Where<ShopItemInfo>((Func<ShopItemInfo, bool>) (p => !p.IsCheap)).ToList<ShopItemInfo>();
    }

    public static List<ShopItemInfo> GetAllShopCheapItem()
    {
      if (ShopItemMgr.m_shopItems.Count == 0)
        ShopItemMgr.Init();
      return ShopItemMgr.m_shopItems.Values.ToList<ShopItemInfo>().Where<ShopItemInfo>((Func<ShopItemInfo, bool>) (p => p.IsCheap && p.Label == 4)).ToList<ShopItemInfo>();
    }

    public static ShopItemInfo FindShopItem(int id)
    {
      if (ShopItemMgr.m_shopItems.Count == 0)
        ShopItemMgr.Init();
      return ShopItemMgr.m_shopItems.ContainsKey(id) ? ShopItemMgr.m_shopItems[id] : (ShopItemInfo) null;
    }
  }
}
