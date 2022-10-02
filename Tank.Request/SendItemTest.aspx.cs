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
using Bussiness;
using SqlDataProvider.Data;

namespace Tank.Request
{
    public partial class SendItemTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //using (PlayerBussiness db = new PlayerBussiness())
            //{
            //    Response.Write(db.SendMailAndItemByUserName("你得到系统物品!", "你得到系统物品!", "kenken", 11023, 20, 0, 0, 0, 0, 0, 0, 0, 0, false));
            //}

            HttpCookie aCookie = Request.Cookies["userInfo"];

            string value = aCookie.Value;
            string userName = aCookie.Values["bd_sig_user"];
            Response.Write(value);
        }
    }
}
