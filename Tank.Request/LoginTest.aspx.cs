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

namespace Tank.Request
{
    public partial class LoginTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string name = "onelife";// Request["name"];
            string pass = "733789";// Request["pass"];
            int time = 1255165271;// BaseInterface.ConvertDateTimeInt(DateTime.Now);
            string loginKey = "yk-MotL-qhpAo88-7road-mtl55dantang-login-logddt777";
            string key = BaseInterface.md5(name + pass + time.ToString() + loginKey);
            string content = "content=" + HttpUtility.UrlEncode(name + "|" + pass + "|" + time.ToString() + "|" + key);

            string str = "http://localhost:728/CreateLogin.aspx?content=" + HttpUtility.UrlEncode(name + "|" + pass + "|" + time.ToString() + "|" + key);
           // string str = "http://localhost:728/CreateLogin.aspx?content=" + name + "|" + pass + "|" + time.ToString() + "|" + key;
            string url = BaseInterface.RequestContent(str);
            //string url = BaseInterface.RequestContent(str, content);  
            Response.Write(url);
        }
    }
}
