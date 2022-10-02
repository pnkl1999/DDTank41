// Decompiled with JetBrains decompiler
// Type: Tank.Data.ButtonConfigMgr
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
  public class ButtonConfigMgr
  {
    private static Dictionary<int, ButtonConfigInfo> m_buttonConfigs = new Dictionary<int, ButtonConfigInfo>();

    public static bool Init() => ButtonConfigMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ButtonConfigInfo> dictionary = ButtonConfigMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ButtonConfigInfo>>(ref ButtonConfigMgr.m_buttonConfigs, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("ButtonConfigMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ButtonConfigInfo> LoadFromDatabase()
    {
      Dictionary<int, ButtonConfigInfo> dictionary = new Dictionary<int, ButtonConfigInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ButtonConfigInfo buttonConfigInfo in produceBussiness.GetAllButtonConfig())
        {
          if (!dictionary.ContainsKey(buttonConfigInfo.ID))
            dictionary.Add(buttonConfigInfo.ID, buttonConfigInfo);
        }
      }
      return dictionary;
    }

    public static List<ButtonConfigInfo> GetAllButtonConfig()
    {
      if (ButtonConfigMgr.m_buttonConfigs.Count == 0)
        ButtonConfigMgr.Init();
      return ButtonConfigMgr.m_buttonConfigs.Values.ToList<ButtonConfigInfo>();
    }

    public static ButtonConfigInfo FindButtonConfig(int id)
    {
      if (ButtonConfigMgr.m_buttonConfigs.Count == 0)
        ButtonConfigMgr.Init();
      return ButtonConfigMgr.m_buttonConfigs.ContainsKey(id) ? ButtonConfigMgr.m_buttonConfigs[id] : (ButtonConfigInfo) null;
    }
  }
}
