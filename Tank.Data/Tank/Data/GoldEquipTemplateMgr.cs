// Decompiled with JetBrains decompiler
// Type: Tank.Data.GoldEquipTemplateMgr
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
  public class GoldEquipTemplateMgr
  {
    private static Dictionary<int, GoldEquipTemplateInfo> m_goldEquipTemplates = new Dictionary<int, GoldEquipTemplateInfo>();

    public static bool Init() => GoldEquipTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, GoldEquipTemplateInfo> dictionary = GoldEquipTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, GoldEquipTemplateInfo>>(ref GoldEquipTemplateMgr.m_goldEquipTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("GoldEquipTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, GoldEquipTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, GoldEquipTemplateInfo> dictionary = new Dictionary<int, GoldEquipTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (GoldEquipTemplateInfo equipTemplateInfo in produceBussiness.GetAllGoldEquipTemplate())
        {
          if (!dictionary.ContainsKey(equipTemplateInfo.ID))
            dictionary.Add(equipTemplateInfo.ID, equipTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<GoldEquipTemplateInfo> GetAllGoldEquipTemplate()
    {
      if (GoldEquipTemplateMgr.m_goldEquipTemplates.Count == 0)
        GoldEquipTemplateMgr.Init();
      return GoldEquipTemplateMgr.m_goldEquipTemplates.Values.ToList<GoldEquipTemplateInfo>();
    }

    public static GoldEquipTemplateInfo FindGoldEquipTemplate(int id)
    {
      if (GoldEquipTemplateMgr.m_goldEquipTemplates.Count == 0)
        GoldEquipTemplateMgr.Init();
      return GoldEquipTemplateMgr.m_goldEquipTemplates.ContainsKey(id) ? GoldEquipTemplateMgr.m_goldEquipTemplates[id] : (GoldEquipTemplateInfo) null;
    }
  }
}
