using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Collections.Specialized;
using System.Collections.Generic;
using SqlDataProvider.Data;
using Bussiness;
using Road.Flash;
using System.IO;
using log4net;
using System.Reflection;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for activitysystemitems
    /// </summary>
    public class activitysystemitems : IHttpHandler
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
            string message = "Fail!";
            XElement result = new XElement("Result");
            try
            {
                using (ProduceBussiness db = new ProduceBussiness())
                {
                    ActivitySystemItemInfo[] infos = db.GetAllActivitySystemItem();
                    foreach (ActivitySystemItemInfo info in infos)
                    {
                        result.Add(FlashUtils.CreateActivitySystemItems(info));
                    }
                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("activitysystemitems", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            csFunction.CreateCompressXml(context, result, "activitysystemitems_out", false);
            return csFunction.CreateCompressXml(context, result, "activitysystemitems", true);
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