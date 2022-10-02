// Decompiled with JetBrains decompiler
// Type: Tank.Data.MapMgr
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
  public class MapMgr
  {
    private static Dictionary<int, MapInfo> m_maps = new Dictionary<int, MapInfo>();

    public static bool Init() => MapMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MapInfo> dictionary = MapMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MapInfo>>(ref MapMgr.m_maps, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MapMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MapInfo> LoadFromDatabase()
    {
      Dictionary<int, MapInfo> dictionary = new Dictionary<int, MapInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MapInfo all in produceBussiness.GetAllMap())
        {
          if (!dictionary.ContainsKey(all.ID))
            dictionary.Add(all.ID, all);
        }
      }
      return dictionary;
    }

    public static List<MapInfo> GetAllMap()
    {
      if (MapMgr.m_maps.Count == 0)
        MapMgr.Init();
      return MapMgr.m_maps.Values.ToList<MapInfo>();
    }

    public static MapInfo FindMap(int id)
    {
      if (MapMgr.m_maps.Count == 0)
        MapMgr.Init();
      return MapMgr.m_maps.ContainsKey(id) ? MapMgr.m_maps[id] : (MapInfo) null;
    }
  }
}
