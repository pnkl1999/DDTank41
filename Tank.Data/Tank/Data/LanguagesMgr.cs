// Decompiled with JetBrains decompiler
// Type: Tank.Data.LanguagesMgr
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
  public class LanguagesMgr
  {
    private static Dictionary<int, LanguageInfo> m_languages = new Dictionary<int, LanguageInfo>();

    public static bool Init() => LanguagesMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, LanguageInfo> dictionary = LanguagesMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, LanguageInfo>>(ref LanguagesMgr.m_languages, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("LanguageMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, LanguageInfo> LoadFromDatabase()
    {
      Dictionary<int, LanguageInfo> dictionary = new Dictionary<int, LanguageInfo>();
      using (WebBussiness webBussiness = new WebBussiness())
      {
        foreach (LanguageInfo languageInfo in webBussiness.GetAllLanguage())
        {
          if (!dictionary.ContainsKey(languageInfo.ID))
            dictionary.Add(languageInfo.ID, languageInfo);
        }
      }
      return dictionary;
    }

    public static List<LanguageInfo> GetAllLanguage()
    {
      if (LanguagesMgr.m_languages.Count == 0)
        LanguagesMgr.Init();
      return LanguagesMgr.m_languages.Values.ToList<LanguageInfo>();
    }

    public static LanguageInfo FindLanguage(int id)
    {
      if (LanguagesMgr.m_languages.Count == 0)
        LanguagesMgr.Init();
      return LanguagesMgr.m_languages.ContainsKey(id) ? LanguagesMgr.m_languages[id] : (LanguageInfo) null;
    }
  }
}
