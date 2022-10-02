// Decompiled with JetBrains decompiler
// Type: Tank.Data.ShopGoodsShowListMgr
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
    public class ShopGoodsShowListMgr
    {
        private static Dictionary<int, List<ShopGoodsShowListInfo>> m_shopGoodsShowLists = new Dictionary<int, List<ShopGoodsShowListInfo>>();
        private static List<ShopGoodsShowListInfo> m_allShopGoodsShowLists = new List<ShopGoodsShowListInfo>();

        public static bool ReLoad()
        {
            try
            {
                ShopGoodsShowListInfo[] shopGoodsShowLists = ShopGoodsShowListMgr.LoadShopGoodsShowListDb();
                Dictionary<int, List<ShopGoodsShowListInfo>> dictionary = ShopGoodsShowListMgr.LoadShopGoodsShowLists(shopGoodsShowLists);
                if (shopGoodsShowLists.Length > 0)
                {
                    Interlocked.Exchange<Dictionary<int, List<ShopGoodsShowListInfo>>>(ref ShopGoodsShowListMgr.m_shopGoodsShowLists, dictionary);
                    m_allShopGoodsShowLists = shopGoodsShowLists.ToList();
                }

            }
            catch (Exception ex)
            {
                Logger.Error("ShopGoodsShowListMgr init error:" + ex.ToString());
                return false;
            }
            return true;
        }

        public static bool Init() => ShopGoodsShowListMgr.ReLoad();

        public static ShopGoodsShowListInfo[] LoadShopGoodsShowListDb()
        {
            using (ProduceBussiness produceBussiness = new ProduceBussiness())
                return produceBussiness.GetAllShopGoodsShowList();
        }

        public static Dictionary<int, List<ShopGoodsShowListInfo>> LoadShopGoodsShowLists(
          ShopGoodsShowListInfo[] shopGoodsShowLists)
        {
            Dictionary<int, List<ShopGoodsShowListInfo>> dictionary = new Dictionary<int, List<ShopGoodsShowListInfo>>();
            foreach (ShopGoodsShowListInfo shopGoodsShowList in shopGoodsShowLists)
            {
                ShopGoodsShowListInfo info = shopGoodsShowList;
                if (!dictionary.Keys.Contains<int>(info.Type))
                {
                    IEnumerable<ShopGoodsShowListInfo> source = ((IEnumerable<ShopGoodsShowListInfo>)shopGoodsShowLists).Where<ShopGoodsShowListInfo>((Func<ShopGoodsShowListInfo, bool>)(s => s.Type == info.Type));
                    dictionary.Add(info.Type, source.ToList<ShopGoodsShowListInfo>());
                }
            }
            return dictionary;
        }

        public static List<int> GetAllType()
        {
            if (ShopGoodsShowListMgr.m_shopGoodsShowLists.Count == 0)
                ShopGoodsShowListMgr.Init();
            return ShopGoodsShowListMgr.m_shopGoodsShowLists.Keys.ToList<int>();
        }

        public static List<ShopGoodsShowListInfo> FindShopGoodsShowLists(
          int type)
        {
            if (ShopGoodsShowListMgr.m_shopGoodsShowLists.Count == 0)
                ShopGoodsShowListMgr.Init();
            if (type == -1)
                return m_allShopGoodsShowLists;

            return ShopGoodsShowListMgr.m_shopGoodsShowLists.ContainsKey(type) ? ShopGoodsShowListMgr.m_shopGoodsShowLists[type] : (List<ShopGoodsShowListInfo>)null;
        }

        public static ShopGoodsShowListInfo GetShopGoodsShow(int type, int shopId)
        {
            List<ShopGoodsShowListInfo> shopGoodsShowLists = ShopGoodsShowListMgr.FindShopGoodsShowLists(type);
            List<ShopItemInfo> shopItemInfoList = new List<ShopItemInfo>();
            foreach (ShopGoodsShowListInfo goodsShowListInfo in shopGoodsShowLists)
            {
                if (goodsShowListInfo.ShopId == shopId)
                    return goodsShowListInfo;
            }
            return (ShopGoodsShowListInfo)null;
        }

        public static List<ShopItemInfo> GetShopItems(int type)
        {
            List<ShopGoodsShowListInfo> shopGoodsShowLists = ShopGoodsShowListMgr.FindShopGoodsShowLists(type);
            List<ShopItemInfo> shopItemInfoList = new List<ShopItemInfo>();
            foreach (ShopGoodsShowListInfo goodsShowListInfo in shopGoodsShowLists)
            {
                ShopItemInfo shopItem = ShopItemMgr.FindShopItem(goodsShowListInfo.ShopId);
                if (shopItem != null)
                    shopItemInfoList.Add(shopItem);
            }
            return shopItemInfoList;
        }
    }
}
