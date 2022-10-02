// Decompiled with JetBrains decompiler
// Type: Tank.Data.DDTService.CenterServiceClient
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Threading.Tasks;

namespace Tank.Data.DDTService
{
  [DebuggerStepThrough]
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  public class CenterServiceClient : ClientBase<ICenterService>, ICenterService
  {
    public CenterServiceClient()
    {
    }

    public CenterServiceClient(string endpointConfigurationName)
      : base(endpointConfigurationName)
    {
    }

    public CenterServiceClient(string endpointConfigurationName, string remoteAddress)
      : base(endpointConfigurationName, remoteAddress)
    {
    }

    public CenterServiceClient(string endpointConfigurationName, EndpointAddress remoteAddress)
      : base(endpointConfigurationName, remoteAddress)
    {
    }

    public CenterServiceClient(Binding binding, EndpointAddress remoteAddress)
      : base(binding, remoteAddress)
    {
    }

    public ServerData[] GetServerList(int zoneId) => this.Channel.GetServerList(zoneId);

    public Task<ServerData[]> GetServerListAsync(int zoneId) => this.Channel.GetServerListAsync(zoneId);

    public string GetServerListByStr(int zoneID) => this.Channel.GetServerListByStr(zoneID);

    public Task<string> GetServerListByStrAsync(int zoneID) => this.Channel.GetServerListByStrAsync(zoneID);

    public string GetAllChat() => this.Channel.GetAllChat();

    public Task<string> GetAllChatAsync() => this.Channel.GetAllChatAsync();

    public int GetPlayerState(int playerID, int zoneId) => this.Channel.GetPlayerState(playerID, zoneId);

    public Task<int> GetPlayerStateAsync(int playerID, int zoneId) => this.Channel.GetPlayerStateAsync(playerID, zoneId);

    public bool ChargeMoney(int userID, int zoneId, string chargeID) => this.Channel.ChargeMoney(userID, zoneId, chargeID);

    public Task<bool> ChargeMoneyAsync(int userID, int zoneId, string chargeID) => this.Channel.ChargeMoneyAsync(userID, zoneId, chargeID);

    public bool SystemNotice(string msg) => this.Channel.SystemNotice(msg);

    public Task<bool> SystemNoticeAsync(string msg) => this.Channel.SystemNoticeAsync(msg);

    public bool KitoffUser(int playerID, int zoneId, string msg) => this.Channel.KitoffUser(playerID, zoneId, msg);

    public Task<bool> KitoffUserAsync(int playerID, int zoneId, string msg) => this.Channel.KitoffUserAsync(playerID, zoneId, msg);

    public bool ReLoadServerList() => this.Channel.ReLoadServerList();

    public Task<bool> ReLoadServerListAsync() => this.Channel.ReLoadServerListAsync();

    public bool MailNotice(int playerID, int zoneId) => this.Channel.MailNotice(playerID, zoneId);

    public Task<bool> MailNoticeAsync(int playerID, int zoneId) => this.Channel.MailNoticeAsync(playerID, zoneId);

    public bool ActivePlayer(bool isActive) => this.Channel.ActivePlayer(isActive);

    public Task<bool> ActivePlayerAsync(bool isActive) => this.Channel.ActivePlayerAsync(isActive);

    public bool CreatePlayer(int id, string name, string password, int zoneId, bool isFirst) => this.Channel.CreatePlayer(id, name, password, zoneId, isFirst);

    public Task<bool> CreatePlayerAsync(
      int id,
      string name,
      string password,
      int zoneId,
      bool isFirst)
    {
      return this.Channel.CreatePlayerAsync(id, name, password, zoneId, isFirst);
    }

    [EditorBrowsable(EditorBrowsableState.Advanced)]
    ValidateLoginAndGetIDResponse ICenterService.ValidateLoginAndGetID(
      ValidateLoginAndGetIDRequest request)
    {
      return this.Channel.ValidateLoginAndGetID(request);
    }

    public bool ValidateLoginAndGetID(
      string name,
      string password,
      int zoneId,
      ref int userID,
      ref bool isFirst)
    {
      ValidateLoginAndGetIDResponse id = ((ICenterService) this).ValidateLoginAndGetID(new ValidateLoginAndGetIDRequest()
      {
        name = name,
        password = password,
        zoneId = zoneId,
        userID = userID,
        isFirst = isFirst
      });
      userID = id.userID;
      isFirst = id.isFirst;
      return id.ValidateLoginAndGetIDResult;
    }

    public Task<ValidateLoginAndGetIDResponse> ValidateLoginAndGetIDAsync(
      ValidateLoginAndGetIDRequest request)
    {
      return this.Channel.ValidateLoginAndGetIDAsync(request);
    }

    public bool AASUpdateState(bool state) => this.Channel.AASUpdateState(state);

    public Task<bool> AASUpdateStateAsync(bool state) => this.Channel.AASUpdateStateAsync(state);

    public int AASGetState() => this.Channel.AASGetState();

    public Task<int> AASGetStateAsync() => this.Channel.AASGetStateAsync();

    public int ExperienceRateUpdate(int serverId) => this.Channel.ExperienceRateUpdate(serverId);

    public Task<int> ExperienceRateUpdateAsync(int serverId) => this.Channel.ExperienceRateUpdateAsync(serverId);

    public int NoticeServerUpdate(int serverId, int type) => this.Channel.NoticeServerUpdate(serverId, type);

    public Task<int> NoticeServerUpdateAsync(int serverId, int type) => this.Channel.NoticeServerUpdateAsync(serverId, type);

    public bool UpdateConfigState(int type, bool state) => this.Channel.UpdateConfigState(type, state);

    public Task<bool> UpdateConfigStateAsync(int type, bool state) => this.Channel.UpdateConfigStateAsync(type, state);

    public int GetConfigState(int type) => this.Channel.GetConfigState(type);

    public Task<int> GetConfigStateAsync(int type) => this.Channel.GetConfigStateAsync(type);

    public bool Reload(string type) => this.Channel.Reload(type);

    public Task<bool> ReloadAsync(string type) => this.Channel.ReloadAsync(type);

    public bool Shutdown(string type) => this.Channel.Shutdown(type);

    public Task<bool> ShutdownAsync(string type) => this.Channel.ShutdownAsync(type);
  }
}
