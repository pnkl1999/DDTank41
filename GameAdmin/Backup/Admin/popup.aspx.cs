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
    public partial class popup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string IDs = HttpUtility.UrlDecode(Request["IDs"]);
            string Keys = HttpUtility.UrlDecode(Request["keys"]);
            if (!string.IsNullOrEmpty(IDs) && !string.IsNullOrEmpty(Keys))
            {
                //ShowPopup.Text = "AAAAAAAAAA " + TemplateIDs +" "+ key;
                int GoodsID = Convert.ToInt32(IDs);
                if (Keys == "ItemsInfo")
                {
                    //ShowPopup.Text = getItemsInfo(ID);
                    getItemsInfo(GoodsID);

                }
                else { Response.Write(Keys);
                }
            }
            else { Response.Write("Request Fail!"); }
        }
        public string Get_Type(string Category)
        {
            string stringOutPut = "";
            //----------------------------
            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(Server.MapPath("data/LoadItemsCategory.xml"));
            XmlNodeList xNodeList = xDoc.SelectNodes("Result/child::node()");
            foreach (XmlNode xNode in xNodeList)
            {
                if (xNode.Attributes["ID"].Value == Category)
                {
                    stringOutPut = xNode.Attributes["Name"].Value;
                }
                //else { stringOutPut = "Vật thể lạ! @@"; }
               
            }
            return stringOutPut;
        }
        protected void getItemsInfo(int GoodsID)
        {

            var business = new Bussiness.ProduceBussiness();
            var getAllItem = business.GetSingleGoods(GoodsID);

            string tailQuality = "";
            string colorStyle = "";
            string subShowTitles0 = "";
            string getAllItemName = getAllItem.Name == "" ? "Default Item" : getAllItem.Name;
            switch (getAllItem.Quality)
            {
                case 1:
                    tailQuality = "Thô";
                    colorStyle = "808080";
                    break;
                case 2:
                    tailQuality = "Thường";
                    colorStyle = "006600";
                    break;
                case 3:
                    tailQuality = "Ưu";
                    colorStyle = "0000FF";
                    break;
                case 4:
                    tailQuality = "Tinh Anh";
                    colorStyle = "990099";
                    break;
                case 5:
                    tailQuality = "xuất sắc";
                    colorStyle = "FF9900";
                    break;
            }

            ShowTitles.Text = "<span style=\"color:#" + colorStyle + "\"> " + getAllItemName + "</span>";
           
            switch (getAllItem.CategoryID)
            {
               case 1:
               case 5:
                   subShowTitles0 = "Áo Giáp";
                    break;
               case 27:
               case 7:
                    subShowTitles0 = "Sát thương";
                    break;
               case 17:
               case 31:
                    if (getAllItem.TemplateID == 17003 || getAllItem.TemplateID == 17004)
                    {
                        subShowTitles0 = "Áo Giáp";
                    }
                    else { subShowTitles0 = "Hồi phục"; }
                    break;
            }
           if (subShowTitles0 != "")
           {
               ShowTitles0.Text = subShowTitles0 + ":&nbsp;&nbsp;<span class=\"span_style205\"> " + getAllItem.Property7 + "</span>";
           }
            if (getAllItem.Attack != 0 )
           {
               ShowAttack.Text = "Tấn Công:&nbsp;&nbsp;<span class=\"span_style205\"> " + Convert.ToString(getAllItem.Attack) + "</span>";
               ShowDefence.Text = "Phòng thủ:&nbsp;&nbsp;<span class=\"span_style205\"> " + Convert.ToString(getAllItem.Defence) + "</span>";
               ShowAgility.Text = "Nhanh nhẹn:&nbsp;&nbsp;<span class=\"span_style205\"> " + Convert.ToString(getAllItem.Agility) + "</span>";
               ShowLuck.Text = "May mắn:&nbsp;&nbsp; <span class=\"span_style205\"> " + Convert.ToString(getAllItem.Luck) + "</span>";
            }
            ShowDescription.Text = Convert.ToString(getAllItem.Description);
            ShowCategoryID.Text = "Category:&nbsp;&nbsp;" + Convert.ToString(getAllItem.CategoryID);
            ShowTemplateID.Text = "ID:&nbsp;&nbsp;" + Convert.ToString(getAllItem.TemplateID);
            Type.Text = "Loại:&nbsp;&nbsp;<span class=\"style202\"> " + Get_Type(Convert.ToString(getAllItem.CategoryID)) + "</span>";
            Quality.Text = "Phẩm chất:&nbsp;&nbsp;<span style=\"color:#" + colorStyle + "\"> " + tailQuality + "</span>";
            if (getAllItem.NeedSex == 1)
            {
                LbSex.Text = "Gới tính:&nbsp;&nbsp;<span style=\"color:#FF0000\">Nam</span>";
            }
            else if (getAllItem.NeedSex == 2) { LbSex.Text = "Gới tính:&nbsp;&nbsp;<span style=\"color:#006600\">Nữ</span>"; }
            if (getAllItem.CanCompose == true)
            {
               LbCan.Text = "Có thể hợp thành";
                
            }
            if (getAllItem.CanStrengthen == true)
                {

                    LbCan.Text = "Có thể cường hoá";
                }

        }

    }
}