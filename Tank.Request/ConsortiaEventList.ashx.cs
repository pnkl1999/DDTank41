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
    public class ConsortiaEventList : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");
            int total = 0;

            try
            {
                int page = int.Parse(context.Request["page"]);
                int size = int.Parse(context.Request["size"]);
                int order = int.Parse(context.Request["order"]);
                int consortiaID = int.Parse(context.Request["consortiaID"]);

                using (ConsortiaBussiness db = new ConsortiaBussiness())
                {
                    ConsortiaEventInfo[] infos = db.GetConsortiaEventPage(page, size, ref total, order, consortiaID);
                    foreach (ConsortiaEventInfo info in infos)
                    {
                        result.Add(FlashUtils.CreateConsortiaEventInfo(info));
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("ConsortiaEventList", ex);
            }

            result.Add(new XAttribute("total", total));
            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            context.Response.ContentType = "text/plain";
            context.Response.Write(result.ToString(false));
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
