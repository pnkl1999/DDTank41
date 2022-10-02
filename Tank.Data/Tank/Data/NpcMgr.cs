// Decompiled with JetBrains decompiler
// Type: Tank.Data.NpcMgr
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
  public class NpcMgr
  {
    private static Dictionary<int, NpcInfo> m_npcs = new Dictionary<int, NpcInfo>();

    public static bool Init() => NpcMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, NpcInfo> dictionary = NpcMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, NpcInfo>>(ref NpcMgr.m_npcs, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("NpcMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, NpcInfo> LoadFromDatabase()
    {
      Dictionary<int, NpcInfo> dictionary = new Dictionary<int, NpcInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (NpcInfo npcInfo in produceBussiness.GetAllNpc())
        {
          if (!dictionary.ContainsKey(npcInfo.ID))
            dictionary.Add(npcInfo.ID, npcInfo);
        }
      }
      return dictionary;
    }

    public static List<NpcInfo> GetAllNpc()
    {
      if (NpcMgr.m_npcs.Count == 0)
        NpcMgr.Init();
      return NpcMgr.m_npcs.Values.ToList<NpcInfo>();
    }

    public static NpcInfo FindNpc(int id)
    {
      if (NpcMgr.m_npcs.Count == 0)
        NpcMgr.Init();
      return NpcMgr.m_npcs.ContainsKey(id) ? NpcMgr.m_npcs[id] : (NpcInfo) null;
    }
  }
}
