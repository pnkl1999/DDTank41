// Decompiled with JetBrains decompiler
// Type: Tank.Data.LightriddleQuestMgr
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
  public class LightriddleQuestMgr
  {
    private static Dictionary<int, LightriddleQuestInfo> m_lightriddleQuests = new Dictionary<int, LightriddleQuestInfo>();

    public static bool Init() => LightriddleQuestMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, LightriddleQuestInfo> dictionary = LightriddleQuestMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, LightriddleQuestInfo>>(ref LightriddleQuestMgr.m_lightriddleQuests, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("LightriddleQuestMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, LightriddleQuestInfo> LoadFromDatabase()
    {
      Dictionary<int, LightriddleQuestInfo> dictionary = new Dictionary<int, LightriddleQuestInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (LightriddleQuestInfo lightriddleQuestInfo in produceBussiness.GetAllLightriddleQuest())
        {
          if (!dictionary.ContainsKey(lightriddleQuestInfo.QuestionID))
            dictionary.Add(lightriddleQuestInfo.QuestionID, lightriddleQuestInfo);
        }
      }
      return dictionary;
    }

    public static List<LightriddleQuestInfo> GetAllLightriddleQuest()
    {
      if (LightriddleQuestMgr.m_lightriddleQuests.Count == 0)
        LightriddleQuestMgr.Init();
      return LightriddleQuestMgr.m_lightriddleQuests.Values.ToList<LightriddleQuestInfo>();
    }

    public static LightriddleQuestInfo FindLightriddleQuest(int id)
    {
      if (LightriddleQuestMgr.m_lightriddleQuests.Count == 0)
        LightriddleQuestMgr.Init();
      return LightriddleQuestMgr.m_lightriddleQuests.ContainsKey(id) ? LightriddleQuestMgr.m_lightriddleQuests[id] : (LightriddleQuestInfo) null;
    }
  }
}
