using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Security.Cryptography;
using System.Text;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class KeyGenerator : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            CspParameters csp = new CspParameters();
            csp.Flags = CspProviderFlags.UseMachineKeyStore;

            RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(2048);
            RSAParameters para = rsa.ExportParameters(true);
            StringBuilder model = new StringBuilder();
            for (int i = 0; i < para.Modulus.Length; i++)
            {
                model.Append(para.Modulus[i].ToString("X2"));
            }

            StringBuilder exponent = new StringBuilder();
            for (int i = 0; i <para.Exponent.Length; i ++)
            {
                exponent.Append(para.Exponent[i].ToString("X2"));
            }

            XElement list = new XElement("list");
            XElement pri = new XElement("private", new XAttribute("key", rsa.ToXmlString(true)));
            XElement pub = new XElement("public", new XAttribute("model", model.ToString()),new XAttribute("exponent",exponent.ToString()));
            list.Add(pri);
            list.Add(pub);
            context.Response.Write(list.ToString());
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
