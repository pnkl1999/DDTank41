// Decompiled with JetBrains decompiler
// Type: Tank.Data.RankTemplateMgr
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
  public class RankTemplateMgr
  {
    private static Dictionary<int, RankTemplateInfo> m_rankTemplates = new Dictionary<int, RankTemplateInfo>();

    public static bool Init() => RankTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, RankTemplateInfo> dictionary = RankTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, RankTemplateInfo>>(ref RankTemplateMgr.m_rankTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("RankTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, RankTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, RankTemplateInfo> dictionary = new Dictionary<int, RankTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (RankTemplateInfo rankTemplateInfo in produceBussiness.GetAllRankTemplate())
        {
          if (!dictionary.ContainsKey(rankTemplateInfo.ID))
            dictionary.Add(rankTemplateInfo.ID, rankTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<RankTemplateInfo> GetAllRankTemplate()
    {
      if (RankTemplateMgr.m_rankTemplates.Count == 0)
        RankTemplateMgr.Init();
      return RankTemplateMgr.m_rankTemplates.Values.ToList<RankTemplateInfo>();
    }

    public static RankTemplateInfo FindRankTemplate(int id)
    {
      if (RankTemplateMgr.m_rankTemplates.Count == 0)
        RankTemplateMgr.Init();
      return RankTemplateMgr.m_rankTemplates.ContainsKey(id) ? RankTemplateMgr.m_rankTemplates[id] : (RankTemplateInfo) null;
    }

    public static object FindRankTemplate(string rank) => throw new NotImplementedException();
  }
}
