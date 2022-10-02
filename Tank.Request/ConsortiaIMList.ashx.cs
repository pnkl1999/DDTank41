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
    public class ConsortiaIMList : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        public void ProcessRequest(HttpContext context)
        {

            bool value = false;
            string message = "Fail!";
            int total = 0;

            XElement result = new XElement("Result");

            try
            {
                int id = int.Parse(context.Request["id"]);

                using (ConsortiaBussiness db = new ConsortiaBussiness())
                {
                    ConsortiaInfo info = db.GetConsortiaSingle(id);
                    if (info != null)
                    {
                        result.Add(new XAttribute("Level", info.Level));
                        result.Add(new XAttribute("Repute", info.Repute));
                    }
                }

                using (ConsortiaBussiness db = new ConsortiaBussiness())
                {
                    ConsortiaUserInfo[] infos = db.GetConsortiaUsersPage(1, 1000, ref total, -1, id, -1,-1);
                    foreach (ConsortiaUserInfo info in infos)
                    {
                        result.Add(FlashUtils.CreateConsortiaIMInfo(info));
                    }

                    value = true;
                    message = "Success!";
                }

            }
            catch (Exception ex)
            {
                log.Error("ConsortiaIMList", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
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
