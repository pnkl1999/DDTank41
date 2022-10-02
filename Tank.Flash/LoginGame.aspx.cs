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
using System.Net;
using System.IO;
using System.Text;
using Bussiness.Interface;
using Road.Flash;

namespace Tank.Flash
{
    public partial class logingame : System.Web.UI.Page
    {
        public string LoginOnUrl
        {
            get
            {
                return ConfigurationManager.AppSettings["LoginOnUrl"];
            }
        }

        public static string FlashUrl
        {
            get
            {
                return ConfigurationManager.AppSettings["FlashUrl"];
            }
        }

      
        protected void Page_Load(object sender, EventArgs e)
        {
            if ((Session["username"] == null) && string.IsNullOrEmpty(Session["username"].ToString()))
            {
                Response.Redirect(LoginOnUrl, false);
            }
            else if (!LoadingManager.Login(Session["username"].ToString(), Session["password"].ToString()))
            {
                Response.Redirect(LoginOnUrl, false);
            }
            string result = "";
            try
            {
                string name = Session["username"].ToString();
                string password = Guid.NewGuid().ToString();
                string time = BaseInterface.ConvertDateTimeInt(DateTime.Now).ToString();
                string key = string.Empty;
                
                if (string.IsNullOrEmpty(key))
                {
                    key = BaseInterface.GetLoginKey;
                }
                string v = BaseInterface.md5(name + password + time.ToString() + key);
                string Url = (BaseInterface.LoginUrl + "?content=" + HttpUtility.UrlEncode(name + "|" + password +"|srv|login" + "|" + time.ToString() + "|" + v));
                result = BaseInterface.RequestContent(Url);
                if (result == "0")
                {
                    string url = FlashUrl + "?user=" + HttpUtility.UrlEncode(name) + "&key=" + HttpUtility.UrlEncode(password.ToUpper());     
                    Response.Write(url);
                }
                else
                {
                    Response.Write(result);
                }
            }
            catch (Exception ex)
            {
                Response.Write(ex.ToString());
            }

        }
    }
}