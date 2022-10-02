using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;
using System.Net;
using System.IO;

namespace AdminGunny.Admin
{
    public partial class test : System.Web.UI.Page
    {
        
        [System.Web.Services.WebMethod]
        public static string PageLoad_FromAjax()
        {
             
             string stringHTML = "<table style=\"width:840px;\">";
             
            int b = 0;
            do
            {
                stringHTML += "<tr>";
                for (int s = 0; s < 4; s++)
                {
                    if (b < 11)
                    {
                        stringHTML += "<td class=\"style7\"><table class=\"style1\">";
                        stringHTML += "<tr><td class=\"style6\" colspan=\"2\">";
                        stringHTML += "label" + b + "";
                        stringHTML += "</td></tr><tr><td class=\"style2\" rowspan=\"3\">";
                        stringHTML += "Pic";
                        stringHTML += "</td><td class=\"style6a\">";
                        stringHTML += "Send";
                        stringHTML += "</td></tr><tr><td class=\"style6a\">";
                        stringHTML += "Delete";
                        stringHTML += "</td></tr><tr><td class=\"style6a\">";
                        stringHTML += "Edit";
                        stringHTML += "</td></tr></table></td>";

                        b++;
                    }
                }

                stringHTML += "</tr>";

            } while (b < 11);
            stringHTML += "</table>";
            
            return stringHTML;

        }
       
       public static string linkResource(string Pic, int CategoryID, int NeedSex)
        {

            string imagePath = "/Resource/";
            //int n = 2;

            string gender = NeedSex == 1 ? "m" : "f";

            switch (CategoryID)
            {

                case 1:
                    imagePath += "image/equip/" + gender + "/head/" + Pic;// + "/icon_1.png";
                    break;
                case 2:
                    imagePath += "image/equip/" + gender + "/glass/" + Pic;// + "/icon_1.png";
                    break;
                case 3:
                    imagePath += "image/equip/" + gender + "/hair/" + Pic;// + "/icon_1.png";
                    break;
                case 4:
                    imagePath += "image/equip/" + gender + "/eff/" + Pic;// + "/icon_1.png";
                    break;
                case 5:
                    imagePath += "image/equip/" + gender + "/cloth/" + Pic;// + "/icon_1.png";
                    break;
                case 6:
                    imagePath += "image/equip/" + gender + "/face/" + Pic;// + "/icon_1.png";
                    break;
                case 27:
                case 7:
                    imagePath += "image/arm/" + Pic;// + "/00.png";
                    break;
                case 8:
                    imagePath += "image/equip/armlet/" + Pic + "/icon.png";
                    break;
                case 9:
                    imagePath += "image/equip/ring/" + Pic + "/icon.png";
                    break;
                case 30:
                case 11:
                    imagePath += "image/unfrightprop/" + Pic + "/icon.png";
                    break;
                case 12:
                    imagePath += "image/task/" + Pic + "/icon.png";
                    break;
                case 13:
                    imagePath += "image/equip/" + gender + "/suits/" + Pic;// + "/icon_1.png";
                    break;
                case 14:
                    imagePath += "image/necklace/" + Pic + "/icon.png";
                    break;
                case 15:
                    imagePath += "image/equip/wing/" + Pic;// + "/icon.png";
                    break;
                case 16:
                    imagePath += "image/specialprop/chatBall/" + Pic + "/icon.png";
                    break;
                case 17:
                case 31:
                    imagePath += "image/equip/offhand/" + Pic + "/icon.png";
                    break;
                case 18:
                    imagePath += "image/cardbox/" + Pic + "/icon.png";
                    break;
                case 19:
                case 20:
                case 23:
                case 28:
                case 29:
                    imagePath += "image/prop/" + Pic + "/icon.png";

                    break;
                case 26:
                    imagePath += "image/card/" + Pic + "/icon.jpg";
                    break;
                case 25:
                    imagePath += "image/gift/" + Pic + "/icon.png";
                    break;

            }

            return imagePath;
        }
       
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

    }
}