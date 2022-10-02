using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using Bussiness;
using SqlDataProvider.Data;
using Road.Flash;
using log4net;
using System.Reflection;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ConsortiaLevelList : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write(Bulid(context));
        }

        public static string Bulid(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");

            try
            {
                using (ConsortiaBussiness db = new ConsortiaBussiness())
                {
                    ConsortiaLevelInfo[] infos = db.GetAllConsortiaLevel();
                    foreach (ConsortiaLevelInfo info in infos)
                    {
                        result.Add(Road.Flash.FlashUtils.CreateConsortiLevelInfo(info));
                    }
                }

                value = true;
                message = "Success!";
            }
            catch (Exception ex)
            {
                log.Error("ConsortiaLevelList", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            return csFunction.CreateCompressXml(context, result, "ConsortiaLevelList", true);
            //return result.ToString(false);
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
