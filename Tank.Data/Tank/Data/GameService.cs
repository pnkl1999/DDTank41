// Decompiled with JetBrains decompiler
// Type: Tank.Data.GameService
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using Helpers;
using SqlDataProvider.Data;
using System.Collections.Generic;
using Tank.Data.DDTService;

namespace Tank.Data
{
  public class GameService
  {
    public static string GetAllChat()
    {
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
          return centerServiceClient.GetAllChat();
      }
      catch
      {
        return string.Empty;
      }
    }

    public static bool ReLoadServerList()
    {
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
          return centerServiceClient.ReLoadServerList();
      }
      catch
      {
        return false;
      }
    }

    public static bool MailNotice(int playerID, int zoneId)
    {
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
          return centerServiceClient.MailNotice(playerID, zoneId);
      }
      catch
      {
        return false;
      }
    }

    public static bool KickPlayer(int playerID, int zoneId, string msg)
    {
        try
        {
            string configurationName = string.Format("NetTcpBinding_ICenterService_{0}", zoneId);

            using (CenterServiceClient centerServiceClient = new CenterServiceClient(configurationName))
                return centerServiceClient.KitoffUser(playerID, zoneId, msg);
        }
      catch
      {
        return false;
      }
    }

    public static bool SystemNotice(string notice, string type)
    {
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
          return centerServiceClient.SystemNotice(string.Format("{0}|{1}|{2}", (object) notice, (object) type, (object) StringHelper.Md5(notice + AppSettings.LoginKey)));
      }
      catch
      {
        return false;
      }
    }

    public static bool Reload(string command)
    {
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
          return centerServiceClient.Reload(string.Format("{0}|{1}", (object) command, (object) StringHelper.Md5(command + AppSettings.LoginKey)));
      }
      catch
      {
        return false;
      }
    }

    public static bool Shutdown(string zoneId)
    {
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
          return centerServiceClient.Shutdown(string.Format("{0}|{1}", (object) zoneId, (object) StringHelper.Md5(zoneId + AppSettings.LoginKey)));
      }
      catch
      {
        return false;
      }
    }

    public static List<ServerInfo> ServerList(int zoneId)
    {
      List<ServerInfo> serverInfoList = new List<ServerInfo>();
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
        {
          foreach (ServerData server in (IEnumerable<ServerData>) centerServiceClient.GetServerList(zoneId))
            serverInfoList.Add(new ServerInfo()
            {
              ID = server.Id,
              Name = server.Name,
              IP = server.Ip,
              Port = server.Port,
              State = server.State,
              MustLevel = server.MustLevel,
              LowestLevel = server.LowestLevel,
              Online = server.Online,
              Total = server.Total,
              ZoneId = zoneId
            });
        }
      }
      catch
      {
      }
      return serverInfoList;
    }
  }
}
