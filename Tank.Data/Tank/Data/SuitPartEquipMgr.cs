// Decompiled with JetBrains decompiler
// Type: Tank.Data.SuitPartEquipMgr
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
  public class SuitPartEquipMgr
  {
    private static Dictionary<int, SuitPartEquipInfo> m_suitPartEquips = new Dictionary<int, SuitPartEquipInfo>();

    public static bool Init() => SuitPartEquipMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, SuitPartEquipInfo> dictionary = SuitPartEquipMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, SuitPartEquipInfo>>(ref SuitPartEquipMgr.m_suitPartEquips, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("SuitPartEquipMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, SuitPartEquipInfo> LoadFromDatabase()
    {
      Dictionary<int, SuitPartEquipInfo> dictionary = new Dictionary<int, SuitPartEquipInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (SuitPartEquipInfo suitPartEquipInfo in produceBussiness.GetAllSuitPartEquip())
        {
          if (!dictionary.ContainsKey(suitPartEquipInfo.ID))
            dictionary.Add(suitPartEquipInfo.ID, suitPartEquipInfo);
        }
      }
      return dictionary;
    }

    public static List<SuitPartEquipInfo> GetAllSuitPartEquip()
    {
      if (SuitPartEquipMgr.m_suitPartEquips.Count == 0)
        SuitPartEquipMgr.Init();
      return SuitPartEquipMgr.m_suitPartEquips.Values.ToList<SuitPartEquipInfo>();
    }

    public static SuitPartEquipInfo FindSuitPartEquip(int id)
    {
      if (SuitPartEquipMgr.m_suitPartEquips.Count == 0)
        SuitPartEquipMgr.Init();
      return SuitPartEquipMgr.m_suitPartEquips.ContainsKey(id) ? SuitPartEquipMgr.m_suitPartEquips[id] : (SuitPartEquipInfo) null;
    }
  }
}
