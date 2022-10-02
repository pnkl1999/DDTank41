// Decompiled with JetBrains decompiler
// Type: Tank.Data.HomeTempPracticeMgr
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
  public class HomeTempPracticeMgr
  {
    private static Dictionary<int, HomeTempPracticeInfo> m_homeTempPractices = new Dictionary<int, HomeTempPracticeInfo>();

    public static bool Init() => HomeTempPracticeMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, HomeTempPracticeInfo> dictionary = HomeTempPracticeMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, HomeTempPracticeInfo>>(ref HomeTempPracticeMgr.m_homeTempPractices, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("HomeTempPracticeMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, HomeTempPracticeInfo> LoadFromDatabase()
    {
      Dictionary<int, HomeTempPracticeInfo> dictionary = new Dictionary<int, HomeTempPracticeInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (HomeTempPracticeInfo tempPracticeInfo in produceBussiness.GetAllHomeTempPractice())
        {
          if (!dictionary.ContainsKey(tempPracticeInfo.Level))
            dictionary.Add(tempPracticeInfo.Level, tempPracticeInfo);
        }
      }
      return dictionary;
    }

    public static List<HomeTempPracticeInfo> GetAllHomeTempPractice()
    {
      if (HomeTempPracticeMgr.m_homeTempPractices.Count == 0)
        HomeTempPracticeMgr.Init();
      return HomeTempPracticeMgr.m_homeTempPractices.Values.ToList<HomeTempPracticeInfo>();
    }

    public static HomeTempPracticeInfo FindHomeTempPractice(int id)
    {
      if (HomeTempPracticeMgr.m_homeTempPractices.Count == 0)
        HomeTempPracticeMgr.Init();
      return HomeTempPracticeMgr.m_homeTempPractices.ContainsKey(id) ? HomeTempPracticeMgr.m_homeTempPractices[id] : (HomeTempPracticeInfo) null;
    }
  }
}
