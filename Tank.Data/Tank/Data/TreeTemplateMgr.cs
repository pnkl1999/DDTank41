// Decompiled with JetBrains decompiler
// Type: Tank.Data.TreeTemplateMgr
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
  public class TreeTemplateMgr
  {
    private static Dictionary<int, TreeTemplateInfo> m_treeTemplates = new Dictionary<int, TreeTemplateInfo>();

    public static bool Init() => TreeTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, TreeTemplateInfo> dictionary = TreeTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, TreeTemplateInfo>>(ref TreeTemplateMgr.m_treeTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("TreeTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, TreeTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, TreeTemplateInfo> dictionary = new Dictionary<int, TreeTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (TreeTemplateInfo treeTemplateInfo in produceBussiness.GetAllTreeTemplate())
        {
          if (!dictionary.ContainsKey(treeTemplateInfo.Level))
            dictionary.Add(treeTemplateInfo.Level, treeTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<TreeTemplateInfo> GetAllTreeTemplate()
    {
      if (TreeTemplateMgr.m_treeTemplates.Count == 0)
        TreeTemplateMgr.Init();
      return TreeTemplateMgr.m_treeTemplates.Values.ToList<TreeTemplateInfo>();
    }

    public static TreeTemplateInfo FindTreeTemplate(int id)
    {
      if (TreeTemplateMgr.m_treeTemplates.Count == 0)
        TreeTemplateMgr.Init();
      return TreeTemplateMgr.m_treeTemplates.ContainsKey(id) ? TreeTemplateMgr.m_treeTemplates[id] : (TreeTemplateInfo) null;
    }
  }
}
