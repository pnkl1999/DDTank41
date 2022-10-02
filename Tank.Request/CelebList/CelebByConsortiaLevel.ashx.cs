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

namespace Tank.Request.CelebList
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class CelebByConsortiaLevel : IHttpHandler
    {

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            context.Response.Write(Build(context));
        }

        public static string Build(HttpContext context)
        {
            if (!csFunction.ValidAdminIP(context.Request.UserHostAddress))
                return "CelebByConsortiaLevel Fail!";

            return Build();
        }

        public static string Build()
        {
            return csFunction.BuildCelebConsortia("CelebByConsortiaLevel", 16, "CelebForConsortia");
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
