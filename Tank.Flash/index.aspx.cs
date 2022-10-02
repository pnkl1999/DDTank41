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

namespace Tank.Flash
{
    public partial class index : System.Web.UI.Page
    {
        private string _content="sdf";
        public string Content
        {
            get
            {
                return _content;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _content = "kenken|123456";
        }
    }
}
