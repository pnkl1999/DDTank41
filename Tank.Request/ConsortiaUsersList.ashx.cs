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
    public class ConsortiaUsersList : IHttpHandler
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
                int userID = int.Parse(context.Request["userID"]);
                int state = int.Parse(context.Request["state"]);

                using (ConsortiaBussiness db = new ConsortiaBussiness())
                {
                    ConsortiaUserInfo[] infos = db.GetConsortiaUsersPage(page, size, ref total, order, consortiaID, userID,state);
                    foreach (ConsortiaUserInfo info in infos)
                    {
                        result.Add(FlashUtils.CreateConsortiaUserInfo(info));
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("ConsortiaUsersList", ex);
            }

            result.Add(new XAttribute("total", total));
            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            result.Add(new XAttribute("currentDate",DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")));

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
