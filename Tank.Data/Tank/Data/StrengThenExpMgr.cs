// Decompiled with JetBrains decompiler
// Type: Tank.Data.StrengThenExpMgr
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
  public class StrengThenExpMgr
  {
    private static Dictionary<int, StrengThenExpInfo> m_strengThenExps = new Dictionary<int, StrengThenExpInfo>();

    public static bool Init() => StrengThenExpMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, StrengThenExpInfo> dictionary = StrengThenExpMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, StrengThenExpInfo>>(ref StrengThenExpMgr.m_strengThenExps, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("StrengThenExpMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, StrengThenExpInfo> LoadFromDatabase()
    {
      Dictionary<int, StrengThenExpInfo> dictionary = new Dictionary<int, StrengThenExpInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (StrengThenExpInfo strengThenExpInfo in produceBussiness.GetAllStrengThenExp())
        {
          if (!dictionary.ContainsKey(strengThenExpInfo.ID))
            dictionary.Add(strengThenExpInfo.ID, strengThenExpInfo);
        }
      }
      return dictionary;
    }

    public static List<StrengThenExpInfo> GetAllStrengThenExp()
    {
      if (StrengThenExpMgr.m_strengThenExps.Count == 0)
        StrengThenExpMgr.Init();
      return StrengThenExpMgr.m_strengThenExps.Values.ToList<StrengThenExpInfo>();
    }

    public static StrengThenExpInfo FindStrengThenExp(int id)
    {
      if (StrengThenExpMgr.m_strengThenExps.Count == 0)
        StrengThenExpMgr.Init();
      return StrengThenExpMgr.m_strengThenExps.ContainsKey(id) ? StrengThenExpMgr.m_strengThenExps[id] : (StrengThenExpInfo) null;
    }
  }
}
