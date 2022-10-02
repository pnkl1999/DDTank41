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
    public class MapWeekList : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool flag = false;
            string str = "获取失败!";
            XElement node = new XElement("Result");
            try
            {
                using (new MapBussiness())
                {
                    flag = true;
                    str = "获取成功!";
                }
            }
            catch (Exception exception)
            {
                log.Error("加载地图周期失败", exception);
            }
            node.Add(new XAttribute("value", flag));
            node.Add(new XAttribute("message", str));
            context.Response.ContentType = "text/plain";
            context.Response.Write(node.ToString(false));
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
