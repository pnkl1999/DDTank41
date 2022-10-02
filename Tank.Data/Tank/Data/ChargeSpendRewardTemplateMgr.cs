// Decompiled with JetBrains decompiler
// Type: Tank.Data.ChargeSpendRewardTemplateMgr
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
  public class ChargeSpendRewardTemplateMgr
  {
    private static Dictionary<int, ChargeSpendRewardTemplateInfo> m_chargeSpendRewardTemplates = new Dictionary<int, ChargeSpendRewardTemplateInfo>();

    public static bool Init() => ChargeSpendRewardTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ChargeSpendRewardTemplateInfo> dictionary = ChargeSpendRewardTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ChargeSpendRewardTemplateInfo>>(ref ChargeSpendRewardTemplateMgr.m_chargeSpendRewardTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("ChargeSpendRewardTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ChargeSpendRewardTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, ChargeSpendRewardTemplateInfo> dictionary = new Dictionary<int, ChargeSpendRewardTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ChargeSpendRewardTemplateInfo rewardTemplateInfo in produceBussiness.GetAllChargeSpendRewardTemplate())
        {
          if (!dictionary.ContainsKey(rewardTemplateInfo.ID))
            dictionary.Add(rewardTemplateInfo.ID, rewardTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<ChargeSpendRewardTemplateInfo> GetAllChargeSpendRewardTemplate()
    {
      if (ChargeSpendRewardTemplateMgr.m_chargeSpendRewardTemplates.Count == 0)
        ChargeSpendRewardTemplateMgr.Init();
      return ChargeSpendRewardTemplateMgr.m_chargeSpendRewardTemplates.Values.ToList<ChargeSpendRewardTemplateInfo>();
    }

    public static ChargeSpendRewardTemplateInfo FindChargeSpendRewardTemplate(
      int id)
    {
      if (ChargeSpendRewardTemplateMgr.m_chargeSpendRewardTemplates.Count == 0)
        ChargeSpendRewardTemplateMgr.Init();
      return ChargeSpendRewardTemplateMgr.m_chargeSpendRewardTemplates.ContainsKey(id) ? ChargeSpendRewardTemplateMgr.m_chargeSpendRewardTemplates[id] : (ChargeSpendRewardTemplateInfo) null;
    }
  }
}
