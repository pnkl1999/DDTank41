// Decompiled with JetBrains decompiler
// Type: Tank.Data.BattleBonusMgr
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
  public class BattleBonusMgr
  {
    private static Dictionary<int, BattleBonusInfo> m_battleBonuss = new Dictionary<int, BattleBonusInfo>();

    public static bool Init() => BattleBonusMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, BattleBonusInfo> dictionary = BattleBonusMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, BattleBonusInfo>>(ref BattleBonusMgr.m_battleBonuss, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("BattleBonusMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, BattleBonusInfo> LoadFromDatabase()
    {
      Dictionary<int, BattleBonusInfo> dictionary = new Dictionary<int, BattleBonusInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (BattleBonusInfo allBattleBonu in produceBussiness.GetAllBattleBonus())
        {
          if (!dictionary.ContainsKey(allBattleBonu.ID))
            dictionary.Add(allBattleBonu.ID, allBattleBonu);
        }
      }
      return dictionary;
    }

    public static List<BattleBonusInfo> GetAllBattleBonus()
    {
      if (BattleBonusMgr.m_battleBonuss.Count == 0)
        BattleBonusMgr.Init();
      return BattleBonusMgr.m_battleBonuss.Values.ToList<BattleBonusInfo>();
    }

    public static BattleBonusInfo FindBattleBonus(int id)
    {
      if (BattleBonusMgr.m_battleBonuss.Count == 0)
        BattleBonusMgr.Init();
      return BattleBonusMgr.m_battleBonuss.ContainsKey(id) ? BattleBonusMgr.m_battleBonuss[id] : (BattleBonusInfo) null;
    }
  }
}
