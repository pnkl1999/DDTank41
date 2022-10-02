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
using System.Text;

namespace Tank.Request
{
    public partial class SystemNotice : System.Web.UI.Page
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static string GetChargeIP
        {
            get
            {
                return ConfigurationSettings.AppSettings["AdminIP"];
            }
        }

        public static bool ValidLoginIP(string ip)
        {
            string ips = GetChargeIP;
            if (string.IsNullOrEmpty(ips) || ips.Split('|').Contains(ip))
                return true;
            return false;
        } 

        protected void Page_Load(object sender, EventArgs e)
        {
            int result = 1;
            try
            {
                if (ValidLoginIP(Context.Request.UserHostAddress))
                {
                    string content = HttpUtility.UrlDecode(Request["content"]); //"Server is maintenance!";

                    if (!string.IsNullOrEmpty(content))
                    {
                        using (CenterServiceClient temp = new CenterServiceClient())
                        {
                            if (temp.SystemNotice(content))
                            {
                                result = 0;
                            }
                        }
                    }
                }
                else
                {
                    result = 2;
                }
            }
            catch (Exception ex)
            {
                log.Error("SystemNotice:", ex);
            }
            Response.Write(result);
        }
    }
}
