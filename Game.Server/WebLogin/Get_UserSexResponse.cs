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
	public class Get_UserSexResponse
    {
        [MessageBodyMember(Name = "Get_UserSexResponse", Namespace = "dandantang", Order = 0)]
		public Get_UserSexResponseBody Body;

        public Get_UserSexResponse()
        {
        }

        public Get_UserSexResponse(Get_UserSexResponseBody Body)
        {
			this.Body = Body;
        }
    }
}
