// Decompiled with JetBrains decompiler
// Type: Tank.Data.MagicItemTemplateMgr
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
  public class MagicItemTemplateMgr
  {
    private static Dictionary<int, MagicItemTemplateInfo> m_magicItemTemplates = new Dictionary<int, MagicItemTemplateInfo>();

    public static bool Init() => MagicItemTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MagicItemTemplateInfo> dictionary = MagicItemTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MagicItemTemplateInfo>>(ref MagicItemTemplateMgr.m_magicItemTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MagicItemTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MagicItemTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, MagicItemTemplateInfo> dictionary = new Dictionary<int, MagicItemTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MagicItemTemplateInfo itemTemplateInfo in produceBussiness.GetAllMagicItemTemplate())
        {
          if (!dictionary.ContainsKey(itemTemplateInfo.Lv))
            dictionary.Add(itemTemplateInfo.Lv, itemTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<MagicItemTemplateInfo> GetAllMagicItemTemplate()
    {
      if (MagicItemTemplateMgr.m_magicItemTemplates.Count == 0)
        MagicItemTemplateMgr.Init();
      return MagicItemTemplateMgr.m_magicItemTemplates.Values.ToList<MagicItemTemplateInfo>();
    }

    public static MagicItemTemplateInfo FindMagicItemTemplate(int id)
    {
      if (MagicItemTemplateMgr.m_magicItemTemplates.Count == 0)
        MagicItemTemplateMgr.Init();
      return MagicItemTemplateMgr.m_magicItemTemplates.ContainsKey(id) ? MagicItemTemplateMgr.m_magicItemTemplates[id] : (MagicItemTemplateInfo) null;
    }
  }
}
