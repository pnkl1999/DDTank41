// Decompiled with JetBrains decompiler
// Type: Tank.Data.MountTemplateMgr
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
  public class MountTemplateMgr
  {
    private static Dictionary<int, MountTemplateInfo> m_mountTemplates = new Dictionary<int, MountTemplateInfo>();

    public static bool Init() => MountTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MountTemplateInfo> dictionary = MountTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, MountTemplateInfo>>(ref MountTemplateMgr.m_mountTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("MountTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, MountTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, MountTemplateInfo> dictionary = new Dictionary<int, MountTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MountTemplateInfo mountTemplateInfo in produceBussiness.GetAllMountTemplate())
        {
          if (!dictionary.ContainsKey(mountTemplateInfo.Grade))
            dictionary.Add(mountTemplateInfo.Grade, mountTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<MountTemplateInfo> GetAllMountTemplate()
    {
      if (MountTemplateMgr.m_mountTemplates.Count == 0)
        MountTemplateMgr.Init();
      return MountTemplateMgr.m_mountTemplates.Values.ToList<MountTemplateInfo>();
    }

    public static MountTemplateInfo FindMountTemplate(int id)
    {
      if (MountTemplateMgr.m_mountTemplates.Count == 0)
        MountTemplateMgr.Init();
      return MountTemplateMgr.m_mountTemplates.ContainsKey(id) ? MountTemplateMgr.m_mountTemplates[id] : (MountTemplateInfo) null;
    }
  }
}
