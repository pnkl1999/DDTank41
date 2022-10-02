using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;

namespace AdminGunny
{
    public class adminClass
    {
       /// <summary>
       /// 
       /// </summary>
       /// <param name="NeedSex"></param>
       /// <param name="Pic"></param>
       /// <param name="CategoryID"></param>
       /// <returns></returns>
        public static string select_pic(bool isIcon, int TemplateID)
        {
            var business = new Bussiness.ProduceBussiness();
            var getAllItem = business.GetSingleGoods(TemplateID);
            string imagePath = System.Configuration.ConfigurationManager.AppSettings["Resource"];
            //int n = 2;
            string Pic = getAllItem.Pic;
            string gender = getAllItem.NeedSex == 1 ? "m" : "f";
            if (Pic != "default")
            {
                switch (getAllItem.CategoryID)
                {

                    case 1:
                        imagePath += "image/equip/" + gender + "/head/" + Pic + "/icon_1.png";
                        break;
                    case 2:
                        imagePath += "image/equip/" + gender + "/glass/" + Pic + "/icon_1.png";
                        break;
                    case 3:
                        imagePath += "image/equip/" + gender + "/hair/" + Pic + "/icon_1.png";
                        break;
                    case 4:
                        imagePath += "image/equip/" + gender + "/eff/" + Pic + "/icon_1.png";
                        break;
                    case 5:
                        imagePath += "image/equip/" + gender + "/cloth/" + Pic + "/icon_1.png";
                        break;
                    case 6:
                        imagePath += "image/equip/" + gender + "/face/" + Pic + "/icon_1.png";
                        break;
                    case 27:
                    case 7:
                        imagePath += "image/arm/" + Pic + "/00.png";
                        break;
                    case 8:
                        imagePath += "image/equip/armlet/" + Pic + "/icon.png";
                        break;
                    case 9:
                        imagePath += "image/equip/ring/" + Pic + "/icon.png";
                        break;
                    case 34:
                    case 35:
                    case 36:
                    case 30:
                    case 40:
                    case 60:
                    case 11:
                        imagePath += "image/unfrightprop/" + Pic + "/icon.png";
                        break;
                    case 12:
                        imagePath += "image/task/" + Pic + "/icon.png";
                        break;
                    case 13:
                        imagePath += "image/equip/" + gender + "/suits/" + Pic + "/icon_1.png";
                        break;
                    case 14:
                        imagePath += "image/equip/necklace/" + Pic + "/icon.png";
                        break;
                    case 15:
                        imagePath += "image/equip/wing/" + Pic + "/icon.png";
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
                    case 50:
                        imagePath += "image/petequip/arm/" + Pic + "/icon.png";
                        break;
                    case 51:
                        imagePath += "image/petequip/hat/" + Pic + "/icon.png";
                        break;
                    case 52:
                        imagePath += "image/petequip/cloth/" + Pic + "/icon.png";
                        break;
                    default:
                        imagePath = "../Images/7road.png";
                        break;

                }
            }
            else { imagePath = "../Images/7road.png"; }
            return imagePath;
        }
        //===================strengThen LV=============================
        public static double getHertAddition(int param1, int param2)
        {
            var strth = param1 * Math.Pow(1.1, param2) - param1;
            return Math.Round(strth);
           
        }
        //=================loadMidTable================================
        public static string loadMidTable(string getName,
            int CategoryID, int GoodsIDs,
            string src_path, string Pic)
        {
            string stringHTML = "";
            stringHTML += "<td class=\"style7\"><table class=\"style1\">";
            stringHTML += "<tr><td class=\"style6\" colspan=\"2\">";
            stringHTML += getName == "" ? "Default" : getName;
            stringHTML += "</td></tr><tr><td class=\"style2\" rowspan=\"3\">";
            if (CategoryID == 26)
            {
                stringHTML += "<img class=\"personPopupTrigger\" alt=\"" + GoodsIDs + ",ItemsInfo,popup\"  style=\"height: 90px;\" src=\"" + src_path + "\" />";
            }
            else
            {
                stringHTML += "<img class=\"personPopupTrigger\" alt=\"" + GoodsIDs + ",ItemsInfo,popup\" src=\"" + src_path + "\" />";
            }
            if (CategoryID == 21 || CategoryID == 31 || CategoryID == 10 || CategoryID == 27 || Pic == "default")
            {

                stringHTML += "</td><td class=\"style6a\">";
                stringHTML += "Thêm vào...";
                stringHTML += "</td></tr><tr><td class=\"style6a\">";
                stringHTML += "Xoá Item";
                stringHTML += "</td></tr><tr><td class=\"style6a\">";
                stringHTML += "Chỉnh sửa";
                stringHTML += "</td></tr></table></td>";
            }
            else
            {
                stringHTML += "</td><td class=\"style6a\">";
                stringHTML += "<a href=\"javascript:void(0);\" onclick=\"call_CSharp(1," + GoodsIDs + ");\" >Thêm vào...</a>";
                stringHTML += "</td></tr><tr><td class=\"style6a\">";
                stringHTML += "<a href=\"javascript:void(0);\" onclick=\"call_CSharp(2," + GoodsIDs + ");\">Xoá Item</a>";
                stringHTML += "</td></tr><tr><td class=\"style6a\">";
                stringHTML += "<a href=\"javascript:void(0);\" onclick=\"call_CSharp(3," + GoodsIDs + ");\">Chỉnh sửa</a>";
                stringHTML += "</td></tr></table></td>";

            }
            return stringHTML;
        }
    }
}