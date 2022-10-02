// Decompiled with JetBrains decompiler
// Type: Tank.Data.DDTService.ICenterService
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using System.CodeDom.Compiler;
using System.ServiceModel;
using System.Threading.Tasks;

namespace Tank.Data.DDTService
{
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  [ServiceContract(ConfigurationName = "DDTService.ICenterService")]
  public interface ICenterService
  {
    [OperationContract(Action = "http://tempuri.org/ICenterService/GetServerList", ReplyAction = "http://tempuri.org/ICenterService/GetServerListResponse")]
    ServerData[] GetServerList(int zoneId);

    [OperationContract(Action = "http://tempuri.org/ICenterService/GetServerList", ReplyAction = "http://tempuri.org/ICenterService/GetServerListResponse")]
    Task<ServerData[]> GetServerListAsync(int zoneId);

    [OperationContract(Action = "http://tempuri.org/ICenterService/GetServerListByStr", ReplyAction = "http://tempuri.org/ICenterService/GetServerListByStrResponse")]
    string GetServerListByStr(int zoneID);

    [OperationContract(Action = "http://tempuri.org/ICenterService/GetServerListByStr", ReplyAction = "http://tempuri.org/ICenterService/GetServerListByStrResponse")]
    Task<string> GetServerListByStrAsync(int zoneID);

    [OperationContract(Action = "http://tempuri.org/ICenterService/GetAllChat", ReplyAction = "http://tempuri.org/ICenterService/GetAllChatResponse")]
    string GetAllChat();

    [OperationContract(Action = "http://tempuri.org/ICenterService/GetAllChat", ReplyAction = "http://tempuri.org/ICenterService/GetAllChatResponse")]
    Task<string> GetAllChatAsync();

    [OperationContract(Action = "http://tempuri.org/ICenterService/GetPlayerState", ReplyAction = "http://tempuri.org/ICenterService/GetPlayerStateResponse")]
    int GetPlayerState(int playerID, int zoneId);

    [OperationContract(Action = "http://tempuri.org/ICenterService/GetPlayerState", ReplyAction = "http://tempuri.org/ICenterService/GetPlayerStateResponse")]
    Task<int> GetPlayerStateAsync(int playerID, int zoneId);

    [OperationContract(Action = "http://tempuri.org/ICenterService/ChargeMoney", ReplyAction = "http://tempuri.org/ICenterService/ChargeMoneyResponse")]
    bool ChargeMoney(int userID, int zoneId, string chargeID);

    [OperationContract(Action = "http://tempuri.org/ICenterService/ChargeMoney", ReplyAction = "http://tempuri.org/ICenterService/ChargeMoneyResponse")]
    Task<bool> ChargeMoneyAsync(int userID, int zoneId, string chargeID);

    [OperationContract(Action = "http://tempuri.org/ICenterService/SystemNotice", ReplyAction = "http://tempuri.org/ICenterService/SystemNoticeResponse")]
    bool SystemNotice(string msg);

    [OperationContract(Action = "http://tempuri.org/ICenterService/SystemNotice", ReplyAction = "http://tempuri.org/ICenterService/SystemNoticeResponse")]
    Task<bool> SystemNoticeAsync(string msg);

    [OperationContract(Action = "http://tempuri.org/ICenterService/KitoffUser", ReplyAction = "http://tempuri.org/ICenterService/KitoffUserResponse")]
    bool KitoffUser(int playerID, int zoneId, string msg);

    [OperationContract(Action = "http://tempuri.org/ICenterService/KitoffUser", ReplyAction = "http://tempuri.org/ICenterService/KitoffUserResponse")]
    Task<bool> KitoffUserAsync(int playerID, int zoneId, string msg);

    [OperationContract(Action = "http://tempuri.org/ICenterService/ReLoadServerList", ReplyAction = "http://tempuri.org/ICenterService/ReLoadServerListResponse")]
    bool ReLoadServerList();

    [OperationContract(Action = "http://tempuri.org/ICenterService/ReLoadServerList", ReplyAction = "http://tempuri.org/ICenterService/ReLoadServerListResponse")]
    Task<bool> ReLoadServerListAsync();

    [OperationContract(Action = "http://tempuri.org/ICenterService/MailNotice", ReplyAction = "http://tempuri.org/ICenterService/MailNoticeResponse")]
    bool MailNotice(int playerID, int zoneId);

    [OperationContract(Action = "http://tempuri.org/ICenterService/MailNotice", ReplyAction = "http://tempuri.org/ICenterService/MailNoticeResponse")]
    Task<bool> MailNoticeAsync(int playerID, int zoneId);

    [OperationContract(Action = "http://tempuri.org/ICenterService/ActivePlayer", ReplyAction = "http://tempuri.org/ICenterService/ActivePlayerResponse")]
    bool ActivePlayer(bool isActive);

    [OperationContract(Action = "http://tempuri.org/ICenterService/ActivePlayer", ReplyAction = "http://tempuri.org/ICenterService/ActivePlayerResponse")]
    Task<bool> ActivePlayerAsync(bool isActive);

    [OperationContract(Action = "http://tempuri.org/ICenterService/CreatePlayer", ReplyAction = "http://tempuri.org/ICenterService/CreatePlayerResponse")]
    bool CreatePlayer(int id, string name, string password, int zoneId, bool isFirst);

    [OperationContract(Action = "http://tempuri.org/ICenterService/CreatePlayer", ReplyAction = "http://tempuri.org/ICenterService/CreatePlayerResponse")]
    Task<bool> CreatePlayerAsync(
      int id,
      string name,
      string password,
      int zoneId,
      bool isFirst);

    [OperationContract(Action = "http://tempuri.org/ICenterService/ValidateLoginAndGetID", ReplyAction = "http://tempuri.org/ICenterService/ValidateLoginAndGetIDResponse")]
    ValidateLoginAndGetIDResponse ValidateLoginAndGetID(
      ValidateLoginAndGetIDRequest request);

    [OperationContract(Action = "http://tempuri.org/ICenterService/ValidateLoginAndGetID", ReplyAction = "http://tempuri.org/ICenterService/ValidateLoginAndGetIDResponse")]
    Task<ValidateLoginAndGetIDResponse> ValidateLoginAndGetIDAsync(
      ValidateLoginAndGetIDRequest request);

    [OperationContract(Action = "http://tempuri.org/ICenterService/AASUpdateState", ReplyAction = "http://tempuri.org/ICenterService/AASUpdateStateResponse")]
    bool AASUpdateState(bool state);

    [OperationContract(Action = "http://tempuri.org/ICenterService/AASUpdateState", ReplyAction = "http://tempuri.org/ICenterService/AASUpdateStateResponse")]
    Task<bool> AASUpdateStateAsync(bool state);

    [OperationContract(Action = "http://tempuri.org/ICenterService/AASGetState", ReplyAction = "http://tempuri.org/ICenterService/AASGetStateResponse")]
    int AASGetState();

    [OperationContract(Action = "http://tempuri.org/ICenterService/AASGetState", ReplyAction = "http://tempuri.org/ICenterService/AASGetStateResponse")]
    Task<int> AASGetStateAsync();

    [OperationContract(Action = "http://tempuri.org/ICenterService/ExperienceRateUpdate", ReplyAction = "http://tempuri.org/ICenterService/ExperienceRateUpdateResponse")]
    int ExperienceRateUpdate(int serverId);

    [OperationContract(Action = "http://tempuri.org/ICenterService/ExperienceRateUpdate", ReplyAction = "http://tempuri.org/ICenterService/ExperienceRateUpdateResponse")]
    Task<int> ExperienceRateUpdateAsync(int serverId);

    [OperationContract(Action = "http://tempuri.org/ICenterService/NoticeServerUpdate", ReplyAction = "http://tempuri.org/ICenterService/NoticeServerUpdateResponse")]
    int NoticeServerUpdate(int serverId, int type);

    [OperationContract(Action = "http://tempuri.org/ICenterService/NoticeServerUpdate", ReplyAction = "http://tempuri.org/ICenterService/NoticeServerUpdateResponse")]
    Task<int> NoticeServerUpdateAsync(int serverId, int type);

    [OperationContract(Action = "http://tempuri.org/ICenterService/UpdateConfigState", ReplyAction = "http://tempuri.org/ICenterService/UpdateConfigStateResponse")]
    bool UpdateConfigState(int type, bool state);

    [OperationContract(Action = "http://tempuri.org/ICenterService/UpdateConfigState", ReplyAction = "http://tempuri.org/ICenterService/UpdateConfigStateResponse")]
    Task<bool> UpdateConfigStateAsync(int type, bool state);

    [OperationContract(Action = "http://tempuri.org/ICenterService/GetConfigState", ReplyAction = "http://tempuri.org/ICenterService/GetConfigStateResponse")]
    int GetConfigState(int type);

    [OperationContract(Action = "http://tempuri.org/ICenterService/GetConfigState", ReplyAction = "http://tempuri.org/ICenterService/GetConfigStateResponse")]
    Task<int> GetConfigStateAsync(int type);

    [OperationContract(Action = "http://tempuri.org/ICenterService/Reload", ReplyAction = "http://tempuri.org/ICenterService/ReloadResponse")]
    bool Reload(string type);

    [OperationContract(Action = "http://tempuri.org/ICenterService/Reload", ReplyAction = "http://tempuri.org/ICenterService/ReloadResponse")]
    Task<bool> ReloadAsync(string type);

    [OperationContract(Action = "http://tempuri.org/ICenterService/Shutdown", ReplyAction = "http://tempuri.org/ICenterService/ShutdownResponse")]
    bool Shutdown(string type);

    [OperationContract(Action = "http://tempuri.org/ICenterService/Shutdown", ReplyAction = "http://tempuri.org/ICenterService/ShutdownResponse")]
    Task<bool> ShutdownAsync(string type);
  }
}
