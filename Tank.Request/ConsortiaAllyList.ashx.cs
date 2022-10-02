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
using System.Collections.Generic;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ConsortiaAllyList : IHttpHandler
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
                int state = int.Parse(context.Request["state"]);
                string name = csFunction.ConvertSql(HttpUtility.UrlDecode(context.Request["name"] == null ? "" : context.Request["name"]));

                //List<int> list = new List<int>();
                //if (state == 0 || state == 2)
                //{
                //    using (ConsortiaBussiness db = new ConsortiaBussiness())
                //    {
                //        list.AddRange(db.GetConsortiaByAllyByState(consortiaID, state == 0 ? 1 : 0));

                //    }
                //}
                using (ConsortiaBussiness db = new ConsortiaBussiness())
                {
                    ConsortiaAllyInfo[] infos = db.GetConsortiaAllyPage(page, size, ref total, order, consortiaID, state,name);
                    foreach (ConsortiaAllyInfo info in infos)
                    {
                        //if (list.Contains(info.Consortia1ID))
                        //{
                        //    info.IsApply = true;
                        //}
                        result.Add(FlashUtils.CreateConsortiaAllyInfo(info));
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("ConsortiaAllyList", ex);
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
