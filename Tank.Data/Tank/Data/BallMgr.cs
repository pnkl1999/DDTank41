// Decompiled with JetBrains decompiler
// Type: Tank.Data.BallMgr
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
  public class BallMgr
  {
    private static Dictionary<int, BallInfo> m_balls = new Dictionary<int, BallInfo>();

    public static bool Init() => BallMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, BallInfo> dictionary = BallMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, BallInfo>>(ref BallMgr.m_balls, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("BallMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, BallInfo> LoadFromDatabase()
    {
      Dictionary<int, BallInfo> dictionary = new Dictionary<int, BallInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (BallInfo ballInfo in produceBussiness.GetAllBall())
        {
          if (!dictionary.ContainsKey(ballInfo.ID))
            dictionary.Add(ballInfo.ID, ballInfo);
        }
      }
      return dictionary;
    }

    public static List<BallInfo> GetAllBall()
    {
      if (BallMgr.m_balls.Count == 0)
        BallMgr.Init();
      return BallMgr.m_balls.Values.ToList<BallInfo>();
    }

    public static BallInfo FindBall(int id)
    {
      if (BallMgr.m_balls.Count == 0)
        BallMgr.Init();
      return BallMgr.m_balls.ContainsKey(id) ? BallMgr.m_balls[id] : (BallInfo) null;
    }
  }
}
