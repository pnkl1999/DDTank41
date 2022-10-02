using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Configuration;
using log4net;
using System.Reflection;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class FavoriteTransit : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static string GetFavoriteUrl
        {
            get
            {
                return ConfigurationSettings.AppSettings["FavoriteUrl"];
            }
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            try
            {
                string username = context.Request["username"] == null ? "" : HttpUtility.UrlDecode(context.Request["username"]);
                string site = context.Request["site"] == null ? "" : HttpUtility.UrlDecode(context.Request["site"]).ToLower();

                string url = string.Empty;
                if (!string.IsNullOrEmpty(site))
                {
                    url = ConfigurationSettings.AppSettings[string.Format("FavoriteUrl_{0}", site)];
                    int place = username.IndexOf('_');
                    if (place != -1)
                    {
                        username = username.Substring(place + 1, username.Length - place - 1);
                    }
                }

                if (string.IsNullOrEmpty(url))
                {
                    url = GetFavoriteUrl;
                }

                context.Response.Redirect(string.Format(url, username, site), false);
            }
            catch (Exception ex)
            {
                log.Error("FavoriteTransit:", ex);
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
