using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.ServiceModel;

namespace Game.Server.WebLogin
{
    [DebuggerStepThrough]
	[GeneratedCode("System.ServiceModel", "4.0.0.0")]
	[EditorBrowsable(EditorBrowsableState.Advanced)]
	[MessageContract(IsWrapped = false)]
	public class ChenckValidateRequest
    {
        [MessageBodyMember(Name = "ChenckValidate", Namespace = "dandantang", Order = 0)]
		public ChenckValidateRequestBody Body;

        public ChenckValidateRequest()
        {
        }

        public ChenckValidateRequest(ChenckValidateRequestBody Body)
        {
			this.Body = Body;
        }
    }
}
