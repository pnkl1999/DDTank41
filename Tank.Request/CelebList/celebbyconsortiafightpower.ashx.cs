using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Services;

namespace Tank.Request.CelebList
{
    /// <summary>
    /// Summary description for celebbyconsortiafightpower
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class celebbyconsortiafightpower : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            context.Response.Write(Build(context));
        }

        public static string Build(HttpContext context)
        {
            if (!csFunction.ValidAdminIP(context.Request.UserHostAddress))
                return "celebbyconsortiafightpower Fail!";
            // rebuild all consortia fight power

            return Build();
        }

        public static string Build()
        {
            return csFunction.BuildCelebConsortiaFightPower("celebbyconsortiafightpower", "celebbyconsortiafightpower_Out");
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