using Bussiness;
using log4net;
using System;
using System.Reflection;
using System.Web;
using System.Xml.Linq;

namespace Tank.Request
{
    public class FarmGetUserFieldInfosSingle : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool flag = false;
            string str1 = "fail!";
            XElement node = new XElement((XName)"Result");
            string str2 = context.Request["friendID"];
            try
            {
                XElement xelement = new XElement((XName)"Item", new object[2]
                {
          (object) new XAttribute((XName) "UserID", (object) str2),
          (object) new XAttribute((XName) "isFeed", (object) false)
                });
                node.Add((object)xelement);
                flag = true;
                str1 = "Success!";
            }
            catch (Exception ex)
            {
                FarmGetUserFieldInfosSingle.log.Error((object)"FarmGetUserFieldInfosSingle", ex);
            }
            node.Add((object)new XAttribute((XName)"value", (object)flag));
            node.Add((object)new XAttribute((XName)"message", (object)str1));
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
