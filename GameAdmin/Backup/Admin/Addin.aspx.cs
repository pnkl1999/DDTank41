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
    public partial class Addin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var xmlreader = new _Default();
            ShowLoadMenu.Text = xmlreader.GetXML("data/MenuAddin", "RootMenu");//PageLoad_Menu();
        
        }

        protected void ButtonTemp_Click(object sender, EventArgs e)
        {

        }

        protected void ButtonBall_Click(object sender, EventArgs e)
        {

        }

        protected void ButtonBomb_Click(object sender, EventArgs e)
        {

        }

        protected void ButtonBoxTemp_Click(object sender, EventArgs e)
        {

        }

        protected void ButtonShopItem_Click(object sender, EventArgs e)
        {

        }

        protected void ButtonMap_Click(object sender, EventArgs e)
        {

        }

        protected void ButtonPVE_Click(object sender, EventArgs e)
        {

        }

        protected void ButtonNPC_Click(object sender, EventArgs e)
        {

        }

        protected void ButtonQuest_Click(object sender, EventArgs e)
        {

        }

        protected void BtCheckResource_Click(object sender, EventArgs e)
        {

        }
      }
}