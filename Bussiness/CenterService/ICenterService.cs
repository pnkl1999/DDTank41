using System.CodeDom.Compiler;
using System.ServiceModel;

namespace Bussiness.CenterService
{
    [GeneratedCode("System.ServiceModel", "4.0.0.0")]
	[ServiceContract(ConfigurationName = "CenterService.ICenterService")]
	public interface ICenterService
    {
        [OperationContract(Action = "http://tempuri.org/ICenterService/GetServerList", ReplyAction = "http://tempuri.org/ICenterService/GetServerListResponse")]
		ServerData[] GetServerList();

        [OperationContract(Action = "http://tempuri.org/ICenterService/ChargeMoney", ReplyAction = "http://tempuri.org/ICenterService/ChargeMoneyResponse")]
		bool ChargeMoney(int userID, string chargeID);

        [OperationContract(Action = "http://tempuri.org/ICenterService/SystemNotice", ReplyAction = "http://tempuri.org/ICenterService/SystemNoticeResponse")]
		bool SystemNotice(string msg);

        [OperationContract(Action = "http://tempuri.org/ICenterService/KitoffUser", ReplyAction = "http://tempuri.org/ICenterService/KitoffUserResponse")]
		bool KitoffUser(int playerID, string msg);

        [OperationContract(Action = "http://tempuri.org/ICenterService/ReLoadServerList", ReplyAction = "http://tempuri.org/ICenterService/ReLoadServerListResponse")]
		bool ReLoadServerList();

        [OperationContract(Action = "http://tempuri.org/ICenterService/MailNotice", ReplyAction = "http://tempuri.org/ICenterService/MailNoticeResponse")]
		bool MailNotice(int playerID);

        [OperationContract(Action = "http://tempuri.org/ICenterService/ActivePlayer", ReplyAction = "http://tempuri.org/ICenterService/ActivePlayerResponse")]
		bool ActivePlayer(bool isActive);

        [OperationContract(Action = "http://tempuri.org/ICenterService/CreatePlayer", ReplyAction = "http://tempuri.org/ICenterService/CreatePlayerResponse")]
		bool CreatePlayer(int id, string name, string password, bool isFirst);

        [OperationContract(Action = "http://tempuri.org/ICenterService/ValidateLoginAndGetID", ReplyAction = "http://tempuri.org/ICenterService/ValidateLoginAndGetIDResponse")]
		bool ValidateLoginAndGetID(string name, string password, int zoneId, ref int userID, ref bool isFirst);

        [OperationContract(Action = "http://tempuri.org/ICenterService/AASUpdateState", ReplyAction = "http://tempuri.org/ICenterService/AASUpdateStateResponse")]
		bool AASUpdateState(bool state);

        [OperationContract(Action = "http://tempuri.org/ICenterService/AASGetState", ReplyAction = "http://tempuri.org/ICenterService/AASGetStateResponse")]
		int AASGetState();

        [OperationContract(Action = "http://tempuri.org/ICenterService/ExperienceRateUpdate", ReplyAction = "http://tempuri.org/ICenterService/ExperienceRateUpdateResponse")]
		int ExperienceRateUpdate(int serverId);

        [OperationContract(Action = "http://tempuri.org/ICenterService/NoticeServerUpdate", ReplyAction = "http://tempuri.org/ICenterService/NoticeServerUpdateResponse")]
		int NoticeServerUpdate(int serverId, int type);

        [OperationContract(Action = "http://tempuri.org/ICenterService/UpdateConfigState", ReplyAction = "http://tempuri.org/ICenterService/UpdateConfigStateResponse")]
		bool UpdateConfigState(int type, bool state);

        [OperationContract(Action = "http://tempuri.org/ICenterService/GetConfigState", ReplyAction = "http://tempuri.org/ICenterService/GetConfigStateResponse")]
		int GetConfigState(int type);

        [OperationContract(Action = "http://tempuri.org/ICenterService/Reload", ReplyAction = "http://tempuri.org/ICenterService/ReloadResponse")]
		bool Reload(string type);
    }
}
