using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Xml.Linq;
using Road;
using System.Security.Cryptography;
using System.Configuration;
using System.Text;
using Road.Flash;
using System.Web.SessionState;
using Bussiness;
using SqlDataProvider.Data;
using log4net;
using System.Reflection;
using Bussiness.Interface;
using System.IO;
using System.IO.Compression;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class CheckRegistration : IHttpHandler, IRequiresSessionState
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool value = true;
            string message = "Registered!";// "Login Fail!";
            XElement result = new XElement("Result");
            var status = 1;

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            result.Add(new XAttribute("status",status));
            // result.Add(new XAttribute("style", style));

            context.Response.ContentType = "text/plain";
            context.Response.BinaryWrite(StaticFunction.Compress(result.ToString()));
        }
        public static byte[] Compress(byte[] data)
        {
            MemoryStream ms = new MemoryStream();
            zlib.ZOutputStream ds = new zlib.ZOutputStream(ms,3);
            
            ds.Write(data, 0, data.Length);
            ds.Flush();
            ds.Close();
            return ms.ToArray();
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
