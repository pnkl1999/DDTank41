using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.ServiceModel;
using System.ServiceModel.Channels;

namespace Game.Server.WebLogin
{
    [DebuggerStepThrough]
	[GeneratedCode("System.ServiceModel", "4.0.0.0")]
	public class PassPortSoapClient : ClientBase<PassPortSoap>, PassPortSoap
    {
        public PassPortSoapClient()
        {
        }

        public PassPortSoapClient(string endpointConfigurationName)
			: base(endpointConfigurationName)
        {
        }

        public PassPortSoapClient(string endpointConfigurationName, string remoteAddress)
			: base(endpointConfigurationName, remoteAddress)
        {
        }

        public PassPortSoapClient(string endpointConfigurationName, EndpointAddress remoteAddress)
			: base(endpointConfigurationName, remoteAddress)
        {
        }

        public PassPortSoapClient(Binding binding, EndpointAddress remoteAddress)
			: base(binding, remoteAddress)
        {
        }

        [EditorBrowsable(EditorBrowsableState.Advanced)]
		ChenckValidateResponse PassPortSoap.ChenckValidate(ChenckValidateRequest request)
        {
			return base.Channel.ChenckValidate(request);
        }

        public string ChenckValidate(string applicationname, string username, string password)
        {
			ChenckValidateRequest chenckValidateRequest = new ChenckValidateRequest();
			chenckValidateRequest.Body = new ChenckValidateRequestBody();
			chenckValidateRequest.Body.applicationname = applicationname;
			chenckValidateRequest.Body.username = username;
			chenckValidateRequest.Body.password = password;
			return ((PassPortSoap)this).ChenckValidate(chenckValidateRequest).Body.ChenckValidateResult;
        }

        [EditorBrowsable(EditorBrowsableState.Advanced)]
		Get_UserSexResponse PassPortSoap.Get_UserSex(Get_UserSexRequest request)
        {
			return base.Channel.Get_UserSex(request);
        }

        public bool? Get_UserSex(string applicationname, string username)
        {
			Get_UserSexRequest get_UserSexRequest = new Get_UserSexRequest();
			get_UserSexRequest.Body = new Get_UserSexRequestBody();
			get_UserSexRequest.Body.applicationname = applicationname;
			get_UserSexRequest.Body.username = username;
			return ((PassPortSoap)this).Get_UserSex(get_UserSexRequest).Body.Get_UserSexResult;
        }
    }
}
