using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SqlDataProvider.Data;
using SqlDataProvider.BaseClass;
using System.Data;
using System.Data.SqlClient;
using DAL;
using log4net;
using System.Reflection;
using log4net.Util;
using Bussiness.Managers;
using Bussiness.CenterService;
using System.Collections;


namespace AdminGunny.Admin
{
    /// <summary>
    /// Summary description for tanferItems
    /// </summary>
    public class mainRequest : System.Web.UI.Page
    {
        protected static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        [System.Web.Services.WebMethod]
        public static string SelectFunc(int request, int requestID)
        {
            string string_return = "";
            if (request == 1)
            {
                string_return = tranferItems(requestID);
            }
            if (request == 2)
            {
                string_return = deleteItems(requestID);
            }
            if (request == 3)
            {
                string_return = editItems(requestID);
            }
            return string_return;
        }
        [System.Web.Services.WebMethod]
        public static string tranferItems(int requestID)
        {
            string string_return = "";
            string_return += getBuilder();
            return string_return;
        }
        [System.Web.Services.WebMethod]
        public static string deleteItems(int requestID)
        {
            string string_return = "";
            string_return += getBuilder();
            return string_return;
        }
        [System.Web.Services.WebMethod]
        public static string editItems(int requestID)
        {
            string string_return = "";
            string_return += getBuilder();
            return string_return;
        }
        
        [System.Web.Services.WebMethod]

        public static string Search_Item(int GoodsID)
        {
            var business = new Bussiness.ProduceBussiness();
            var getAllItem = business.GetSingleGoods(GoodsID);
            string stringHTML = "Không tìm thấy Item có ID: " + GoodsID;
            if (getAllItem != null)
            {
                stringHTML = "<table >";
                stringHTML += "<tr>";
                int TemplateIDs = getAllItem.TemplateID;
                string src_path = adminClass.select_pic(true, getAllItem.TemplateID);
                stringHTML += adminClass.loadMidTable(getAllItem.Name,
                                                  getAllItem.CategoryID,
                                                  getAllItem.TemplateID,
                                                  src_path, getAllItem.Pic);


                stringHTML += "</tr>";
                stringHTML += "</table>";

                //ShowAllItem.Text = stringHTML;
                return stringHTML;
            }
            else 
            { 
                return stringHTML; 
            }

        }
        [System.Web.Services.WebMethod]
        public static string SendMoney(string UserName, int Gold, int Money, int GiftToken)
        {
            string htmlString = "";
            var business = new Bussiness.PlayerBussiness();
            try
            {

                var userid = business.GetUserSingleByNickName(UserName).ID;

               
                var mail = new SqlDataProvider.Data.MailInfo();
                mail.Title = "Send Money, Gold, Gif Token";
                mail.Content = "Bạn nhận được " + Money + " Xu, " + Gold + " Vàng, " + GiftToken + " Lễ kim";
                mail.ReceiverID = userid;
                mail.Sender = "Administrators";
                mail.SenderID = 0;
                //mail.Type = 1;
                mail.Gold = Gold;
                mail.Money = Money;
                mail.GiftToken = GiftToken;
                business.SendMail(mail);

                htmlString = "Đã chuyển thành công <br /> " + Money + " Xu <br /> " + Gold + " Vàng <br /> " + GiftToken + " Lễ kim <br /> cho tài khoản <strong>" + UserName + "</strong>";
            }
            catch
            {
                htmlString = "Tài khoản <strong>" + UserName + "</strong> không tồn tại.";
            }
            return htmlString;

        }
        [System.Web.Services.WebMethod]
        public static string SendMailByAdmin(string title, string content, string UserName, string param)
        {
            string htmlString = "";
            if (content.Length > 2000 || content=="")
            {
                content = "You got Items from Administrators! How Luck!";
            }
            if (title.Length > 1000 || title == "")
            {
                title = "Email from Administrators!";
            }
            var business = new Bussiness.PlayerBussiness();
            try
            {

                PlayerInfo player = business.GetUserSingleByUserName(UserName);
                if (player != null)
                {

                    if (param == "")
                    {
                        var mail = new SqlDataProvider.Data.MailInfo();
                        mail.Title = title;
                        mail.Content = content;
                        mail.ReceiverID = player.ID;
                        mail.Sender = "Administrators";
                        mail.SenderID = 0;
                        business.SendMail(mail);
                        htmlString = "Gởi thư cho Tài khoản <strong>" + UserName + "</strong>, thành công!";
                    }
                    else
                    {

                        sendmailDataContext sendMailItem = new sendmailDataContext();
                        sendMailItem.SP_Admin_SendAllItem(title, content, player.ID, 0, 0, 0, param);
                        htmlString = "Gởi thư và Items đính kèm cho Tài khoản <strong>" + UserName + "</strong>, thành công!";

                        using (CenterServiceClient client = new CenterServiceClient())
                        {
                            client.MailNotice(player.ID);
                        }
                    }
                }
                else
                {
                    htmlString = "Tài khoản <strong>" + UserName + "</strong> không có thực.";
                }
                
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init", e);
            }
            return htmlString;

        }
        [System.Web.Services.WebMethod]

        public static string Load_ItemIcon(int CategoryID, int page_number, bool show_smartpaginator)
        {
            var business = new Bussiness.ProduceBussiness();
            var getAllItem = business.GetSingleCategory(CategoryID);
            string stringHTML = "<div style=\"font-size: 18px; font-weight: bold; color: #003366; margin: 3px 3px 3px 3px; height: 25px;\">List Item</div><div style=\"min-height: 407px; width: 100%\"><table>";
            
            var max_count = (16 * page_number);
            var min_count = (max_count - 16);
            if (min_count < 0) { min_count = 0; }
            if (max_count > getAllItem.Count()) { max_count = getAllItem.Count(); }
            
            do
            {
                
                stringHTML += "<tr>";
                for (int s = 0; s < 4; s++)
                {
                    if (min_count < max_count)
                    {
                        int GoodsId = getAllItem[min_count].TemplateID;

                        string src_path = adminClass.select_pic(true, GoodsId);
                        if (getAllItem[min_count].Pic != "default" && GoodsId != -300
                            && GoodsId != -200 && GoodsId != -100 && GoodsId != 10200)
                        {                            
                            stringHTML += "<td style=\"text-align: center; border: thin #000080 solid; width: 95px; height: 95px;\"";
                            stringHTML += "onmouseout=\"$(this).css({ background: '#C4C4C4'});\"";
                            stringHTML += "onmouseover=\"$(this).css({ background: '#D2FFA6'});\">";
                            stringHTML += "<img  style=\"cursor: pointer;\" class=\"personPopupTrigger\" onclick=\"call_addItems(" + GoodsId + ", " + getAllItem[min_count].MaxCount + ");\" alt=\"" + GoodsId + ",ItemsInfo,popup\" src=\"" + src_path + "\" />";
                            stringHTML += "</td>";
                        }
                        else
                        {
                            stringHTML += "<td style=\"text-align: center; border: thin #000080 solid; width: 95px; height: 95px;\"";
                            stringHTML += "><img alt=\"\" src=\"" + src_path + "\" />";
                            stringHTML += "</td>";
                        }
                        min_count++;
                    }

                }
                stringHTML += "</tr>";


            } while (min_count < max_count);

            stringHTML += "</table></div><span style=\"font-size:12px; color:#FF0000\">Tips: Click vào Items bạn cần, chương trình sẻ tự động thêm Item vào Item đính kèm.</span>";
            if (show_smartpaginator == true)
            {
                stringHTML += "<script type=\"text/javascript\">" +
                        "$(function() {" +
                        "$('#show_smartpaginator').smartpaginator({ totalrecords: " + getAllItem.Count() + ",length: 4, recordsperpage: 16, controlClass:'pager2', onchange: function (newPage) {" +
                        "	loading_ItemIcon(" + CategoryID + ", newPage, false);" +
                        "				}" +
                        "			});" +
                        "		});" +
                        "</script>";
            }
            //ShowAllItem.Text = stringHTML;
            return stringHTML;

        }
        [System.Web.Services.WebMethod]
        public static string Load_ItemIcon2(int Slot, int page_number, bool show_smartpaginator)
        {
            var business = new Bussiness.ProduceBussiness();
            var getAllItem = business.GetFusionType();
            string stringHTML = "<table>";

            var max_count = (20 * page_number);
            var min_count = (max_count - 20);
            if (min_count < 0) { min_count = 0; }
            if (max_count > getAllItem.Count()) { max_count = getAllItem.Count(); }

            do
            {

                stringHTML += "<tr>";
                for (int s = 0; s < 5; s++)
                {
                    if (min_count < max_count)
                    {
                        int GoodsId = getAllItem[min_count].TemplateID;

                        string src_path = adminClass.select_pic(true, GoodsId);
                        if (getAllItem[min_count].Pic != "default" && GoodsId != -300
                            && GoodsId != -200 && GoodsId != -100 && GoodsId != 10200)
                        {
                            stringHTML += "<td style=\"text-align: center; border: thin #000080 solid; width: 95px; height: 95px;\"";
                            stringHTML += "onmouseout=\"$(this).css({ background: '#C4C4C4'});\"";
                            stringHTML += "onmouseover=\"$(this).css({ background: '#D2FFA6'});\">";
                            stringHTML += "<img  style=\"cursor: pointer;\" class=\"personPopupTrigger\" onclick=\"call_addItems(" + GoodsId + "," + Slot + ");\" alt=\"" + GoodsId + ",ItemsInfo,popup\" src=\"" + src_path + "\" />";
                            stringHTML += "</td>";
                        }
                        else
                        {
                            stringHTML += "<td style=\"text-align: center; border: thin #000080 solid; width: 95px; height: 95px;\"";
                            stringHTML += "><img alt=\"\" src=\"" + src_path + "\" />";
                            stringHTML += "</td>";
                        }
                        min_count++;
                    }

                }
                stringHTML += "</tr>";


            } while (min_count < max_count);

            stringHTML += "</table></div><span style=\"font-size:12px; color:#FF0000\">Tips: Click vào Items bạn cần, chương trình sẻ tự động thêm Item vào slot.</span>";
            if (show_smartpaginator == true)
            {
                stringHTML += "<script type=\"text/javascript\">" +
                        "$(function() {" +
                        "$('#show_smartpaginator').smartpaginator({ totalrecords: " + getAllItem.Count() + ",length: 3, recordsperpage: 20, controlClass:'pager2', onchange: function (newPage) {" +
                        "	loading_ItemIcon2(" + Slot + ", newPage, false);" +
                        "				}" +
                        "			});" +
                        "		});" +
                        "</script>";
            }
            //ShowAllItem.Text = stringHTML;
            return stringHTML;

        }

        [System.Web.Services.WebMethod]
        public static string AddItemsMail(int GoodIDs, string Keys, int isPopup)
        {
            var business = new Bussiness.ProduceBussiness();
            var getAllItem = business.GetSingleGoods(GoodIDs);
            string string_return = "";
            if ((getAllItem.CanCompose == true || getAllItem.CanStrengthen == true) && isPopup==1)
            {
                string_return += "<img class=\"personPopupTrigger\" alt=\"" + getAllItem.TemplateID + ",ItemsInfo." + Keys + ",popupInfo\" src=\"" + adminClass.select_pic(true, GoodIDs) + "\" />";
            }
            else
            {
                string_return += "<img class=\"personPopupTrigger\"  alt=\"" + getAllItem.TemplateID + ",ItemsInfo,popup\" src=\"" + adminClass.select_pic(true, GoodIDs) + "\" />";
            }
                return string_return;
        }
        [System.Web.Services.WebMethod]
        public static string AddItemFusion(int GoodID1234, int GoodID6, int GoodID5)
        {
            var business = new Bussiness.ProduceBussiness();
            int getCountFusion = business.GetAllFusionDesc()[0].FusionID + 1;
            /*
            for (int s = 0; s < business.GetAllFusion().Count(); s++)
            {
                getCountFusion = business.GetAllFusion()[s].FusionID;
            }
            getCountFusion++;
 */
            Admin.sendmailDataContext InsertItemFusion = new Admin.sendmailDataContext();
            int result = InsertItemFusion.SP_Insert_Update_Item_Fusion(getCountFusion, GoodID1234, GoodID1234, GoodID1234, GoodID1234, GoodID6, GoodID5, 1);
            string string_return = "";
            if (result == 2)
            {
                string_return = "Insert Error!";
            }
            else { string_return = "Thêm Item mới thành công!"; }
            return string_return;
        }
        [System.Web.Services.WebMethod]
        public static string UpdateItemFusion(int GoodID1234, int GoodID6, int GoodID5, int FuID)
        {
           
            Admin.sendmailDataContext InsertItemFusion = new Admin.sendmailDataContext();
            int result = InsertItemFusion.SP_Insert_Update_Item_Fusion(FuID, GoodID1234, GoodID1234, GoodID1234, GoodID1234, GoodID6, GoodID5, 0);
            string string_return = "";
            if (result == 2)
            {
                string_return = "Insert Error!";
            }
            else { string_return = "Cập nhật Item thành công!"; }
            return string_return;
        }
        [System.Web.Services.WebMethod]
        public static string DeleteItemFusion(int FuID)
        {

            Admin.sendmailDataContext InsertItemFusion = new Admin.sendmailDataContext();
            int result = InsertItemFusion.SP_delete_Item_Fusion(FuID);
            string string_return = "";
            if (result == 2)
            {
                string_return = "Insert Error!";
            }
            else { string_return = "Xoá Item thành công!"; }
            return string_return;
        }
        public static string getBuilder()
        {
            string string_return = "";
            string_return += "<script type=\"text/javascript\">" +
                                    "tb_showMiniPanel();" +
                             "</script>";
            return string_return;
        }
    }
}