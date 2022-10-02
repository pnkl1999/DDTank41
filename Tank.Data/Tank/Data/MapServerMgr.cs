// Decompiled with JetBrains decompiler
// Type: Tank.Data.MapServerMgr
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
  public class MapServerMgr
  {
    private static Dictionary<int, MapServerInfo> m_mapServers = new Dictionary<int, MapServerInfo>();

    public static bool Init() => MapServerMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MapServerInfo> dictionary = MapServerMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MapServerInfo>>(ref MapServerMgr.m_mapServers, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MapServerMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MapServerInfo> LoadFromDatabase()
    {
      Dictionary<int, MapServerInfo> dictionary = new Dictionary<int, MapServerInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MapServerInfo mapServerInfo in produceBussiness.GetAllMapServer())
        {
          if (!dictionary.ContainsKey(mapServerInfo.ServerID))
            dictionary.Add(mapServerInfo.ServerID, mapServerInfo);
        }
      }
      return dictionary;
    }

    public static List<MapServerInfo> GetAllMapServer()
    {
      if (MapServerMgr.m_mapServers.Count == 0)
        MapServerMgr.Init();
      return MapServerMgr.m_mapServers.Values.ToList<MapServerInfo>();
    }

    public static MapServerInfo FindMapServer(int id)
    {
      if (MapServerMgr.m_mapServers.Count == 0)
        MapServerMgr.Init();
      return MapServerMgr.m_mapServers.ContainsKey(id) ? MapServerMgr.m_mapServers[id] : (MapServerInfo) null;
    }
  }
}
