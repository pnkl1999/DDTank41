// Decompiled with JetBrains decompiler
// Type: Tank.Data.BallConfigMgr
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
  public class BallConfigMgr
  {
    private static Dictionary<int, BallConfigInfo> m_ballConfigs = new Dictionary<int, BallConfigInfo>();

    public static bool Init() => BallConfigMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, BallConfigInfo> dictionary = BallConfigMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, BallConfigInfo>>(ref BallConfigMgr.m_ballConfigs, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("BallConfigMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, BallConfigInfo> LoadFromDatabase()
    {
      Dictionary<int, BallConfigInfo> dictionary = new Dictionary<int, BallConfigInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (BallConfigInfo ballConfigInfo in produceBussiness.GetAllBallConfig())
        {
          if (!dictionary.ContainsKey(ballConfigInfo.TemplateID))
            dictionary.Add(ballConfigInfo.TemplateID, ballConfigInfo);
        }
      }
      return dictionary;
    }

    public static List<BallConfigInfo> GetAllBallConfig()
    {
      if (BallConfigMgr.m_ballConfigs.Count == 0)
        BallConfigMgr.Init();
      return BallConfigMgr.m_ballConfigs.Values.ToList<BallConfigInfo>();
    }

    public static BallConfigInfo FindBallConfig(int id)
    {
      if (BallConfigMgr.m_ballConfigs.Count == 0)
        BallConfigMgr.Init();
      return BallConfigMgr.m_ballConfigs.ContainsKey(id) ? BallConfigMgr.m_ballConfigs[id] : (BallConfigInfo) null;
    }
  }
}
