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
using Bussiness.Interface;
using Bussiness;
using log4net;
using System.Reflection;
using Bussiness.CenterService;

namespace Tank.Request
{
    public partial class CreateLogin : System.Web.UI.Page
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static string GetLoginIP
        {
            get
            {
                return ConfigurationSettings.AppSettings["LoginIP"];
            }
        }

        public static bool ValidLoginIP(string ip)
        {
            string ips = GetLoginIP;
            if (string.IsNullOrEmpty(ips) || ips.Split('|').Contains(ip))
                return true;
            return false;
        } 

        protected void Page_Load(object sender, EventArgs e)
        {
            int result = 1;
            try
            {
                //if (ValidLoginIP(Context.Request.UserHostAddress))
                //{
                    string content = HttpUtility.UrlDecode(Request["content"]);
                    string site = Request["site"] == null ? "" : HttpUtility.UrlDecode(Request["site"]).ToLower();
                    BaseInterface inter = BaseInterface.CreateInterface();
                    string[] str = inter.UnEncryptLogin(content, ref result, site);
                    if (str.Length > 3)
                    {
                        string name = str[0].Trim().ToLower();
                        string password = str[1].Trim().ToLower();
                        if (!string.IsNullOrEmpty(name) && !string.IsNullOrEmpty(password))
                        {
                            name = BaseInterface.GetNameBySite(name, site);
                            PlayerManager.Add(name, password);
                           
                            result = 0;
                        }
                        else
                        {
                            result = -91010;
                        }
                    }
                    else
                    {
                        //result = -1900;
                    }
                //}
                //else
                //{
                    //result = 3;
                //}

            }
            catch (Exception ex)
            {
                log.Error("CreateLogin:", ex);
            }
            Response.Write(result);
        }
    }
}
