// Decompiled with JetBrains decompiler
// Type: Tank.Data.MissionEnergyMgr
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
  public class MissionEnergyMgr
  {
    private static Dictionary<int, MissionEnergyInfo> m_missionEnergys = new Dictionary<int, MissionEnergyInfo>();

    public static bool Init() => MissionEnergyMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MissionEnergyInfo> dictionary = MissionEnergyMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MissionEnergyInfo>>(ref MissionEnergyMgr.m_missionEnergys, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MissionEnergyMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MissionEnergyInfo> LoadFromDatabase()
    {
      Dictionary<int, MissionEnergyInfo> dictionary = new Dictionary<int, MissionEnergyInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MissionEnergyInfo missionEnergyInfo in produceBussiness.GetAllMissionEnergy())
        {
          if (!dictionary.ContainsKey(missionEnergyInfo.Count))
            dictionary.Add(missionEnergyInfo.Count, missionEnergyInfo);
        }
      }
      return dictionary;
    }

    public static List<MissionEnergyInfo> GetAllMissionEnergy()
    {
      if (MissionEnergyMgr.m_missionEnergys.Count == 0)
        MissionEnergyMgr.Init();
      return MissionEnergyMgr.m_missionEnergys.Values.ToList<MissionEnergyInfo>();
    }

    public static MissionEnergyInfo FindMissionEnergy(int id)
    {
      if (MissionEnergyMgr.m_missionEnergys.Count == 0)
        MissionEnergyMgr.Init();
      return MissionEnergyMgr.m_missionEnergys.ContainsKey(id) ? MissionEnergyMgr.m_missionEnergys[id] : (MissionEnergyInfo) null;
    }
  }
}
