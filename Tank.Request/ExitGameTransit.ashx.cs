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

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ExitGameTransit : IHttpHandler
    {

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        //private string siteEffective = SiteEffective;

        private string site = "";

        public string LoginURL
        {
            get
            {
                string login = "ExitURL_" + site;

                return System.Configuration.ConfigurationSettings.AppSettings[login];

            }
        }

        //public static string SiteEffective
        //{
        //    get
        //    {

        //        return System.Configuration.ConfigurationSettings.AppSettings["SiteEffective"];
        //    }
        //}
    



        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
           
            string username = "";
            string url = string.Empty;


            try
            {
                if (!string.IsNullOrEmpty(context.Request["username"]))
                {

                    username =  HttpUtility.UrlDecode(context.Request["username"]).Trim();

                }

                site = context.Request["site"] == null ? "" : HttpUtility.UrlDecode(context.Request["site"]).ToLower();

                
                if (!string.IsNullOrEmpty(site))
                {                  
                    url = LoginURL;
                    int place = username.IndexOf('_');
                    if (place != -1)
                    {
                        username = username.Substring(place + 1, username.Length - place- 1) ;
                    }
                }

                if (string.IsNullOrEmpty(url))
                {
                    url = System.Configuration.ConfigurationSettings.AppSettings["ExitURL"];
                }

                context.Response.Redirect(string.Format(url, username,site),false);
            }
            catch (Exception ex)
            {                
                log.Error("ExitGameTransit:", ex);
            }

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
