// Decompiled with JetBrains decompiler
// Type: Tank.Data.QuestMgr
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
  public class QuestMgr
  {
    private static Dictionary<int, QuestInfo> m_quests = new Dictionary<int, QuestInfo>();
    private static Dictionary<int, QuestInfo> m_questIds = new Dictionary<int, QuestInfo>();
    private static Dictionary<int, List<QuestConditionInfo>> m_questCondictions = new Dictionary<int, List<QuestConditionInfo>>();
    private static Dictionary<int, QuestConditionInfo> m_questCondictionTypes = new Dictionary<int, QuestConditionInfo>();
    private static Dictionary<int, List<QuestAwardInfo>> m_questGoods = new Dictionary<int, List<QuestAwardInfo>>();
    private static QuestRateInfo m_rate = new QuestRateInfo();

    public static bool Init() => QuestMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, QuestInfo> quests = QuestMgr.LoadQuestDb();
        Dictionary<int, List<QuestConditionInfo>> dictionary1 = QuestMgr.LoadQuestCondictionDb(quests);
        Dictionary<int, List<QuestAwardInfo>> dictionary2 = QuestMgr.LoadQuestGoodDb(quests);
        Dictionary<int, QuestConditionInfo> dictionary3 = QuestMgr.LoadQuestCondictionDb();
        if (quests.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, QuestInfo>>(ref QuestMgr.m_quests, quests);
          Interlocked.Exchange<Dictionary<int, List<QuestConditionInfo>>>(ref QuestMgr.m_questCondictions, dictionary1);
          Interlocked.Exchange<Dictionary<int, List<QuestAwardInfo>>>(ref QuestMgr.m_questGoods, dictionary2);
          Interlocked.Exchange<Dictionary<int, QuestConditionInfo>>(ref QuestMgr.m_questCondictionTypes, dictionary3);
        }
        return true;
      }
      catch (Exception ex)
      {
        Logger.Error("QuestMgr init error:" + ex.ToString());
      }
      return false;
    }

    public static Dictionary<int, QuestInfo> LoadQuestDb()
    {
      Dictionary<int, QuestInfo> dictionary = new Dictionary<int, QuestInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (QuestInfo questInfo in produceBussiness.GetAllQuest())
        {
          if (!dictionary.ContainsKey(questInfo.ID))
            dictionary.Add(questInfo.ID, questInfo);
        }
        QuestMgr.m_rate = produceBussiness.GetAllQuestRate();
      }
      return dictionary;
    }

    public static Dictionary<int, List<QuestConditionInfo>> LoadQuestCondictionDb(
      Dictionary<int, QuestInfo> quests)
    {
      Dictionary<int, List<QuestConditionInfo>> dictionary = new Dictionary<int, List<QuestConditionInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        QuestConditionInfo[] allQuestCondiction = produceBussiness.GetAllQuestCondiction();
        foreach (QuestInfo questInfo in quests.Values)
        {
          QuestInfo quest = questInfo;
          IEnumerable<QuestConditionInfo> source = ((IEnumerable<QuestConditionInfo>) allQuestCondiction).Where<QuestConditionInfo>((Func<QuestConditionInfo, bool>) (s => s.QuestID == quest.ID));
          dictionary.Add(quest.ID, source.ToList<QuestConditionInfo>());
        }
      }
      return dictionary;
    }

    public static Dictionary<int, QuestConditionInfo> LoadQuestCondictionDb()
    {
      Dictionary<int, QuestConditionInfo> dictionary = new Dictionary<int, QuestConditionInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (QuestConditionInfo questConditionInfo in produceBussiness.GetAllQuestCondiction())
        {
          if (!dictionary.ContainsKey(questConditionInfo.CondictionType))
            dictionary.Add(questConditionInfo.CondictionType, questConditionInfo);
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<QuestAwardInfo>> LoadQuestGoodDb(
      Dictionary<int, QuestInfo> quests)
    {
      Dictionary<int, List<QuestAwardInfo>> dictionary = new Dictionary<int, List<QuestAwardInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        QuestAwardInfo[] allQuestAwardOld = produceBussiness.GetAllQuestAwardOld();
        foreach (QuestInfo questInfo in quests.Values)
        {
          QuestInfo quest = questInfo;
          IEnumerable<QuestAwardInfo> source = ((IEnumerable<QuestAwardInfo>) allQuestAwardOld).Where<QuestAwardInfo>((Func<QuestAwardInfo, bool>) (s => s.QuestID == quest.ID));
          dictionary.Add(quest.ID, source.ToList<QuestAwardInfo>());
        }
      }
      return dictionary;
    }

    public static List<QuestInfo> GetAllQuestIds()
    {
      if (QuestMgr.m_quests.Count == 0)
        QuestMgr.Init();
      foreach (QuestInfo questInfo in QuestMgr.m_quests.Values)
      {
        if (!QuestMgr.m_questIds.ContainsKey(questInfo.QuestID))
          QuestMgr.m_questIds.Add(questInfo.QuestID, questInfo);
      }
      return QuestMgr.m_questIds.Values.ToList<QuestInfo>();
    }

    public static List<QuestConditionInfo> GetAllQuestConditionTypes()
    {
      if (QuestMgr.m_questCondictionTypes.Count == 0)
        QuestMgr.Init();
      return QuestMgr.m_questCondictionTypes.Values.ToList<QuestConditionInfo>();
    }

    public static List<QuestInfo> GetAllQuest()
    {
      if (QuestMgr.m_quests.Count == 0)
        QuestMgr.Init();
      return QuestMgr.m_quests.Values.ToList<QuestInfo>();
    }

    public static QuestInfo GetSingleQuest(int id)
    {
      if (QuestMgr.m_quests.Count == 0)
        QuestMgr.Init();
      return QuestMgr.m_quests.ContainsKey(id) ? QuestMgr.m_quests[id] : (QuestInfo) null;
    }

    public static List<QuestConditionInfo> GetQuestConditions(int id)
    {
      if (QuestMgr.m_questCondictions.Count == 0)
        QuestMgr.Init();
      return QuestMgr.m_questCondictions.ContainsKey(id) ? QuestMgr.m_questCondictions[id] : (List<QuestConditionInfo>) null;
    }

    public static QuestConditionInfo GetSingleQuestCondition(
      int id,
      int conditionId)
    {
      foreach (QuestConditionInfo questCondition in QuestMgr.GetQuestConditions(id))
      {
        if (questCondition.CondictionID == conditionId)
          return questCondition;
      }
      return (QuestConditionInfo) null;
    }

    public static List<QuestAwardInfo> GetQuestGoods(int id)
    {
      if (QuestMgr.m_questGoods.Count == 0)
        QuestMgr.Init();
      return QuestMgr.m_questGoods.ContainsKey(id) ? QuestMgr.m_questGoods[id] : (List<QuestAwardInfo>) null;
    }

    public static QuestAwardInfo GetSingleQuestGood(int id, int goodid)
    {
      foreach (QuestAwardInfo questGood in QuestMgr.GetQuestGoods(id))
      {
        if (questGood.RewardItemID == goodid)
          return questGood;
      }
      return (QuestAwardInfo) null;
    }

    public static QuestRateInfo GetAllQuestRate()
    {
      if (QuestMgr.m_quests.Count == 0)
        QuestMgr.Init();
      return QuestMgr.m_rate;
    }
  }
}
