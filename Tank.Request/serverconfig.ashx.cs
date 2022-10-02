using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;
using System;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;

namespace Tank.Request
{
    [WebService(Namespace = "http://tempuri.org/"), WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class serverconfig : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public static string Bulid(HttpContext context)
        {
            bool flag = false;
            string str = "Fail!";
            XElement result = new XElement("Result");
            try
            {
                using (ServiceBussiness bussiness = new ServiceBussiness())
                {
                    ServerProperty[] allproperties = bussiness.GetAllServerProperty();
                    foreach (ServerProperty info in allproperties)
                    {
                        result.Add(FlashUtils.CreateServerConfig(info));
                    }
                }
                flag = true;
                str = "Success!";
            }
            catch (Exception exception)
            {
                log.Error("ServerConfig", exception);
            }
            result.Add(new XAttribute("value", flag));
            result.Add(new XAttribute("message", str));
            return csFunction.CreateCompressXml(context, result, "ServerConfig", false);
        }
        public void ProcessRequest(HttpContext context)
        {
            if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
            {
                context.Response.Write(Bulid(context));
            }
            else
            {
                context.Response.Write("IP is not valid!");
            }
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