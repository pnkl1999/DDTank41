// Decompiled with JetBrains decompiler
// Type: Tank.Data.ConsortiaBufferTempMgr
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
  public class ConsortiaBufferTempMgr
  {
    private static Dictionary<int, ConsortiaBufferTempInfo> m_consortiaBufferTemps = new Dictionary<int, ConsortiaBufferTempInfo>();

    public static bool Init() => ConsortiaBufferTempMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ConsortiaBufferTempInfo> dictionary = ConsortiaBufferTempMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ConsortiaBufferTempInfo>>(ref ConsortiaBufferTempMgr.m_consortiaBufferTemps, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("ConsortiaBufferTempMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ConsortiaBufferTempInfo> LoadFromDatabase()
    {
      Dictionary<int, ConsortiaBufferTempInfo> dictionary = new Dictionary<int, ConsortiaBufferTempInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ConsortiaBufferTempInfo consortiaBufferTempInfo in produceBussiness.GetAllConsortiaBufferTemp())
        {
          if (!dictionary.ContainsKey(consortiaBufferTempInfo.id))
            dictionary.Add(consortiaBufferTempInfo.id, consortiaBufferTempInfo);
        }
      }
      return dictionary;
    }

    public static List<ConsortiaBufferTempInfo> GetAllConsortiaBufferTemp()
    {
      if (ConsortiaBufferTempMgr.m_consortiaBufferTemps.Count == 0)
        ConsortiaBufferTempMgr.Init();
      return ConsortiaBufferTempMgr.m_consortiaBufferTemps.Values.ToList<ConsortiaBufferTempInfo>();
    }

    public static ConsortiaBufferTempInfo FindConsortiaBufferTemp(int id)
    {
      if (ConsortiaBufferTempMgr.m_consortiaBufferTemps.Count == 0)
        ConsortiaBufferTempMgr.Init();
      return ConsortiaBufferTempMgr.m_consortiaBufferTemps.ContainsKey(id) ? ConsortiaBufferTempMgr.m_consortiaBufferTemps[id] : (ConsortiaBufferTempInfo) null;
    }
  }
}
