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
    public partial class Item : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
            var xmlreader = new _Default();
            ShowLoadMenu.Text = xmlreader.GetXML("data/MenuItems", "RootMenu");//PageLoad_Menu();
        }

        
        [System.Web.Services.WebMethod]
        public static string SelectLoadData(int CategoryID, int page_number, bool show_smartpaginator)
        {
            string string_return = "";
            if (CategoryID == 0)
            {
                string_return = Load_AllItem(page_number, show_smartpaginator);
            }
            else 
            {
                string_return = Show_SingleCategory(CategoryID, page_number, show_smartpaginator);
            }
            return string_return;
        }
        [System.Web.Services.WebMethod]
        
        public static string Load_AllItem(int page_number, bool show_smartpaginator)
        {
            var business = new Bussiness.ProduceBussiness();
            var getAllItem = business.GetAllGoods();
            string stringHTML = "<table class=\"showAllItiems\">";

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
                            int TemplateIDs = getAllItem[min_count].TemplateID;
                            string src_path = adminClass.select_pic(true, getAllItem[min_count].TemplateID);
                            stringHTML += adminClass.loadMidTable(getAllItem[min_count].Name,
                                                              getAllItem[min_count].CategoryID,
                                                              getAllItem[min_count].TemplateID,
                                                              src_path, getAllItem[min_count].Pic);
                            
                            min_count++;
                        }

                    }
                    stringHTML += "</tr>";


            } while (min_count < max_count);

            stringHTML += "</table>";
            if (show_smartpaginator==true)
            {
            stringHTML +="<script type=\"text/javascript\">" +
                    "$(function() {" +
                    "$('#show_smartpaginator').smartpaginator({ totalrecords: " + getAllItem.Count() + ", onchange: function (newPage) {" +
                    "	loading_Data(0 , newPage, false);" +
                    "				}" +
                    "			});" +
                    "		});" +
                    "</script>";
            }
            //ShowAllItem.Text = stringHTML;
            return stringHTML;
                
        }
        
        
        [System.Web.Services.WebMethod]
        public static string Show_SingleCategory(int CategoryID, int page_number, bool show_smartpaginator)
        {
            
            var business = new Bussiness.ProduceBussiness();
            var getAllItem = business.GetSingleCategory(CategoryID);
            
            //print result;
            string stringHTML = "<table class=\"showAllItiems\" >";

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
                        int TemplateIDs = getAllItem[min_count].TemplateID;
                        string src_path = adminClass.select_pic(true, getAllItem[min_count].TemplateID);
                        stringHTML += adminClass.loadMidTable(getAllItem[min_count].Name,
                                                               getAllItem[min_count].CategoryID, 
                                                               getAllItem[min_count].TemplateID,
                                                               src_path, getAllItem[min_count].Pic);
                        
                        min_count++;
                    }
                }
                stringHTML += "</tr>";


            } while (min_count < max_count);

            stringHTML += "</table>";
            if (show_smartpaginator == true)
            {
                               
                    stringHTML += "<script type=\"text/javascript\">" +
                            "$(function() {" +
                            "$('#show_smartpaginator').smartpaginator({ totalrecords: " + getAllItem.Count() + ", onchange: function (newPage) {" +
                            "	loading_Data(" + CategoryID + ", newPage, false);" +
                            "				}" +
                            "			});" +
                            "		});" +
                            "</script>";
              
            }
            //ShowAllItem.Text = stringHTML;
            return stringHTML;
                
        }

      }

}