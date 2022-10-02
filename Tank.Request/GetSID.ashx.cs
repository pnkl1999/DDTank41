using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Web.SessionState;
using System.Security.Cryptography;
using System.Configuration;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    public class GetSID : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            CspParameters csp = new CspParameters();
            //csp.KeyContainerName = "MyKey";
            csp.Flags = CspProviderFlags.UseMachineKeyStore;

            RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(2048);//csp);
            rsa.FromXmlString(ConfigurationSettings.AppSettings["privateKey"]);
            RSAParameters para = rsa.ExportParameters(false);
            XElement node = new XElement("result", new XAttribute("m1", Convert.ToBase64String(para.Modulus)), new XAttribute("m2", Convert.ToBase64String(para.Exponent)));
            context.Response.ContentType = "text/plain";
            context.Response.Write(node.ToString());
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
