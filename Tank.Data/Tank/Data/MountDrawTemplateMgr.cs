// Decompiled with JetBrains decompiler
// Type: Tank.Data.MountDrawTemplateMgr
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
  public class MountDrawTemplateMgr
  {
    private static Dictionary<int, MountDrawTemplateInfo> m_mountDrawTemplates = new Dictionary<int, MountDrawTemplateInfo>();

    public static bool Init() => MountDrawTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MountDrawTemplateInfo> dictionary = MountDrawTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MountDrawTemplateInfo>>(ref MountDrawTemplateMgr.m_mountDrawTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MountDrawTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MountDrawTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, MountDrawTemplateInfo> dictionary = new Dictionary<int, MountDrawTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MountDrawTemplateInfo drawTemplateInfo in produceBussiness.GetAllMountDrawTemplate())
        {
          if (!dictionary.ContainsKey(drawTemplateInfo.ID))
            dictionary.Add(drawTemplateInfo.ID, drawTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<MountDrawTemplateInfo> GetAllMountDrawTemplate()
    {
      if (MountDrawTemplateMgr.m_mountDrawTemplates.Count == 0)
        MountDrawTemplateMgr.Init();
      return MountDrawTemplateMgr.m_mountDrawTemplates.Values.ToList<MountDrawTemplateInfo>();
    }

    public static MountDrawTemplateInfo FindMountDrawTemplate(int id)
    {
      if (MountDrawTemplateMgr.m_mountDrawTemplates.Count == 0)
        MountDrawTemplateMgr.Init();
      return MountDrawTemplateMgr.m_mountDrawTemplates.ContainsKey(id) ? MountDrawTemplateMgr.m_mountDrawTemplates[id] : (MountDrawTemplateInfo) null;
    }
  }
}
