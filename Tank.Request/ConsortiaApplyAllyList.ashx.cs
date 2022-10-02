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
    public class ConsortiaApplyAllyList : IHttpHandler
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
                int applyID = int.Parse(context.Request["applyID"]);
                int state = int.Parse(context.Request["state"]);

                using (ConsortiaBussiness db = new ConsortiaBussiness())
                {
                    ConsortiaApplyAllyInfo[] infos = db.GetConsortiaApplyAllyPage(page, size, ref total, order, consortiaID, applyID, state);
                    foreach (ConsortiaApplyAllyInfo info in infos)
                    {
                        result.Add(FlashUtils.CreateConsortiaApplyAllyInfo(info));
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("ConsortiaApplyAllyList", ex);
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
