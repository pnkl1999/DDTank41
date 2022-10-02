using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Collections.Specialized;
using log4net;
using System.Reflection;
using Bussiness;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class VisualizeItemLoad : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";
            bool sex = bool.Parse(context.Request["sex"]);

            XElement result = new XElement("Result");
            try
            {
                string content = System.Configuration.ConfigurationSettings.AppSettings[sex ? "BoyVisualizeItem" : "GrilVisualizeItem"];
                result.Add(new XAttribute("content", content));
                value = true;
                message = "Success!";
            }
            catch(Exception ex) 
            {
                log.Error("VisualizeItemLoad", ex);
            }

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
