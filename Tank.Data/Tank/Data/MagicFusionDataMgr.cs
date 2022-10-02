// Decompiled with JetBrains decompiler
// Type: Tank.Data.MagicFusionDataMgr
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
  public class MagicFusionDataMgr
  {
    private static Dictionary<int, MagicFusionDataInfo> m_magicFusionDatas = new Dictionary<int, MagicFusionDataInfo>();

    public static bool Init() => MagicFusionDataMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MagicFusionDataInfo> dictionary = MagicFusionDataMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MagicFusionDataInfo>>(ref MagicFusionDataMgr.m_magicFusionDatas, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MagicFusionDataMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MagicFusionDataInfo> LoadFromDatabase()
    {
      Dictionary<int, MagicFusionDataInfo> dictionary = new Dictionary<int, MagicFusionDataInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MagicFusionDataInfo magicFusionDataInfo in produceBussiness.GetAllMagicFusionData())
        {
          if (!dictionary.ContainsKey(magicFusionDataInfo.ID))
            dictionary.Add(magicFusionDataInfo.ID, magicFusionDataInfo);
        }
      }
      return dictionary;
    }

    public static List<MagicFusionDataInfo> GetAllMagicFusionData()
    {
      if (MagicFusionDataMgr.m_magicFusionDatas.Count == 0)
        MagicFusionDataMgr.Init();
      return MagicFusionDataMgr.m_magicFusionDatas.Values.ToList<MagicFusionDataInfo>();
    }

    public static MagicFusionDataInfo FindMagicFusionData(int id)
    {
      if (MagicFusionDataMgr.m_magicFusionDatas.Count == 0)
        MagicFusionDataMgr.Init();
      return MagicFusionDataMgr.m_magicFusionDatas.ContainsKey(id) ? MagicFusionDataMgr.m_magicFusionDatas[id] : (MagicFusionDataInfo) null;
    }
  }
}
