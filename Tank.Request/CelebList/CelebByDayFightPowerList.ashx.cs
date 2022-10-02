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

namespace Tank.Request.CelebList
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class CelebByDayFightPowerList : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        public void ProcessRequest(HttpContext context)
        {
            context.Response.Write(Build(context));
        }

        public static string Build(HttpContext context)
        {
            if (!csFunction.ValidAdminIP(context.Request.UserHostAddress))
                return "CelebByDayFightPowerList Fail!";

            return Build();
        }
        public static string Build()
        {
            return csFunction.BuildCelebUsers("CelebByDayFightPowerList", 6, "CelebByDayFightPowerList_Out");

            
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
