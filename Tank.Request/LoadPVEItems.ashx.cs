using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using log4net;
using System.Reflection;
using Bussiness;
using SqlDataProvider.Data;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class LoadPVEItems : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
            {
                context.Response.Write(Build(context));
            }
            else
            {
                context.Response.Write("IP is not valid!");
            }
        }

        public static string Build(HttpContext context)
        {
            bool value = false;
            string message = "Fail";

            XElement result = new XElement("Result");

            try
            {
                using (PveBussiness db = new PveBussiness())
                {
                    PveInfo[] infos = db.GetAllPveInfos();
                    foreach (var info in infos)
                    {
                        result.Add(Road.Flash.FlashUtils.CreatePveInfo(info));
                    }
                }

                value = true;
                message = "Success!";
            }
            catch (Exception ex)
            {
                log.Error("LoadPVEItems", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            return csFunction.CreateCompressXml(context, result, "LoadPVEItems", true);
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
