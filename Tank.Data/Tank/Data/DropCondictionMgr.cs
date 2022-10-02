// Decompiled with JetBrains decompiler
// Type: Tank.Data.DropCondictionMgr
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
  public class DropCondictionMgr
  {
    private static Dictionary<int, DropCondiction> m_dropCondictions = new Dictionary<int, DropCondiction>();

    public static bool Init() => DropCondictionMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, DropCondiction> dictionary = DropCondictionMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, DropCondiction>>(ref DropCondictionMgr.m_dropCondictions, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("DropCondictionMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, DropCondiction> LoadFromDatabase()
    {
      Dictionary<int, DropCondiction> dictionary = new Dictionary<int, DropCondiction>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (DropCondiction dropCondiction in produceBussiness.GetAllDropCondiction())
        {
          if (!dictionary.ContainsKey(dropCondiction.DropId))
            dictionary.Add(dropCondiction.DropId, dropCondiction);
        }
      }
      return dictionary;
    }

    public static List<DropCondiction> GetAllDropCondiction()
    {
      if (DropCondictionMgr.m_dropCondictions.Count == 0)
        DropCondictionMgr.Init();
      return DropCondictionMgr.m_dropCondictions.Values.ToList<DropCondiction>();
    }

    public static List<DropCondiction> GetAllDropCondiction(
      int type,
      string para1)
    {
      List<DropCondiction> dropCondictionList = new List<DropCondiction>();
      foreach (DropCondiction dropCondiction in DropCondictionMgr.m_dropCondictions.Values)
      {
        if (dropCondiction.CondictionType == type && dropCondiction.Para1.IndexOf(para1) != -1)
          dropCondictionList.Add(dropCondiction);
      }
      return dropCondictionList;
    }

    public static DropCondiction FindDropCondiction(int id)
    {
      if (DropCondictionMgr.m_dropCondictions.Count == 0)
        DropCondictionMgr.Init();
      return DropCondictionMgr.m_dropCondictions.ContainsKey(id) ? DropCondictionMgr.m_dropCondictions[id] : (DropCondiction) null;
    }

    public static DropCondiction FindDropCondiction(
      int type,
      string para1,
      string para2)
    {
      if (DropCondictionMgr.m_dropCondictions.Count == 0)
        DropCondictionMgr.Init();
      foreach (DropCondiction dropCondiction in DropCondictionMgr.m_dropCondictions.Values)
      {
        if (dropCondiction.CondictionType == type && dropCondiction.Para1.IndexOf(para1) != -1 && dropCondiction.Para2.IndexOf(para2) != -1)
          return dropCondiction;
      }
      return (DropCondiction) null;
    }
  }
}
