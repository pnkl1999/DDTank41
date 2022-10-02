// Decompiled with JetBrains decompiler
// Type: Tank.Data.CardGrooveUpdateMgr
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
  public class CardGrooveUpdateMgr
  {
    private static Dictionary<int, CardGrooveUpdateInfo> m_cardGrooveUpdates = new Dictionary<int, CardGrooveUpdateInfo>();

    public static bool Init() => CardGrooveUpdateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, CardGrooveUpdateInfo> dictionary = CardGrooveUpdateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, CardGrooveUpdateInfo>>(ref CardGrooveUpdateMgr.m_cardGrooveUpdates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("CardGrooveUpdateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, CardGrooveUpdateInfo> LoadFromDatabase()
    {
      Dictionary<int, CardGrooveUpdateInfo> dictionary = new Dictionary<int, CardGrooveUpdateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (CardGrooveUpdateInfo grooveUpdateInfo in produceBussiness.GetAllCardGrooveUpdate())
        {
          if (!dictionary.ContainsKey(grooveUpdateInfo.ID))
            dictionary.Add(grooveUpdateInfo.ID, grooveUpdateInfo);
        }
      }
      return dictionary;
    }

    public static List<CardGrooveUpdateInfo> GetAllCardGrooveUpdate()
    {
      if (CardGrooveUpdateMgr.m_cardGrooveUpdates.Count == 0)
        CardGrooveUpdateMgr.Init();
      return CardGrooveUpdateMgr.m_cardGrooveUpdates.Values.ToList<CardGrooveUpdateInfo>();
    }

    public static CardGrooveUpdateInfo FindCardGrooveUpdate(int id)
    {
      if (CardGrooveUpdateMgr.m_cardGrooveUpdates.Count == 0)
        CardGrooveUpdateMgr.Init();
      return CardGrooveUpdateMgr.m_cardGrooveUpdates.ContainsKey(id) ? CardGrooveUpdateMgr.m_cardGrooveUpdates[id] : (CardGrooveUpdateInfo) null;
    }
  }
}
