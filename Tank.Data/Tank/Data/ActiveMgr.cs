// Decompiled with JetBrains decompiler
// Type: Tank.Data.ActiveMgr
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
  public class ActiveMgr
  {
    private static Dictionary<int, ActiveInfo> m_actives = new Dictionary<int, ActiveInfo>();
    private static Dictionary<int, List<ActiveAwardInfo>> m_activeGoods = new Dictionary<int, List<ActiveAwardInfo>>();
    private static Dictionary<int, List<ActiveConvertItemInfo>> m_activeConvertItems = new Dictionary<int, List<ActiveConvertItemInfo>>();

    public static bool Init() => ActiveMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ActiveInfo> actives = ActiveMgr.LoadActiveDb();
        Dictionary<int, List<ActiveAwardInfo>> dictionary1 = ActiveMgr.LoadActiveGoodDb(actives);
        Dictionary<int, List<ActiveConvertItemInfo>> dictionary2 = ActiveMgr.LoadActiveConvertItemDb(actives);
        if (actives.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ActiveInfo>>(ref ActiveMgr.m_actives, actives);
          Interlocked.Exchange<Dictionary<int, List<ActiveAwardInfo>>>(ref ActiveMgr.m_activeGoods, dictionary1);
          Interlocked.Exchange<Dictionary<int, List<ActiveConvertItemInfo>>>(ref ActiveMgr.m_activeConvertItems, dictionary2);
        }
        return true;
      }
      catch (Exception ex)
      {
        Logger.Error("ActiveMgr init error:" + ex.ToString());
      }
      return false;
    }

    public static Dictionary<int, ActiveInfo> LoadActiveDb()
    {
      Dictionary<int, ActiveInfo> dictionary = new Dictionary<int, ActiveInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ActiveInfo activeInfo in produceBussiness.GetAllActive())
        {
          if (!dictionary.ContainsKey(activeInfo.ActiveID))
            dictionary.Add(activeInfo.ActiveID, activeInfo);
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<ActiveAwardInfo>> LoadActiveGoodDb(
      Dictionary<int, ActiveInfo> actives)
    {
      Dictionary<int, List<ActiveAwardInfo>> dictionary = new Dictionary<int, List<ActiveAwardInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        ActiveAwardInfo[] allActiveAward = produceBussiness.GetAllActiveAward();
        foreach (ActiveInfo activeInfo in actives.Values)
        {
          ActiveInfo active = activeInfo;
          IEnumerable<ActiveAwardInfo> source = ((IEnumerable<ActiveAwardInfo>) allActiveAward).Where<ActiveAwardInfo>((Func<ActiveAwardInfo, bool>) (s => s.ActiveID == active.ActiveID));
          dictionary.Add(active.ActiveID, source.ToList<ActiveAwardInfo>());
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<ActiveConvertItemInfo>> LoadActiveConvertItemDb(
      Dictionary<int, ActiveInfo> actives)
    {
      Dictionary<int, List<ActiveConvertItemInfo>> dictionary = new Dictionary<int, List<ActiveConvertItemInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        ActiveConvertItemInfo[] activeConvertItem = produceBussiness.GetAllActiveConvertItem();
        foreach (ActiveInfo activeInfo in actives.Values)
        {
          ActiveInfo active = activeInfo;
          IEnumerable<ActiveConvertItemInfo> source = ((IEnumerable<ActiveConvertItemInfo>) activeConvertItem).Where<ActiveConvertItemInfo>((Func<ActiveConvertItemInfo, bool>) (s => s.ActiveID == active.ActiveID));
          dictionary.Add(active.ActiveID, source.ToList<ActiveConvertItemInfo>());
        }
      }
      return dictionary;
    }

    public static ActiveInfo GetSingleActive(int id)
    {
      if (ActiveMgr.m_actives.Count == 0)
        ActiveMgr.Init();
      return ActiveMgr.m_actives.ContainsKey(id) ? ActiveMgr.m_actives[id] : (ActiveInfo) null;
    }

    public static List<ActiveInfo> GetAllActive()
    {
      if (ActiveMgr.m_actives.Count == 0)
        ActiveMgr.Init();
      return ActiveMgr.m_actives.Values.ToList<ActiveInfo>().Where<ActiveInfo>((Func<ActiveInfo, bool>) (p => p.ActiveID > 0)).ToList<ActiveInfo>();
    }

    public static List<ActiveAwardInfo> GetActiveGoods(int id)
    {
      if (ActiveMgr.m_actives.Count == 0)
        ActiveMgr.Init();
      return ActiveMgr.m_activeGoods.ContainsKey(id) ? ActiveMgr.m_activeGoods[id] : (List<ActiveAwardInfo>) null;
    }

    public static ActiveAwardInfo GetActiveAward(int activeId, int templateID)
    {
      foreach (ActiveAwardInfo activeGood in ActiveMgr.GetActiveGoods(activeId))
      {
        if (activeGood.ItemID == templateID)
          return activeGood;
      }
      return (ActiveAwardInfo) null;
    }

    public static List<ActiveConvertItemInfo> GetActiveConvertItems(int id)
    {
      if (ActiveMgr.m_actives.Count == 0)
        ActiveMgr.Init();
      return ActiveMgr.m_activeConvertItems.ContainsKey(id) ? ActiveMgr.m_activeConvertItems[id] : (List<ActiveConvertItemInfo>) null;
    }

    public static ActiveConvertItemInfo GetActiveConvertItem(
      int activeId,
      int templateID,
      int itemType)
    {
      foreach (ActiveConvertItemInfo activeConvertItem in ActiveMgr.GetActiveConvertItems(activeId))
      {
        if (activeConvertItem.TemplateID == templateID && activeConvertItem.ItemType == itemType)
          return activeConvertItem;
      }
      return (ActiveConvertItemInfo) null;
    }
  }
}
