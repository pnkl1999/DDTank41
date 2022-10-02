// Decompiled with JetBrains decompiler
// Type: Tank.Data.FightSpiritTemplateMgr
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
  public class FightSpiritTemplateMgr
  {
    private static Dictionary<int, List<FightSpiritTemplateInfo>> m_fightSpiritTemplates = new Dictionary<int, List<FightSpiritTemplateInfo>>();

    public static bool ReLoad()
    {
      try
      {
        FightSpiritTemplateInfo[] fightSpiritTemplates = FightSpiritTemplateMgr.LoadFightSpiritTemplateDb();
        Dictionary<int, List<FightSpiritTemplateInfo>> dictionary = FightSpiritTemplateMgr.LoadFightSpiritTemplates(fightSpiritTemplates);
        if ((uint) fightSpiritTemplates.Length > 0U)
          Interlocked.Exchange<Dictionary<int, List<FightSpiritTemplateInfo>>>(ref FightSpiritTemplateMgr.m_fightSpiritTemplates, dictionary);
      }
      catch (Exception ex)
      {
        Logger.Error("FightSpiritTemplateMgr init error:" + ex.ToString());
        return false;
      }
      return true;
    }

    public static bool Init() => FightSpiritTemplateMgr.ReLoad();

    public static FightSpiritTemplateInfo[] LoadFightSpiritTemplateDb()
    {
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        return produceBussiness.GetAllFightSpiritTemplate();
    }

    public static Dictionary<int, List<FightSpiritTemplateInfo>> LoadFightSpiritTemplates(
      FightSpiritTemplateInfo[] fightSpiritTemplates)
    {
      Dictionary<int, List<FightSpiritTemplateInfo>> dictionary = new Dictionary<int, List<FightSpiritTemplateInfo>>();
      foreach (FightSpiritTemplateInfo fightSpiritTemplate in fightSpiritTemplates)
      {
        FightSpiritTemplateInfo info = fightSpiritTemplate;
        if (!dictionary.Keys.Contains<int>(info.FightSpiritID))
        {
          IEnumerable<FightSpiritTemplateInfo> source = ((IEnumerable<FightSpiritTemplateInfo>) fightSpiritTemplates).Where<FightSpiritTemplateInfo>((Func<FightSpiritTemplateInfo, bool>) (s => s.FightSpiritID == info.FightSpiritID));
          dictionary.Add(info.FightSpiritID, source.ToList<FightSpiritTemplateInfo>());
        }
      }
      return dictionary;
    }

    public static List<FightSpiritTemplateInfo> GetAllFightSpiritTemplate()
    {
      if (FightSpiritTemplateMgr.m_fightSpiritTemplates.Count == 0)
        FightSpiritTemplateMgr.Init();
      List<FightSpiritTemplateInfo> spiritTemplateInfoList = new List<FightSpiritTemplateInfo>();
      foreach (int key in FightSpiritTemplateMgr.m_fightSpiritTemplates.Keys)
        spiritTemplateInfoList.AddRange((IEnumerable<FightSpiritTemplateInfo>) FightSpiritTemplateMgr.m_fightSpiritTemplates[key]);
      return spiritTemplateInfoList;
    }

    public static FightSpiritTemplateInfo FindFightSpiritTemplate(
      int id,
      int lv)
    {
      if (FightSpiritTemplateMgr.m_fightSpiritTemplates.Count == 0)
        FightSpiritTemplateMgr.Init();
      if (FightSpiritTemplateMgr.m_fightSpiritTemplates.ContainsKey(id))
      {
        foreach (FightSpiritTemplateInfo spiritTemplateInfo in FightSpiritTemplateMgr.m_fightSpiritTemplates[id])
        {
          if (spiritTemplateInfo.Level == lv)
            return spiritTemplateInfo;
        }
      }
      return (FightSpiritTemplateInfo) null;
    }
  }
}
