using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;

namespace AdminGunny.Admin
{
    public partial class sendMail5Item : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            /*
            if (!IsPostBack)
            {
                Content_tbx.Text = string.Empty;
                Title_tbx.Text = string.Empty;
                UserName_tbx.Text = string.Empty;
             * 
            }*/
            string stringHidden = "";
            for (int s = 1; s < 6; s++)
            {
                stringHidden += "<input id=\"HiddenItem" + s + "\" value=\"\" type=\"hidden\" />";
                stringHidden += "<input id=\"HiddenCount" + s + "\" value=\"1\" type=\"hidden\" />";
                stringHidden += "<input id=\"HiddenValid" + s + "\" value=\"7\" type=\"hidden\" />";
                stringHidden += "<input id=\"HiddenStreng" + s + "\" value=\"0\" type=\"hidden\" />";
                stringHidden += "<input id=\"HiddenAttack" + s + "\" value=\"0\" type=\"hidden\" />";
                stringHidden += "<input id=\"HiddenDefend" + s + "\" value=\"0\" type=\"hidden\" />";
                stringHidden += "<input id=\"HiddenAgility" + s + "\" value=\"0\" type=\"hidden\" />";
                stringHidden += "<input id=\"HiddenLuck" + s + "\" value=\"0\" type=\"hidden\" />";
            }
            var xmlreader = new _Default();
            ShowLoadMenu.Text = xmlreader.GetXML("data/MiniMenuItems", "RootMenu");//PageLoad_Menu();
            ShowLoadMenu.Text += stringHidden;
            //ShowLoadMenu.Text = PageLoad_Menu();
        }
        

    }
}