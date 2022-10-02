// Decompiled with JetBrains decompiler
// Type: Tank.Data.GoodsCollectMgr
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
  public class GoodsCollectMgr
  {
    private static Dictionary<int, GoodsCollectInfo> m_goodsCollects = new Dictionary<int, GoodsCollectInfo>();

    public static bool Init() => GoodsCollectMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, GoodsCollectInfo> dictionary = GoodsCollectMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, GoodsCollectInfo>>(ref GoodsCollectMgr.m_goodsCollects, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("GoodsCollectMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, GoodsCollectInfo> LoadFromDatabase()
    {
      Dictionary<int, GoodsCollectInfo> dictionary = new Dictionary<int, GoodsCollectInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (GoodsCollectInfo goodsCollectInfo in produceBussiness.GetAllGoodsCollect())
        {
          if (!dictionary.ContainsKey(goodsCollectInfo.ID))
            dictionary.Add(goodsCollectInfo.ID, goodsCollectInfo);
        }
      }
      return dictionary;
    }

    public static List<GoodsCollectInfo> GetAllGoodsCollect()
    {
      if (GoodsCollectMgr.m_goodsCollects.Count == 0)
        GoodsCollectMgr.Init();
      return GoodsCollectMgr.m_goodsCollects.Values.ToList<GoodsCollectInfo>();
    }

    public static GoodsCollectInfo FindGoodsCollect(int id)
    {
      if (GoodsCollectMgr.m_goodsCollects.Count == 0)
        GoodsCollectMgr.Init();
      return GoodsCollectMgr.m_goodsCollects.ContainsKey(id) ? GoodsCollectMgr.m_goodsCollects[id] : (GoodsCollectInfo) null;
    }
  }
}
