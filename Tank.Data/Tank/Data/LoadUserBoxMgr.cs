// Decompiled with JetBrains decompiler
// Type: Tank.Data.LoadUserBoxMgr
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
  public class LoadUserBoxMgr
  {
    private static Dictionary<int, LoadUserBoxInfo> m_loadUserBoxs = new Dictionary<int, LoadUserBoxInfo>();

    public static bool Init() => LoadUserBoxMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, LoadUserBoxInfo> dictionary = LoadUserBoxMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, LoadUserBoxInfo>>(ref LoadUserBoxMgr.m_loadUserBoxs, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("LoadUserBoxMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, LoadUserBoxInfo> LoadFromDatabase()
    {
      Dictionary<int, LoadUserBoxInfo> dictionary = new Dictionary<int, LoadUserBoxInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (LoadUserBoxInfo loadUserBoxInfo in produceBussiness.GetAllLoadUserBox())
        {
          if (!dictionary.ContainsKey(loadUserBoxInfo.ID))
            dictionary.Add(loadUserBoxInfo.ID, loadUserBoxInfo);
        }
      }
      return dictionary;
    }

    public static List<LoadUserBoxInfo> GetAllLoadUserBox()
    {
      if (LoadUserBoxMgr.m_loadUserBoxs.Count == 0)
        LoadUserBoxMgr.Init();
      return LoadUserBoxMgr.m_loadUserBoxs.Values.ToList<LoadUserBoxInfo>();
    }

    public static LoadUserBoxInfo FindLoadUserBox(int id)
    {
      if (LoadUserBoxMgr.m_loadUserBoxs.Count == 0)
        LoadUserBoxMgr.Init();
      return LoadUserBoxMgr.m_loadUserBoxs.ContainsKey(id) ? LoadUserBoxMgr.m_loadUserBoxs[id] : (LoadUserBoxInfo) null;
    }
  }
}
