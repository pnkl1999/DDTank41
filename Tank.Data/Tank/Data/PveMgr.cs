// Decompiled with JetBrains decompiler
// Type: Tank.Data.PveMgr
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
  public class PveMgr
  {
    private static Dictionary<int, PveInfo> m_pves = new Dictionary<int, PveInfo>();

    public static bool Init() => PveMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, PveInfo> dictionary = PveMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, PveInfo>>(ref PveMgr.m_pves, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("PveMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, PveInfo> LoadFromDatabase()
    {
      Dictionary<int, PveInfo> dictionary = new Dictionary<int, PveInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (PveInfo pveInfo in produceBussiness.GetAllPve())
        {
          if (!dictionary.ContainsKey(pveInfo.ID))
            dictionary.Add(pveInfo.ID, pveInfo);
        }
      }
      return dictionary;
    }

    public static List<PveInfo> GetAllPve()
    {
      if (PveMgr.m_pves.Count == 0)
        PveMgr.Init();
      return PveMgr.m_pves.Values.ToList<PveInfo>();
    }

    public static PveInfo FindPve(int id)
    {
      if (PveMgr.m_pves.Count == 0)
        PveMgr.Init();
      return PveMgr.m_pves.ContainsKey(id) ? PveMgr.m_pves[id] : (PveInfo) null;
    }
  }
}
