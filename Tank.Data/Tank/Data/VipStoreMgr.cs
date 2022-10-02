// Decompiled with JetBrains decompiler
// Type: Tank.Data.VipStoreMgr
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
  public class VipStoreMgr
  {
    private static Dictionary<int, VipStoreInfo> m_vipStores = new Dictionary<int, VipStoreInfo>();

    public static bool Init() => VipStoreMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, VipStoreInfo> dictionary = VipStoreMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, VipStoreInfo>>(ref VipStoreMgr.m_vipStores, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("VipStoreMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, VipStoreInfo> LoadFromDatabase()
    {
      Dictionary<int, VipStoreInfo> dictionary = new Dictionary<int, VipStoreInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (VipStoreInfo vipStoreInfo in produceBussiness.GetAllVipStore())
        {
          if (!dictionary.ContainsKey(vipStoreInfo.ID))
            dictionary.Add(vipStoreInfo.ID, vipStoreInfo);
        }
      }
      return dictionary;
    }

    public static List<VipStoreInfo> GetAllVipStore()
    {
      if (VipStoreMgr.m_vipStores.Count == 0)
        VipStoreMgr.Init();
      return VipStoreMgr.m_vipStores.Values.ToList<VipStoreInfo>();
    }

    public static VipStoreInfo FindVipStore(int id)
    {
      if (VipStoreMgr.m_vipStores.Count == 0)
        VipStoreMgr.Init();
      return VipStoreMgr.m_vipStores.ContainsKey(id) ? VipStoreMgr.m_vipStores[id] : (VipStoreInfo) null;
    }
  }
}
