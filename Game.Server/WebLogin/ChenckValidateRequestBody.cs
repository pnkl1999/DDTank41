using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.Serialization;

namespace Game.Server.WebLogin
{
    [DebuggerStepThrough]
	[GeneratedCode("System.ServiceModel", "4.0.0.0")]
	[EditorBrowsable(EditorBrowsableState.Advanced)]
	[DataContract(Namespace = "dandantang")]
	public class ChenckValidateRequestBody
    {
        [DataMember(EmitDefaultValue = false, Order = 0)]
		public string applicationname;

        [DataMember(EmitDefaultValue = false, Order = 1)]
		public string username;

        [DataMember(EmitDefaultValue = false, Order = 2)]
		public string password;

        public ChenckValidateRequestBody()
        {
        }

        public ChenckValidateRequestBody(string applicationname, string username, string password)
        {
			this.applicationname = applicationname;
			this.username = username;
			this.password = password;
        }
    }
}
