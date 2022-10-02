using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Xml.Linq;
using Bussiness;

namespace Tank.Request
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            //GlobalConfiguration.Configure(WebApiConfig.Register);
            string path = Server.MapPath("~");
            LanguageMgr.Setup(path);
            log4net.Config.XmlConfigurator.Configure();
            StaticsMgr.Setup();
            PlayerManager.Setup();
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {
            StaticsMgr.Stop();
        }
    }
}