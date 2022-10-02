// Decompiled with JetBrains decompiler
// Type: Tank.Data.LoginAwardItemTemplateMgr
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
  public class LoginAwardItemTemplateMgr
  {
    private static Dictionary<int, LoginAwardItemTemplateInfo> m_loginAwardItemTemplates = new Dictionary<int, LoginAwardItemTemplateInfo>();

    public static bool Init() => LoginAwardItemTemplateMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, LoginAwardItemTemplateInfo> dictionary = LoginAwardItemTemplateMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, LoginAwardItemTemplateInfo>>(ref LoginAwardItemTemplateMgr.m_loginAwardItemTemplates, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("LoginAwardItemTemplateMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, LoginAwardItemTemplateInfo> LoadFromDatabase()
    {
      Dictionary<int, LoginAwardItemTemplateInfo> dictionary = new Dictionary<int, LoginAwardItemTemplateInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (LoginAwardItemTemplateInfo itemTemplateInfo in produceBussiness.GetAllLoginAwardItemTemplate())
        {
          if (!dictionary.ContainsKey(itemTemplateInfo.ID))
            dictionary.Add(itemTemplateInfo.ID, itemTemplateInfo);
        }
      }
      return dictionary;
    }

    public static List<LoginAwardItemTemplateInfo> GetAllLoginAwardItemTemplate()
    {
      if (LoginAwardItemTemplateMgr.m_loginAwardItemTemplates.Count == 0)
        LoginAwardItemTemplateMgr.Init();
      return LoginAwardItemTemplateMgr.m_loginAwardItemTemplates.Values.ToList<LoginAwardItemTemplateInfo>();
    }

    public static LoginAwardItemTemplateInfo FindLoginAwardItemTemplate(
      int id)
    {
      if (LoginAwardItemTemplateMgr.m_loginAwardItemTemplates.Count == 0)
        LoginAwardItemTemplateMgr.Init();
      return LoginAwardItemTemplateMgr.m_loginAwardItemTemplates.ContainsKey(id) ? LoginAwardItemTemplateMgr.m_loginAwardItemTemplates[id] : (LoginAwardItemTemplateInfo) null;
    }
  }
}
