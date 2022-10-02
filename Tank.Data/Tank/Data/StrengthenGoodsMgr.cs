// Decompiled with JetBrains decompiler
// Type: Tank.Data.StrengthenGoodsMgr
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
  public class StrengthenGoodsMgr
  {
    private static Dictionary<int, StrengthenGoodsInfo> m_strengthenGoodss = new Dictionary<int, StrengthenGoodsInfo>();

    public static bool Init() => StrengthenGoodsMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, StrengthenGoodsInfo> dictionary = StrengthenGoodsMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, StrengthenGoodsInfo>>(ref StrengthenGoodsMgr.m_strengthenGoodss, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("StrengthenGoodsMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, StrengthenGoodsInfo> LoadFromDatabase()
    {
      Dictionary<int, StrengthenGoodsInfo> dictionary = new Dictionary<int, StrengthenGoodsInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (StrengthenGoodsInfo allStrengthenGood in produceBussiness.GetAllStrengthenGoods())
        {
          if (!dictionary.ContainsKey(allStrengthenGood.ID))
            dictionary.Add(allStrengthenGood.ID, allStrengthenGood);
        }
      }
      return dictionary;
    }

    public static List<StrengthenGoodsInfo> GetAllStrengthenGoods()
    {
      if (StrengthenGoodsMgr.m_strengthenGoodss.Count == 0)
        StrengthenGoodsMgr.Init();
      return StrengthenGoodsMgr.m_strengthenGoodss.Values.ToList<StrengthenGoodsInfo>();
    }

    public static StrengthenGoodsInfo FindStrengthenGoods(int id)
    {
      if (StrengthenGoodsMgr.m_strengthenGoodss.Count == 0)
        StrengthenGoodsMgr.Init();
      return StrengthenGoodsMgr.m_strengthenGoodss.ContainsKey(id) ? StrengthenGoodsMgr.m_strengthenGoodss[id] : (StrengthenGoodsInfo) null;
    }
  }
}
