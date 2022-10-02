using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for CreatShortCut
    /// </summary>
    public class CreatShortCut : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            string gameurl = context.Request["gameurl"];//?

            context.Response.Write("Not support right now");
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