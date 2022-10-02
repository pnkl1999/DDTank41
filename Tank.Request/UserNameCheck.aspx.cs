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
using log4net;
using System.Reflection;
using Bussiness.Interface;

namespace Tank.Request
{
    public partial class UserNameCheck : System.Web.UI.Page
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        protected void Page_Load(object sender, EventArgs e)
        {
            int result = 1;
            try
            {
                string username = HttpUtility.UrlDecode(Request["username"]);
                string site = Request["site"] == null ? "" : HttpUtility.UrlDecode(Request["site"]);

                if (!string.IsNullOrEmpty(username))
                {
                    username = BaseInterface.GetNameBySite(username, site);
                    using (PlayerBussiness db = new PlayerBussiness())
                    {
                        PlayerInfo info = db.GetUserSingleByUserName(username);
                        if (info != null)
                        {
                            result = 0;
                        }
                        else
                        {
                            result = 2;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("UserNameCheck:", ex);
            }
            Response.Write(result);
        }
    }
}
