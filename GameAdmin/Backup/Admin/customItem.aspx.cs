using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Net;
using System.IO;
using System.Xml;
using System.Xml.Linq;

namespace AdminGunny.Admin
{
    public partial class customItem : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string IDs = HttpUtility.UrlDecode(Request["IDs"]);
            string Keys = HttpUtility.UrlDecode(Request["keys"]);
            if (!string.IsNullOrEmpty(IDs) && !string.IsNullOrEmpty(Keys))
            {
                char[] delimiterChars = { ',' };
                string[] splitkey = Keys.Split(delimiterChars);
                int GoodsID = Convert.ToInt32(IDs);
                if (splitkey[0] == "customItems")
                {
                    var business = new Bussiness.ProduceBussiness();
                    var getAllItem = business.GetSingleGoods(GoodsID);
                    string btn_ok = "<p style=\"width: 100%; height:18px; text-align:center;\"><a style=\"font-size: 15px; font-weight: bold;\" href=\"javascript:void(0);\" onclick=\"set_customitems("
                                        + splitkey[1] + "," + getAllItem.TemplateID + ");\">[Xác nhận]</a>&nbsp;&nbsp;&nbsp;<a style=\"font-size: 15px; font-weight: bold;\" href=\"javascript:void(0);\" onclick=\"hide_customitem();\">[Huỷ]</a></p>";
                    if (getAllItem.CanCompose == true || getAllItem.CanStrengthen == true)
                    {
                        //Response.Write("Request " + IDs + " OK!" + btn_ok);
                        Btn.Text = btn_ok;
                        if (getAllItem.CanStrengthen != true)
                        {
                            Btn.Text += "<script type=\"text/javascript\">$(\"#sp_lbStr\").css({ display: \"none\" }); $(\"#sp_SelectStr\").css({ display: \"none\" })</script>";
                        }
                        if (getAllItem.CanCompose != true)
                        {
                            Btn.Text += "<script type=\"text/javascript\">$(\"#sp_lbComp\").css({ display: \"none\" }); $(\"#sp_SelectComp\").css({ display: \"none\" })</script>";
                        }
                    }
                    else if (getAllItem.CanCompose == false && getAllItem.CanStrengthen == false && getAllItem.CanEquip==true)
                    {
                        
                            Btn.Text = btn_ok;
                            Btn.Text += "<script type=\"text/javascript\">$(\"#sp_lbStr\").css({ display: \"none\" }); $(\"#sp_SelectStr\").css({ display: \"none\" })</script>";
                            Btn.Text += "<script type=\"text/javascript\">$(\"#sp_lbComp\").css({ display: \"none\" }); $(\"#sp_SelectComp\").css({ display: \"none\" })</script>";
                    }
                    else
                    {

                     Response.Write("Vật phẩm này không có tuỳ chọn!<p style=\"width: 100%; height:18px; text-align:center;\"><a style=\"font-size: 15px; font-weight: bold;\" href=\"javascript:void(0);\" onclick=\"hide_customitem();\">[Đóng]</a></p>");
                     Response.Write("<script type=\"text/javascript\">$(\"#Div_main\").css({ display: \"none\" })</script>");
                    }

                }
                else
                {
                    Response.Write(Keys);
                }
            }
            else { Response.Write("Request Fail!"); }
        }
    }
}