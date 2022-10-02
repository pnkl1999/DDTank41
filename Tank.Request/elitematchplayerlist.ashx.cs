using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Services;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for elitematchplayerlist
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class elitematchplayerlist : IHttpHandler
    {

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            context.Response.Write(Build(context));
        }

        public static string Build(HttpContext context)
        {
            if (!csFunction.ValidAdminIP(context.Request.UserHostAddress))
                return "elitematchplayerlist Fail!";

            return Build();
        }

        public static string Build()
        {
            return csFunction.BuildEliteMatchPlayerList("elitematchplayerlist");
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