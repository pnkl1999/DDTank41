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
using Road.Flash;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class MarryInfoPageList : IHttpHandler
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
                int page = int.Parse(context.Request["page"]);
                string name = null;
                if (context.Request["name"] != null)
                {
                    name = csFunction.ConvertSql(HttpUtility.UrlDecode(context.Request["name"]));
                }

                bool sex = bool.Parse(context.Request["sex"]);
                int size = 12;//int.Parse(context.Request["size"]);

                using (PlayerBussiness db = new PlayerBussiness())
                {
                    MarryInfo[] infos = db.GetMarryInfoPage(page, name, sex, size, ref total);
                    foreach (MarryInfo info in infos)
                    {
                        XElement temp = FlashUtils.CreateMarryInfo(info);
                        result.Add(temp);
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("MarryInfoPageList", ex);
            }

            result.Add(new XAttribute("total", total));
            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            context.Response.ContentType = "text/plain";
            context.Response.Write(result.ToString(false));
            //context.Response.BinaryWrite(StaticFunction.Compress(result.ToString()));
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
