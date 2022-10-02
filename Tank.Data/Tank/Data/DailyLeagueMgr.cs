// Decompiled with JetBrains decompiler
// Type: Tank.Data.DailyLeagueMgr
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
  public class DailyLeagueMgr
  {
    private static Dictionary<int, DailyLeagueRewardGroupInfo> m_dailyLeagueRewardGroups = new Dictionary<int, DailyLeagueRewardGroupInfo>();
    private static Dictionary<int, List<DailyLeagueRewardItemInfo>> m_dailyLeagueGoods = new Dictionary<int, List<DailyLeagueRewardItemInfo>>();
    private static Dictionary<int, List<DailyLeagueRewardItemInfo>> m_dailyLeagueTop10Goods = new Dictionary<int, List<DailyLeagueRewardItemInfo>>();

    public static bool Init() => DailyLeagueMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, DailyLeagueRewardGroupInfo> groups = DailyLeagueMgr.LoadDailyLeagueRewardGroupDb();
        Dictionary<int, List<DailyLeagueRewardItemInfo>> dictionary1 = DailyLeagueMgr.LoadDailyLeagueRewardItemDb(groups);
        Dictionary<int, List<DailyLeagueRewardItemInfo>> dictionary2 = DailyLeagueMgr.LoadDailyLeagueTop10RewardItemDb(groups);
        if (groups.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, DailyLeagueRewardGroupInfo>>(ref DailyLeagueMgr.m_dailyLeagueRewardGroups, groups);
          Interlocked.Exchange<Dictionary<int, List<DailyLeagueRewardItemInfo>>>(ref DailyLeagueMgr.m_dailyLeagueGoods, dictionary1);
          Interlocked.Exchange<Dictionary<int, List<DailyLeagueRewardItemInfo>>>(ref DailyLeagueMgr.m_dailyLeagueTop10Goods, dictionary2);
        }
        return true;
      }
      catch (Exception ex)
      {
        Logger.Error("ReLoad DailyLeagueMgr " + (object) ex);
      }
      return false;
    }

    public static Dictionary<int, DailyLeagueRewardGroupInfo> LoadDailyLeagueRewardGroupDb()
    {
      Dictionary<int, DailyLeagueRewardGroupInfo> dictionary = new Dictionary<int, DailyLeagueRewardGroupInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (DailyLeagueRewardGroupInfo leagueRewardGroupInfo in produceBussiness.GetAllDailyLeagueRewardGroup())
        {
          if (!dictionary.ContainsKey(leagueRewardGroupInfo.Class))
            dictionary.Add(leagueRewardGroupInfo.Class, leagueRewardGroupInfo);
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<DailyLeagueRewardItemInfo>> LoadDailyLeagueRewardItemDb(
      Dictionary<int, DailyLeagueRewardGroupInfo> groups)
    {
      Dictionary<int, List<DailyLeagueRewardItemInfo>> dictionary = new Dictionary<int, List<DailyLeagueRewardItemInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        DailyLeagueRewardItemInfo[] leagueRewardItem = produceBussiness.GetAllDailyLeagueRewardItem();
        foreach (DailyLeagueRewardGroupInfo leagueRewardGroupInfo in groups.Values)
        {
          DailyLeagueRewardGroupInfo group = leagueRewardGroupInfo;
          IEnumerable<DailyLeagueRewardItemInfo> source = ((IEnumerable<DailyLeagueRewardItemInfo>) leagueRewardItem).Where<DailyLeagueRewardItemInfo>((Func<DailyLeagueRewardItemInfo, bool>) (s => s.GroupId == group.Class));
          dictionary.Add(group.Class, source.ToList<DailyLeagueRewardItemInfo>());
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<DailyLeagueRewardItemInfo>> LoadDailyLeagueTop10RewardItemDb(
      Dictionary<int, DailyLeagueRewardGroupInfo> groups)
    {
      Dictionary<int, List<DailyLeagueRewardItemInfo>> dictionary = new Dictionary<int, List<DailyLeagueRewardItemInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        DailyLeagueRewardItemInfo[] leagueRewardItem = produceBussiness.GetAllDailyLeagueRewardItem();
        foreach (DailyLeagueRewardGroupInfo leagueRewardGroupInfo in groups.Values)
        {
          DailyLeagueRewardGroupInfo group = leagueRewardGroupInfo;
          if (group.Grade == 100)
          {
            IEnumerable<DailyLeagueRewardItemInfo> source = ((IEnumerable<DailyLeagueRewardItemInfo>) leagueRewardItem).Where<DailyLeagueRewardItemInfo>((Func<DailyLeagueRewardItemInfo, bool>) (s => s.GroupId == group.Class));
            dictionary.Add(group.Rank, source.ToList<DailyLeagueRewardItemInfo>());
          }
        }
      }
      return dictionary;
    }

    public static DailyLeagueRewardGroupInfo FindDailyLeague(int id)
    {
      if (DailyLeagueMgr.m_dailyLeagueRewardGroups.Count == 0)
        DailyLeagueMgr.Init();
      return DailyLeagueMgr.m_dailyLeagueRewardGroups.ContainsKey(id) ? DailyLeagueMgr.m_dailyLeagueRewardGroups[id] : (DailyLeagueRewardGroupInfo) null;
    }

    public static List<DailyLeagueRewardItemInfo> GetDailyLeagueRewardItems(
      int id)
    {
      if (DailyLeagueMgr.m_dailyLeagueGoods.Count == 0)
        DailyLeagueMgr.Init();
      return DailyLeagueMgr.m_dailyLeagueGoods.ContainsKey(id) ? DailyLeagueMgr.m_dailyLeagueGoods[id] : (List<DailyLeagueRewardItemInfo>) null;
    }

    public static List<DailyLeagueRewardItemInfo> GetDailyLeagueTop10RewardItems(
      int rank)
    {
      if (DailyLeagueMgr.m_dailyLeagueTop10Goods.Count == 0)
        DailyLeagueMgr.Init();
      return DailyLeagueMgr.m_dailyLeagueTop10Goods.ContainsKey(rank) ? DailyLeagueMgr.m_dailyLeagueTop10Goods[rank] : (List<DailyLeagueRewardItemInfo>) null;
    }
  }
}
