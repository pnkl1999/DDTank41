// Decompiled with JetBrains decompiler
// Type: Tank.Data.CardAchievementMgr
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
  public class CardAchievementMgr
  {
    private static Dictionary<int, CardAchievementInfo> m_cardAchievements = new Dictionary<int, CardAchievementInfo>();

    public static bool Init() => CardAchievementMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, CardAchievementInfo> dictionary = CardAchievementMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, CardAchievementInfo>>(ref CardAchievementMgr.m_cardAchievements, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("CardAchievementMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, CardAchievementInfo> LoadFromDatabase()
    {
      Dictionary<int, CardAchievementInfo> dictionary = new Dictionary<int, CardAchievementInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (CardAchievementInfo cardAchievementInfo in produceBussiness.GetAllCardAchievement())
        {
          if (!dictionary.ContainsKey(cardAchievementInfo.AchievementID))
            dictionary.Add(cardAchievementInfo.AchievementID, cardAchievementInfo);
        }
      }
      return dictionary;
    }

    public static List<CardAchievementInfo> GetAllCardAchievement()
    {
      if (CardAchievementMgr.m_cardAchievements.Count == 0)
        CardAchievementMgr.Init();
      return CardAchievementMgr.m_cardAchievements.Values.ToList<CardAchievementInfo>();
    }

    public static CardAchievementInfo FindCardAchievement(int id)
    {
      if (CardAchievementMgr.m_cardAchievements.Count == 0)
        CardAchievementMgr.Init();
      return CardAchievementMgr.m_cardAchievements.ContainsKey(id) ? CardAchievementMgr.m_cardAchievements[id] : (CardAchievementInfo) null;
    }
  }
}
