using System.CodeDom.Compiler;
using System.ServiceModel;

namespace Bussiness.WebLogin
{
    [GeneratedCode("System.ServiceModel", "4.0.0.0")]
	[ServiceContract(Namespace = "dandantang", ConfigurationName = "WebLogin.PassPortSoap")]
	public interface PassPortSoap
    {
        [OperationContract(Action = "dandantang/ChenckValidate", ReplyAction = "*")]
		ChenckValidateResponse ChenckValidate(ChenckValidateRequest request);

        [OperationContract(Action = "dandantang/Get_UserSex", ReplyAction = "*")]
		Get_UserSexResponse Get_UserSex(Get_UserSexRequest request);
    }
}
