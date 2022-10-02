using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AdminGunny.Admin
{
    public partial class ItemFusionBox : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            //Lb_ItemResult.Text = getAllFusion();
            //var xmlreader = new _Default();
            for (int s = 1; s < 7; s++)
            {
                ShowLoadMenu.Text += "<input id=\"HiddenItem" + s + "\" value=\"\" type=\"hidden\" />";
               
            }
            //ShowLoadMenu.Text = xmlreader.GetXML("data/MiniMenuItems", "RootMenu");

      }
        [System.Web.Services.WebMethod]
        public static string getAllFusion(int page_number, bool show_smartpaginator)
        {
            var business = new Bussiness.ProduceBussiness();
            var getAllFusion = business.GetAllFusionDesc();

            string htmlString = "<table class=\"Astyle1449\">";
            htmlString += "<table class=\"Astyle1449\">";
            string styles = "style=\"width: 75px; \"";

            var max_count = (4 * page_number);
            var min_count = (max_count - 4);
            if (min_count < 0) { min_count = 0; }
            if (max_count > getAllFusion.Count()) { max_count = getAllFusion.Count(); }
            int item1 = 0;
            int item2 = 0;
            int item3 = 0;
            int item4 = 0;
            int Formula = 0;
            int reward = 0;

            do
            {

               
               // for (int s = 0; s < 4; s++)
               // {
                    if (min_count < max_count)
                    {
                        var s = min_count;
                        item1 = getAllFusion[s].Item1;
                        item2 = getAllFusion[s].Item2;
                        item3 = getAllFusion[s].Item3;
                        item4 = getAllFusion[s].Item4;
                        Formula = getAllFusion[s].Formula;
                        reward = getAllFusion[s].Reward;
                        if (getAllFusion[s].Item1 > 350)
                        {
                            htmlString += "<tr><td class=\"Astyle1450\"><img " + styles + " class=\"personPopupTrigger\" alt=\"" + item1 + ",ItemsInfo,popup\" src=\"" + adminClass.select_pic(true, item1) + "\" />";
                            htmlString += "</td><td class=\"Astyle1450\"><img " + styles + " class=\"personPopupTrigger\" alt=\"" + item2 + ",ItemsInfo,popup\" src=\"" + adminClass.select_pic(true, item2) + "\" />";
                            htmlString += "</td><td class=\"Astyle1450\"><img " + styles + " class=\"personPopupTrigger\" alt=\"" + item3 + ",ItemsInfo,popup\" src=\"" + adminClass.select_pic(true, item3) + "\" />";
                            htmlString += "</td><td class=\"Astyle1450\"><img " + styles + " class=\"personPopupTrigger\" alt=\"" + item4 + ",ItemsInfo,popup\" src=\"" + adminClass.select_pic(true, item4) + "\" />";
                            htmlString += "</td><td class=\"Astyle1450\"><img " + styles + " class=\"personPopupTrigger\" alt=\"" + Formula + ",ItemsInfo,popup\" src=\"" + adminClass.select_pic(true, Formula) + "\" />";
                            htmlString += "</td><td class=\"Astyle1450\"><img style=\"width: 75px; cursor:pointer; \" onclick=\"editFusion("
                                + item1 + "," + item2 + "," + item3 + "," + item4 + "," + Formula + "," + reward + "," + getAllFusion[s].FusionID + ");\" class=\"personPopupTrigger\" alt=\"" + reward + ",ItemsInfo,popup\" src=\""
                                + adminClass.select_pic(true, reward) + "\" /></tr>";
                        }
                        else
                        {
                            htmlString += "<tr><td class=\"Astyle1450\">FuType:" + item1 + "</td>";
                            htmlString += "<td class=\"Astyle1450\">FuType:" + item2 + "</td>";
                            htmlString += "<td class=\"Astyle1450\">FuType:" + item3 + "</td>";
                            htmlString += "<td class=\"Astyle1450\">FuType:" + item4 + "</td>";
                            htmlString += "<td class=\"Astyle1450\"><img " + styles + " class=\"personPopupTrigger\" alt=\"" + Formula + ",ItemsInfo,popup\" src=\"" + adminClass.select_pic(true, Formula) + "\" /></td>";
                            htmlString += "<td class=\"Astyle1450\">FuType:" + reward + "</td></tr>";
                        }
                        min_count++;
                   // }

                }
                


            } while (min_count < max_count);

            htmlString += "</table></div>";
            if (show_smartpaginator == true)
            {
                htmlString += "<script type=\"text/javascript\">" +
                        "$(function() {" +
                        "$('#show_smartpaginator1').smartpaginator({ totalrecords: " + getAllFusion.Count() + ",length: 3, recordsperpage: 4, controlClass:'pager2', onchange: function (newPage) {" +
                        "	loadAllFusion( newPage, false);" +
                        "				}" +
                        "			});" +
                        "		});" +
                        "</script>";
            }
            
            return htmlString;

        }
    }
}