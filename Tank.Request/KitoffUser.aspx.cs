using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Bussiness.CenterService;
using log4net;
using System.Reflection;
using Bussiness;

namespace Tank.Request
{
    public partial class KitoffUser : System.Web.UI.Page
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static string GetAdminIP
        {
            get
            {
                return ConfigurationSettings.AppSettings["AdminIP"];
            }
        }

        public static bool ValidLoginIP(string ip)
        {
            string ips = GetAdminIP;
            if (string.IsNullOrEmpty(ips) || ips.Split('|').Contains(ip))
                return true;
            return false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool result = false;
            try
            {
                if (ValidLoginIP(Context.Request.UserHostAddress))
                {
                    //string name = Request["name"];
                    //bool isExist = bool.Parse(Request["IsExist"]);
                    //using (ManageBussiness db = new ManageBussiness())
                    //{
                    //    //result = db.KitoffUserByUserName(name, "您被GM踢下线!");
                    //    result = db.ForbidPlayerByUserName(name, DateTime.Now.AddDays(2).Date, isExist);
                    //}
                }
            }
            catch (Exception ex)
            {
                log.Error("GetAdminIP:", ex);
            }

            Response.Write(result);
        }
    }
}
