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
using System.Configuration;

namespace AdminGunny.Admin
{
    /// <summary>
    /// Summary description for tanferItems
    /// </summary>
    public class mainRequest : System.Web.UI.Page
    {
        public static int agentId
        {
            get
            {
                return int.Parse(ConfigurationManager.AppSettings["ServerID"]);
            }
        }
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
                                                  src_path.ToLower(), getAllItem.Pic);


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

                var userid = business.GetUserSingleByUserName(UserName).ID;

               
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
                business.SendMail(mail, agentId);

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
            string htmlString = "Gửi thất bại!";
            if (content.Length > 2000 || content=="")
            {
                content = "You got Items from Administrators! How Luck!";
            }
            if (title.Length > 1000 || title == "")
            {
                title = "Email from Administrators!";
            }
            var business = new Bussiness.PlayerBussiness();
            //var produce = new Bussiness.ProduceBussiness();
            try
            {

                PlayerInfo player = business.GetUserSingleByUserName(UserName);
                if (player == null)
                {
                    player = business.GetUserSingleByNickName(UserName);
                }
                if (player == null)
                {
                    player = business.GetUserSingleByUserID(int.Parse(UserName));
                }

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
                        business.SendMail(mail, agentId);
                        htmlString = "Gởi thư cho Tài khoản(Nickname) <strong>" + UserName + "</strong>, thành công!";
                    }
                    else
                    {
                        //business.SendMailAndItem(title, content, player.ID, agentId, 0, 0, param);
                        List<ItemInfo> infos = new List<ItemInfo>();                        
                        string[] itemStrs = param.Split('|');
                        foreach (string itemStr in itemStrs)
                        {
                            if (!string.IsNullOrEmpty(itemStr) || itemStr != "")
                            {
                                //1110,1,30,15,20,20,20,20,true
                                string[] infoStrs = itemStr.Split(',');
                                if (infoStrs.Length >= 9 && infoStrs[0] != "")
                                {
                                    ItemTemplateInfo temp = ItemMgr.FindItemTemplate(int.Parse(infoStrs[0]));
                                    if (temp != null)
                                    {
                                        int maxComppose = int.Parse(ConfigurationManager.AppSettings["MAX_COMPOSE"]);
                                        int maxStrengthen = int.Parse(ConfigurationManager.AppSettings["MAX_STRENGTGTHEN"]);
                                        ItemInfo item = ItemInfo.CreateFromTemplate(temp, 1, 105);
                                        item.Count = int.Parse(infoStrs[1]);
                                        item.ValidDate = int.Parse(infoStrs[2]);
                                        item.StrengthenLevel = int.Parse(infoStrs[3]) > maxStrengthen ? maxStrengthen : int.Parse(infoStrs[3]);
                                        item.AttackCompose = int.Parse(infoStrs[4]) > maxComppose ? maxComppose : int.Parse(infoStrs[4]);
                                        item.DefendCompose = int.Parse(infoStrs[5]) > maxComppose ? maxComppose : int.Parse(infoStrs[5]);
                                        item.AgilityCompose = int.Parse(infoStrs[6]) > maxComppose ? maxComppose : int.Parse(infoStrs[6]);
                                        item.LuckCompose = int.Parse(infoStrs[7]) > maxComppose ? maxComppose : int.Parse(infoStrs[7]);
                                        item.IsBinds = Convert.ToBoolean(infoStrs[8]);// bool.Parse(infoStrs[8]);
                                        infos.Add(item);
                                    }
                                    else
                                    {
                                        htmlString = "Template not found!";
                                    }
                                }
                            }
                        }
                        if (infos.Count > 0)
                        {
                            WorldEventMgr.SendItemsToMail(infos, player.ID, player.NickName, agentId, title, 83, "Administrators");
                            htmlString = "Gởi thư và Items đính kèm cho <strong>" + player.NickName + "</strong>, thành công!";
                        }
                    }
                }
                else
                {
                    htmlString = "Bạn chưa tạo nhân vật.";
                }
                
            }
            catch (Exception e)
            {
                htmlString = e.ToString();
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