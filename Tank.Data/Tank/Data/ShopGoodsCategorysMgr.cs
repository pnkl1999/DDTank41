// Decompiled with JetBrains decompiler
// Type: Tank.Data.ShopGoodsCategorysMgr
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
  public class ShopGoodsCategorysMgr
  {
    private static Dictionary<int, ShopGoodsCategorysInfo> m_shopGoodsCategoryss = new Dictionary<int, ShopGoodsCategorysInfo>();

    public static bool Init() => ShopGoodsCategorysMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ShopGoodsCategorysInfo> dictionary = ShopGoodsCategorysMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ShopGoodsCategorysInfo>>(ref ShopGoodsCategorysMgr.m_shopGoodsCategoryss, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("ShopGoodsCategorysMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ShopGoodsCategorysInfo> LoadFromDatabase()
    {
      Dictionary<int, ShopGoodsCategorysInfo> dictionary = new Dictionary<int, ShopGoodsCategorysInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ShopGoodsCategorysInfo shopGoodsCategory in produceBussiness.GetAllShopGoodsCategorys())
        {
          if (!dictionary.ContainsKey(shopGoodsCategory.ID))
            dictionary.Add(shopGoodsCategory.ID, shopGoodsCategory);
        }
      }
      return dictionary;
    }

    public static List<ShopGoodsCategorysInfo> GetAllShopGoodsCategorys()
    {
      if (ShopGoodsCategorysMgr.m_shopGoodsCategoryss.Count == 0)
        ShopGoodsCategorysMgr.Init();
      return ShopGoodsCategorysMgr.m_shopGoodsCategoryss.Values.ToList<ShopGoodsCategorysInfo>();
    }

    public static ShopGoodsCategorysInfo FindShopGoodsCategorys(int id)
    {
      if (ShopGoodsCategorysMgr.m_shopGoodsCategoryss.Count == 0)
        ShopGoodsCategorysMgr.Init();
      return ShopGoodsCategorysMgr.m_shopGoodsCategoryss.ContainsKey(id) ? ShopGoodsCategorysMgr.m_shopGoodsCategoryss[id] : (ShopGoodsCategorysInfo) null;
    }
  }
}
