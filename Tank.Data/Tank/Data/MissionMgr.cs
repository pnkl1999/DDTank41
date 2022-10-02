// Decompiled with JetBrains decompiler
// Type: Tank.Data.MissionMgr
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
  public class MissionMgr
  {
    private static Dictionary<int, MissionInfo> m_missions = new Dictionary<int, MissionInfo>();

    public static bool Init() => MissionMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MissionInfo> dictionary = MissionMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MissionInfo>>(ref MissionMgr.m_missions, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MissionMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MissionInfo> LoadFromDatabase()
    {
      Dictionary<int, MissionInfo> dictionary = new Dictionary<int, MissionInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MissionInfo missionInfo in produceBussiness.GetAllMission())
        {
          if (!dictionary.ContainsKey(missionInfo.Id))
            dictionary.Add(missionInfo.Id, missionInfo);
        }
      }
      return dictionary;
    }

    public static List<MissionInfo> GetAllMission()
    {
      if (MissionMgr.m_missions.Count == 0)
        MissionMgr.Init();
      return MissionMgr.m_missions.Values.ToList<MissionInfo>();
    }

    public static MissionInfo FindMission(int id)
    {
      if (MissionMgr.m_missions.Count == 0)
        MissionMgr.Init();
      return MissionMgr.m_missions.ContainsKey(id) ? MissionMgr.m_missions[id] : (MissionInfo) null;
    }
  }
}
