// Decompiled with JetBrains decompiler
// Type: Tank.Data.SetsBuildTempMgr
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
  public class SetsBuildTempMgr
  {
    private static Dictionary<int, SetsBuildTempInfo> m_setsBuildTemps = new Dictionary<int, SetsBuildTempInfo>();

    public static bool Init() => SetsBuildTempMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, SetsBuildTempInfo> dictionary = SetsBuildTempMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, SetsBuildTempInfo>>(ref SetsBuildTempMgr.m_setsBuildTemps, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("SetsBuildTempMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, SetsBuildTempInfo> LoadFromDatabase()
    {
      Dictionary<int, SetsBuildTempInfo> dictionary = new Dictionary<int, SetsBuildTempInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (SetsBuildTempInfo setsBuildTempInfo in produceBussiness.GetAllSetsBuildTemp())
        {
          if (!dictionary.ContainsKey(setsBuildTempInfo.Level))
            dictionary.Add(setsBuildTempInfo.Level, setsBuildTempInfo);
        }
      }
      return dictionary;
    }

    public static List<SetsBuildTempInfo> GetAllSetsBuildTemp()
    {
      if (SetsBuildTempMgr.m_setsBuildTemps.Count == 0)
        SetsBuildTempMgr.Init();
      return SetsBuildTempMgr.m_setsBuildTemps.Values.ToList<SetsBuildTempInfo>();
    }

    public static SetsBuildTempInfo FindSetsBuildTemp(int id)
    {
      if (SetsBuildTempMgr.m_setsBuildTemps.Count == 0)
        SetsBuildTempMgr.Init();
      return SetsBuildTempMgr.m_setsBuildTemps.ContainsKey(id) ? SetsBuildTempMgr.m_setsBuildTemps[id] : (SetsBuildTempInfo) null;
    }
  }
}
