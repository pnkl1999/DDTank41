// Decompiled with JetBrains decompiler
// Type: Tank.Data.FairBattleRewardMgr
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
  public class FairBattleRewardMgr
  {
    private static Dictionary<int, FairBattleRewardInfo> m_fairBattleRewards = new Dictionary<int, FairBattleRewardInfo>();

    public static bool Init() => FairBattleRewardMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, FairBattleRewardInfo> dictionary = FairBattleRewardMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, FairBattleRewardInfo>>(ref FairBattleRewardMgr.m_fairBattleRewards, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("FairBattleRewardMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, FairBattleRewardInfo> LoadFromDatabase()
    {
      Dictionary<int, FairBattleRewardInfo> dictionary = new Dictionary<int, FairBattleRewardInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (FairBattleRewardInfo battleRewardInfo in produceBussiness.GetAllFairBattleReward())
        {
          if (!dictionary.ContainsKey(battleRewardInfo.Level))
            dictionary.Add(battleRewardInfo.Level, battleRewardInfo);
        }
      }
      return dictionary;
    }

    public static List<FairBattleRewardInfo> GetAllFairBattleReward()
    {
      if (FairBattleRewardMgr.m_fairBattleRewards.Count == 0)
        FairBattleRewardMgr.Init();
      return FairBattleRewardMgr.m_fairBattleRewards.Values.ToList<FairBattleRewardInfo>();
    }

    public static FairBattleRewardInfo FindFairBattleReward(int id)
    {
      if (FairBattleRewardMgr.m_fairBattleRewards.Count == 0)
        FairBattleRewardMgr.Init();
      return FairBattleRewardMgr.m_fairBattleRewards.ContainsKey(id) ? FairBattleRewardMgr.m_fairBattleRewards[id] : (FairBattleRewardInfo) null;
    }
  }
}
