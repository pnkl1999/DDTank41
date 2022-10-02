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

namespace Tank.Request
{
    public partial class SubmitTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            using (ConsortiaBussiness db = new ConsortiaBussiness())
            {

                //int riches;
                //db.ConsortiaFight(37, 58, 4, out riches, 0);
                //int a = riches;
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Redirect("/LoginTest.aspx?name=" + TextBox1.Text);
        }
    }
}
