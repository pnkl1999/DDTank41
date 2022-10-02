// Decompiled with JetBrains decompiler
// Type: Tank.Data.NewTitleMgr
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
  public class NewTitleMgr
  {
    private static Dictionary<int, NewTitleInfo> m_newTitles = new Dictionary<int, NewTitleInfo>();

    public static bool Init() => NewTitleMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, NewTitleInfo> dictionary = NewTitleMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, NewTitleInfo>>(ref NewTitleMgr.m_newTitles, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("NewTitleMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, NewTitleInfo> LoadFromDatabase()
    {
      Dictionary<int, NewTitleInfo> dictionary = new Dictionary<int, NewTitleInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (NewTitleInfo newTitleInfo in produceBussiness.GetAllNewTitle())
        {
          if (!dictionary.ContainsKey(newTitleInfo.ID))
            dictionary.Add(newTitleInfo.ID, newTitleInfo);
        }
      }
      return dictionary;
    }

    public static List<NewTitleInfo> GetAllNewTitle()
    {
      if (NewTitleMgr.m_newTitles.Count == 0)
        NewTitleMgr.Init();
      return NewTitleMgr.m_newTitles.Values.ToList<NewTitleInfo>();
    }

    public static NewTitleInfo FindNewTitle(int id)
    {
      if (NewTitleMgr.m_newTitles.Count == 0)
        NewTitleMgr.Init();
      return NewTitleMgr.m_newTitles.ContainsKey(id) ? NewTitleMgr.m_newTitles[id] : (NewTitleInfo) null;
    }
  }
}
