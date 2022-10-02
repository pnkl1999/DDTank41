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
using System.Xml;
using System.Xml.Linq;


namespace AdminGunny.XMLReader
{
    public partial class importXML : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            
        }

        protected void ButtonBallList_Click(object sender, EventArgs e)
        {
            Admin.sendmailDataContext InsertUpdateBall = new Admin.sendmailDataContext();

            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(Server.MapPath("XMLImport/BallList.xml"));
            XmlNodeList xNodeList = xDoc.SelectNodes("Result/child::node()");

            int contNode = 1;
            int contInsert = 0;
            int contUpdate = 0;
            string listItems = "";
            foreach (XmlNode xNode in xNodeList)
            {

                string xml_ID = xNode.Attributes["ID"].Value == "" ? null : xNode.Attributes["ID"].Value;
                string xml_Power = xNode.Attributes["Power"].Value == "" ? null : xNode.Attributes["Power"].Value;
                string xml_Radii = xNode.Attributes["Radii"].Value == "" ? null : xNode.Attributes["Radii"].Value;
                string xml_FlyingPartical = xNode.Attributes["FlyingPartical"].Value == "" ? null : xNode.Attributes["FlyingPartical"].Value;
                string xml_BombPartical = xNode.Attributes["BombPartical"].Value == "" ? null : xNode.Attributes["BombPartical"].Value;
                string xml_Crater = xNode.Attributes["Crater"].Value == "" ? null : xNode.Attributes["Crater"].Value;
                string xml_AttackResponse = xNode.Attributes["AttackResponse"].Value == "" ? null : xNode.Attributes["AttackResponse"].Value;
                string xml_IsSpin = xNode.Attributes["IsSpin"].Value == "" ? null : xNode.Attributes["IsSpin"].Value;
                string xml_SpinV = xNode.Attributes["SpinV"].Value == "" ? null : xNode.Attributes["SpinV"].Value;
                string xml_SpinVA = xNode.Attributes["SpinVA"].Value == "" ? null : xNode.Attributes["SpinVA"].Value;
                string xml_Amount = xNode.Attributes["Amount"].Value == "" ? null : xNode.Attributes["Amount"].Value;
                string xml_Wind = xNode.Attributes["Wind"].Value == "" ? null : xNode.Attributes["Wind"].Value;
                string xml_DragIndex = xNode.Attributes["DragIndex"].Value == "" ? null : xNode.Attributes["DragIndex"].Value;
                string xml_Weight = xNode.Attributes["Weight"].Value == "" ? null : xNode.Attributes["Weight"].Value;
                string xml_Shake = xNode.Attributes["Shake"].Value == "" ? null : xNode.Attributes["Shake"].Value;
                string xml_ShootSound = xNode.Attributes["ShootSound"].Value == "" ? null : xNode.Attributes["ShootSound"].Value;
                string xml_BombSound = xNode.Attributes["BombSound"].Value == "" ? null : xNode.Attributes["BombSound"].Value;
                string xml_ActionType = xNode.Attributes["ActionType"].Value == "" ? null : xNode.Attributes["ActionType"].Value;
                string xml_Mass = xNode.Attributes["Mass"].Value == "" ? null : xNode.Attributes["Mass"].Value;
                string xml_Name = "Weapon " + contNode;
                int result = InsertUpdateBall.SP_Insert_Update_BallList(Convert.ToInt32(xml_ID), xml_Name, Convert.ToDouble(xml_Power)
                    , Convert.ToInt32(xml_Radii), xml_FlyingPartical, xml_BombPartical
                    , xml_Crater, Convert.ToInt32(xml_AttackResponse), Convert.ToBoolean(xml_IsSpin)
                    , Convert.ToInt32(xml_Mass), Convert.ToDouble(xml_SpinVA), Convert.ToInt32(xml_SpinV), Convert.ToInt32(xml_Amount)
                    , Convert.ToInt32(xml_Wind), Convert.ToInt32(xml_DragIndex), Convert.ToInt32(xml_Weight)
                    , Convert.ToBoolean(xml_Shake), xml_ShootSound, xml_BombSound, 200, Convert.ToInt32(xml_ActionType), true,0);
                
                //contNode++;
                if (result == 0)
                {
                    contInsert++;
                    listItems += "Id: " + xml_ID + " Tên: " + xml_Name + "<br/>";
                }
                if (result == 1)
                {
                    contUpdate++;
                }
                contNode++;
            }

            LabelResult.Text = "Thêm mới " + contInsert + " ball! <br/>";
            LabelResult.Text += "Cập nhật " + contUpdate + " ball! <br/>";
            LabelResult.Text += "Tổng cộng " + contNode + " ball! <br/>";
            LabelResult.Text += "Danh sách thêm mới: <br/>" + listItems;
        }

        protected void ButtonTemplateAlllist_Click(object sender, EventArgs e)
        {
            Admin.sendmailDataContext InsertUpdateTemplateAlllist = new Admin.sendmailDataContext();
            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(Server.MapPath("XMLImport/TemplateAlllist.xml"));
            XmlNodeList xNodeList = xDoc.SelectNodes("Result/child::node()");
            
            int contNode = 1;
            int contInsert = 0;
            int contUpdate = 0;
            string listItems = "";
            foreach (XmlNode xNode in xNodeList[0])
            {
                //contNode = xNode.Attributes.Count();
                string xml_AddTime = xNode.Attributes["AddTime"].Value == "" ? null : xNode.Attributes["AddTime"].Value;
                string xml_Agility = xNode.Attributes["Agility"].Value == "" ? null : xNode.Attributes["Agility"].Value;
                string xml_Attack = xNode.Attributes["Attack"].Value == "" ? null : xNode.Attributes["Attack"].Value;
                string xml_CanCompose = xNode.Attributes["CanCompose"].Value == "" ? null : xNode.Attributes["CanCompose"].Value;
                string xml_CanDelete = xNode.Attributes["CanDelete"].Value == "" ? null : xNode.Attributes["CanDelete"].Value;
                string xml_CanDrop = xNode.Attributes["CanDrop"].Value == "" ? null : xNode.Attributes["CanDrop"].Value;
                string xml_CanEquip = xNode.Attributes["CanEquip"].Value == "" ? null : xNode.Attributes["CanEquip"].Value;
                string xml_CanStrengthen = xNode.Attributes["CanStrengthen"].Value == "" ? null : xNode.Attributes["CanStrengthen"].Value;
                string xml_CanUse = xNode.Attributes["CanUse"].Value == "" ? null : xNode.Attributes["CanUse"].Value;
                string xml_CategoryID = xNode.Attributes["CategoryID"].Value == "" ? null : xNode.Attributes["CategoryID"].Value;
                string xml_Colors = xNode.Attributes["Colors"].Value == "" ? null : xNode.Attributes["Colors"].Value;
                string xml_Defence = xNode.Attributes["Defence"].Value == "" ? null : xNode.Attributes["Defence"].Value;
                string xml_Description = xNode.Attributes["Description"].Value == "" ? null : xNode.Attributes["Description"].Value;
                string xml_Level = xNode.Attributes["Level"].Value == "" ? null : xNode.Attributes["Level"].Value;
                string xml_Luck = xNode.Attributes["Luck"].Value == "" ? null : xNode.Attributes["Luck"].Value;
                string xml_MaxCount = xNode.Attributes["MaxCount"].Value == "" ? null : xNode.Attributes["MaxCount"].Value;
                string xml_Name = xNode.Attributes["Name"].Value == "" ? null : xNode.Attributes["Name"].Value;
                string xml_NeedLevel = xNode.Attributes["NeedLevel"].Value == "" ? null : xNode.Attributes["NeedLevel"].Value;
                string xml_NeedSex = xNode.Attributes["NeedSex"].Value == "" ? null : xNode.Attributes["NeedSex"].Value;
                string xml_Pic = xNode.Attributes["Pic"].Value == "" ? null : xNode.Attributes["Pic"].Value;
                string xml_Data = xNode.Attributes["Data"].Value == "" ? null : xNode.Attributes["Data"].Value;
                string xml_Property1 = xNode.Attributes["Property1"].Value == "" ? null : xNode.Attributes["Property1"].Value;
                string xml_Property2 = xNode.Attributes["Property2"].Value == "" ? null : xNode.Attributes["Property2"].Value;
                string xml_Property3 = xNode.Attributes["Property3"].Value == "" ? null : xNode.Attributes["Property3"].Value;
                string xml_Property4 = xNode.Attributes["Property4"].Value == "" ? null : xNode.Attributes["Property4"].Value;
                string xml_Property5 = xNode.Attributes["Property5"].Value == "" ? null : xNode.Attributes["Property5"].Value;
                string xml_Property6 = xNode.Attributes["Property6"].Value == "" ? null : xNode.Attributes["Property6"].Value;
                string xml_Property7 = xNode.Attributes["Property7"].Value == "" ? null : xNode.Attributes["Property7"].Value;
                string xml_Property8 = xNode.Attributes["Property8"].Value == "" ? null : xNode.Attributes["Property8"].Value;
                string xml_Quality = xNode.Attributes["Quality"].Value == "" ? null : xNode.Attributes["Quality"].Value;
                string xml_Script = xNode.Attributes["Script"].Value == "" ? null : xNode.Attributes["Script"].Value;
                string xml_BindType = xNode.Attributes["BindType"].Value == "" ? null : xNode.Attributes["BindType"].Value;
                string xml_FusionType = xNode.Attributes["FusionType"].Value == "" ? null : xNode.Attributes["FusionType"].Value;
                string xml_FusionRate = xNode.Attributes["FusionRate"].Value == "" ? null : xNode.Attributes["FusionRate"].Value;
                string xml_FusionNeedRate = xNode.Attributes["FusionNeedRate"].Value == "" ? null : xNode.Attributes["FusionNeedRate"].Value;
                string xml_TemplateID = xNode.Attributes["TemplateID"].Value == "" ? null : xNode.Attributes["TemplateID"].Value;
                string xml_RefineryLevel = xNode.Attributes["RefineryLevel"].Value == "" ? null : xNode.Attributes["RefineryLevel"].Value;
                string xml_Hole = xNode.Attributes["Hole"].Value == "" ? null : xNode.Attributes["Hole"].Value;
                string xml_ReclaimValue = xNode.Attributes["ReclaimValue"].Value == "" ? null : xNode.Attributes["ReclaimValue"].Value;
                string xml_ReclaimType = xNode.Attributes["ReclaimType"].Value == "" ? null : xNode.Attributes["ReclaimType"].Value;
                string xml_CanRecycle = xNode.Attributes["CanRecycle"].Value;
                int result = InsertUpdateTemplateAlllist.SP_Insert_Update_TemplateAlllist(Convert.ToInt32(xml_TemplateID)
                    , xml_Name, Convert.ToInt32(xml_CategoryID)
                    , xml_Description, Convert.ToInt32(xml_Attack), Convert.ToInt32(xml_Defence)
                    , Convert.ToInt32(xml_Agility)
                    , Convert.ToInt32(xml_Luck), Convert.ToInt32(xml_Level)
                    , Convert.ToInt32(xml_Quality), xml_Pic
                    , Convert.ToInt32(xml_MaxCount), Convert.ToInt32(xml_NeedSex)
                    , Convert.ToInt32(xml_NeedLevel)
                    , Convert.ToBoolean(xml_CanStrengthen), Convert.ToBoolean(xml_CanCompose)
                    , Convert.ToBoolean(xml_CanDrop), Convert.ToBoolean(xml_CanEquip)
                    , Convert.ToBoolean(xml_CanUse), Convert.ToBoolean(xml_CanDelete)
                    , xml_Script, xml_Data, xml_Colors
                    , Convert.ToInt32(xml_Property1), Convert.ToInt32(xml_Property2)
                    , Convert.ToInt32(xml_Property3), Convert.ToInt32(xml_Property4)
                    , Convert.ToInt32(xml_Property5), Convert.ToInt32(xml_Property6)
                    , Convert.ToInt32(xml_Property7), Convert.ToInt32(xml_Property8)
                    , Convert.ToDateTime(xml_AddTime), Convert.ToInt32(xml_BindType)
                    , Convert.ToInt32(xml_FusionType)
                    , Convert.ToInt32(xml_FusionRate)
                    , Convert.ToInt32(xml_FusionNeedRate)
                    , xml_Hole, Convert.ToInt32(xml_RefineryLevel)
                    , Convert.ToInt32(xml_ReclaimValue)
                    , Convert.ToInt32(xml_ReclaimType)
                    , Convert.ToInt32(xml_CanRecycle), 0);
                        
                //contNode++;
                if (result == 0)
                {
                    contInsert++;
                    listItems += "Id: " + xml_TemplateID + " Tên: " + xml_Name + "<br/>";
                }
                if (result == 1)
                {
                    contUpdate++;
                }
                contNode++;
            }

            LabelResult.Text = "Thêm mới " + contInsert + " items! <br/>";
            LabelResult.Text += "Cập nhật " + contUpdate + " items! <br/>";
            LabelResult.Text += "Tổng cộng " + contNode + " items! <br/>";
            LabelResult.Text += "Danh sách thêm mới: <br/>" + listItems; 
        }

        protected void ButtonBombConfig_Click(object sender, EventArgs e)
        {
            Admin.sendmailDataContext InsertUpdateBombConfig = new Admin.sendmailDataContext();

            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(Server.MapPath("XMLImport/bombconfig.xml"));
            XmlNodeList xNodeList = xDoc.SelectNodes("Result/child::node()");

            int contNode = 1;
            int contInsert = 0;
            int contUpdate = 0;
            string listItems = "";
            //int countItems = 0;
            foreach (XmlNode xNode in xNodeList)
            {
                string xml_TemplateID = xNode.Attributes["TemplateID"].Value == "" ? null : xNode.Attributes["TemplateID"].Value;
                string xml_Common = xNode.Attributes["Common"].Value == "" ? null : xNode.Attributes["Common"].Value;
                string xml_CommonAddWound = xNode.Attributes["CommonAddWound"].Value == "" ? null : xNode.Attributes["CommonAddWound"].Value;
                string xml_CommonMultiBall = xNode.Attributes["CommonMultiBall"].Value == "" ? null : xNode.Attributes["CommonMultiBall"].Value;
                string xml_Special = xNode.Attributes["Special"].Value == "" ? null : xNode.Attributes["Special"].Value;
                string xml_SpecialII = xNode.Attributes["SpecialII"].Value == "" ? null : xNode.Attributes["SpecialII"].Value;

                int result = InsertUpdateBombConfig.SP_Insert_Update_bombconfig(Convert.ToInt32(xml_TemplateID)
                    , Convert.ToInt32(xml_Common)
                    , Convert.ToInt32(xml_CommonAddWound)
                    , Convert.ToInt32(xml_CommonMultiBall)
                    , Convert.ToInt32(xml_Special)
                    , Convert.ToInt32(xml_SpecialII),0);
                //contNode++;
                if (result == 0)
                {
                    contInsert++;
                    listItems += "Id: " + xml_TemplateID + "<br/>";
                }
                if (result == 1)
                {
                    contUpdate++;
                }
                contNode++;
            }

            LabelResult.Text = "Thêm mới " + contInsert + " Bomb! <br/>";
            LabelResult.Text += "Cập nhật " + contUpdate + " Bomb! <br/>";
            LabelResult.Text += "Tổng cộng " + contNode + " Bomb! <br/>";
            LabelResult.Text += "Danh sách thêm mới: <br/>" + listItems;
        }

        protected void ButtonShopItemList_Click(object sender, EventArgs e)
        {
            Admin.sendmailDataContext InsertUpdateShopItemList = new Admin.sendmailDataContext();

            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(Server.MapPath("XMLImport/ShopItemList.xml"));
            XmlNodeList xNodeList = xDoc.SelectNodes("Result/child::node()");

            int contNode = 1;
            int contInsert = 0;
            int contUpdate = 0;
            string listItems = "";
            //int countItems = 0;
            foreach (XmlNode xNode in xNodeList[0])
            {
                string xml_ID = xNode.Attributes["ID"].Value == "" ? null : xNode.Attributes["ID"].Value;
                string xml_ShopID = xNode.Attributes["ShopID"].Value == "" ? null : xNode.Attributes["ShopID"].Value;
                string xml_GroupID = xNode.Attributes["GroupID"].Value == "" ? null : xNode.Attributes["GroupID"].Value;
                string xml_TemplateID = xNode.Attributes["TemplateID"].Value == "" ? null : xNode.Attributes["TemplateID"].Value;
                string xml_BuyType = xNode.Attributes["BuyType"].Value == "" ? null : xNode.Attributes["BuyType"].Value;
                string xml_IsContinue = xNode.Attributes["IsContinue"].Value == "" ? null : xNode.Attributes["IsContinue"].Value;
                string xml_IsBind = xNode.Attributes["IsBind"].Value == "" ? null : xNode.Attributes["IsBind"].Value;
                string xml_IsVouch = xNode.Attributes["IsVouch"].Value == "" ? null : xNode.Attributes["IsVouch"].Value;
                string xml_Label = xNode.Attributes["Label"].Value == "" ? null : xNode.Attributes["Label"].Value;
                string xml_Beat = xNode.Attributes["Beat"].Value == "" ? null : xNode.Attributes["Beat"].Value;
                string xml_AUnit = xNode.Attributes["AUnit"].Value == "" ? null : xNode.Attributes["AUnit"].Value;
                string xml_APrice1 = xNode.Attributes["APrice1"].Value == "" ? null : xNode.Attributes["APrice1"].Value;
                string xml_AValue1 = xNode.Attributes["AValue1"].Value == "" ? null : xNode.Attributes["AValue1"].Value;
                string xml_APrice2 = xNode.Attributes["APrice2"].Value == "" ? null : xNode.Attributes["APrice2"].Value;
                string xml_AValue2 = xNode.Attributes["AValue2"].Value == "" ? null : xNode.Attributes["AValue2"].Value;
                string xml_APrice3 = xNode.Attributes["APrice3"].Value == "" ? null : xNode.Attributes["APrice3"].Value;
                string xml_AValue3 = xNode.Attributes["AValue3"].Value == "" ? null : xNode.Attributes["AValue3"].Value;
                string xml_BUnit = xNode.Attributes["BUnit"].Value == "" ? null : xNode.Attributes["BUnit"].Value;
                string xml_BPrice1 = xNode.Attributes["BPrice1"].Value == "" ? null : xNode.Attributes["BPrice1"].Value;
                string xml_BValue1 = xNode.Attributes["BValue1"].Value == "" ? null : xNode.Attributes["BValue1"].Value;
                string xml_BPrice2 = xNode.Attributes["BPrice2"].Value == "" ? null : xNode.Attributes["BPrice2"].Value;
                string xml_BValue2 = xNode.Attributes["BValue2"].Value == "" ? null : xNode.Attributes["BValue2"].Value;
                string xml_BPrice3 = xNode.Attributes["BPrice3"].Value == "" ? null : xNode.Attributes["BPrice3"].Value;
                string xml_BValue3 = xNode.Attributes["BValue3"].Value == "" ? null : xNode.Attributes["BValue3"].Value;
                string xml_CUnit = xNode.Attributes["CUnit"].Value == "" ? null : xNode.Attributes["CUnit"].Value;
                string xml_CPrice1 = xNode.Attributes["CPrice1"].Value == "" ? null : xNode.Attributes["CPrice1"].Value;
                string xml_CValue1 = xNode.Attributes["CValue1"].Value == "" ? null : xNode.Attributes["CValue1"].Value;
                string xml_CPrice2 = xNode.Attributes["CPrice2"].Value == "" ? null : xNode.Attributes["CPrice2"].Value;
                string xml_CValue2 = xNode.Attributes["CValue2"].Value == "" ? null : xNode.Attributes["CValue2"].Value;
                string xml_CPrice3 = xNode.Attributes["CPrice3"].Value == "" ? null : xNode.Attributes["CPrice3"].Value;
                string xml_CValue3 = xNode.Attributes["CValue3"].Value == "" ? null : xNode.Attributes["CValue3"].Value;
                string xml_IsCheap = xNode.Attributes["IsCheap"].Value == "" ? null : xNode.Attributes["IsCheap"].Value;
                string xml_LimitCount = xNode.Attributes["LimitCount"].Value == "" ? null : xNode.Attributes["LimitCount"].Value;
                string xml_StartDate = xNode.Attributes["StartDate"].Value == "" ? null : xNode.Attributes["StartDate"].Value;
                string xml_EndDate = xNode.Attributes["EndDate"].Value == "" ? null : xNode.Attributes["EndDate"].Value;
                int result = InsertUpdateShopItemList.SP_Insert_Update_ShopItemList(Convert.ToDouble(xml_ID)
                    , Convert.ToDouble(xml_ShopID), Convert.ToDouble(xml_GroupID)
                    , Convert.ToDouble(xml_TemplateID), Convert.ToDouble(xml_BuyType)
                    , Convert.ToBoolean(xml_IsContinue), Convert.ToDouble(xml_IsBind)
                    , Convert.ToDouble(xml_IsVouch), Convert.ToDouble(xml_Label)
                    , Convert.ToDouble(xml_Beat), Convert.ToDouble(xml_AUnit)
                    , Convert.ToDouble(xml_APrice1), Convert.ToDouble(xml_AValue1)
                    , Convert.ToDouble(xml_APrice2), Convert.ToDouble(xml_AValue2)
                    , Convert.ToDouble(xml_APrice3), Convert.ToDouble(xml_AValue3)
                    , Convert.ToDouble(xml_BUnit), Convert.ToDouble(xml_BPrice1)
                    , Convert.ToDouble(xml_BValue1), Convert.ToDouble(xml_BPrice2)
                    , Convert.ToDouble(xml_BValue2), Convert.ToDouble(xml_BPrice3)
                    , Convert.ToDouble(xml_BValue3), Convert.ToDouble(xml_CUnit)
                    , Convert.ToDouble(xml_CPrice1), Convert.ToDouble(xml_CValue1)
                    , Convert.ToDouble(xml_CPrice2), Convert.ToDouble(xml_CValue2)
                    , Convert.ToDouble(xml_CPrice3), 0, Convert.ToDouble(xml_CValue3),0);
                //contNode++;
                if (result == 0)
                {
                    contInsert++;
                    listItems += "Id: " + xml_ID + " Shop ID: " + xml_ShopID + "<br/>";
                }
                if (result == 1)
                {
                    contUpdate++;
                }
                contNode++;
            }

            LabelResult.Text = "Thêm mới " + contInsert + " Item! <br/>";
            LabelResult.Text += "Cập nhật " + contUpdate + " Item! <br/>";
            LabelResult.Text += "Tổng cộng " + contNode + " Item! <br/>";
            LabelResult.Text += "Danh sách thêm mới: <br/>" + listItems;
        }

        protected void ButtonCheckResource_Click(object sender, EventArgs e)
        {
            var business = new Bussiness.ProduceBussiness();
            var getAllItem = business.GetAllGoods();
            var checkLink = new _Default();
            string url = "";
            int count_url = 0;
            //LabelResult.Text = "<img alt=\"\" src=\"../Images/loadingAnimation.gif\" />";
            for (int s = 0; s < getAllItem.Count(); s++)
            {                
                int CategoryID = getAllItem[s].CategoryID;
                url = "http://127.0.0.1/Resource/" + linkResource(getAllItem[s].Pic, CategoryID, getAllItem[s].NeedSex);
                    if (!checkLink.IsUrlAvailable(url))
                    {
                        if (CategoryID == 1 || CategoryID == 2 || CategoryID == 4)
                        {
                            LabelResult.Text += "ID " + getAllItem[s].TemplateID +"<br/>";
                            LabelResult.Text += "<a href=\"" + url + "/icon_1.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/game.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/show.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/2/game.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/2/show.png\">" + getAllItem[s].Name + "</a><br />";

                        }
                        else if (CategoryID == 3)
                        {
                            LabelResult.Text += "ID " + getAllItem[s].TemplateID + "<br/>";
                            LabelResult.Text += "<a href=\"" + url + "/icon_1.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/A/game.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/A/show.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/2/A/game.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/2/A/show.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/B/game.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/B/show.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/2/B/game.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/2/B/show.png\">" + getAllItem[s].Name + "</a><br />";

                        }
                        else if (CategoryID == 5 || CategoryID == 6)
                        {
                            LabelResult.Text += "ID " + getAllItem[s].TemplateID + "<br/>";
                            LabelResult.Text += "<a href=\"" + url + "/icon_1.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/game.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/show.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/2/game.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/2/show.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/3/game.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/3/show.png\">" + getAllItem[s].Name + "</a><br />";
                           
                        }
                        else if (CategoryID == 7)
                        {
                            LabelResult.Text += "ID " + getAllItem[s].TemplateID + "<br/>";
                            LabelResult.Text += "<a href=\"" + url + "/00.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/icon.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/0/show.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/0/game.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/1/game.png\">" + getAllItem[s].Name + "</a><br />";
                           
                        }
                        else if (CategoryID == 13)
                        {
                            LabelResult.Text += "ID " + getAllItem[s].TemplateID + "<br/>";
                            LabelResult.Text += "<a href=\"" + url + "/icon_1.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/show.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/game.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/1/game1.png\">" + getAllItem[s].Name + "</a><br />";

                        }
                        else if (CategoryID == 15)
                        {
                            LabelResult.Text += "ID " + getAllItem[s].TemplateID + "<br/>";
                            LabelResult.Text += "<a href=\"" + url + "/icon.png\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/wings.fla\">" + getAllItem[s].Name + "</a><br />";
                            LabelResult.Text += "<a href=\"" + url + "/wings.swf\">" + getAllItem[s].Name + "</a><br />";

                        }
                        else
                        {
                            LabelResult.Text += "ID " + getAllItem[s].TemplateID + "<br/>";
                            LabelResult.Text += "<a href=\"" + url + "\">" + getAllItem[s].Name + "</a><br />";
                        }
                        count_url++;
                        //url = "http://127.0.0.1/Resource/";
                    }
                    }
            LabelResult.Text +="Số Item thiếu hình ảnh là "+ count_url;
        }
        public static string linkResource(string Pic, int CategoryID, int NeedSex)
        {
            
            string imagePath = "";
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

        protected void ButtonLoadBoxTemp_Click(object sender, EventArgs e)
        {
            Admin.sendmailDataContext InsertUpdateShopGoodsBox = new Admin.sendmailDataContext();
            
            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(Server.MapPath("XMLImport/LoadBoxTemp.xml"));
            XmlNodeList xNodeList = xDoc.SelectNodes("Result/child::node()");
            //var business = new Bussiness.ProduceBussiness();
            //ItemBoxInfo itemName = business.GetSingleGoods;
            int contNode = 1;
            int contInsert = 0;
            int contUpdate = 0;
            string listItems = "";
            //int countItems = 0;
            foreach (XmlNode xNode in xNodeList)
            {
                string xml_ID = xNode.Attributes["ID"].Value == "" ? null : xNode.Attributes["ID"].Value;
                string xml_TemplateId = xNode.Attributes["TemplateId"].Value == "" ? null : xNode.Attributes["TemplateId"].Value;
                string xml_StrengthenLevel = xNode.Attributes["StrengthenLevel"].Value == "" ? null : xNode.Attributes["StrengthenLevel"].Value;
                string xml_IsBind = xNode.Attributes["IsBind"].Value == "" ? null : xNode.Attributes["IsBind"].Value;
                string xml_ItemCount = xNode.Attributes["ItemCount"].Value == "" ? null : xNode.Attributes["ItemCount"].Value;
                string xml_LuckCompose = xNode.Attributes["LuckCompose"].Value == "" ? null : xNode.Attributes["LuckCompose"].Value;
                string xml_DefendCompose = xNode.Attributes["DefendCompose"].Value == "" ? null : xNode.Attributes["DefendCompose"].Value;
                string xml_AttackCompose = xNode.Attributes["AttackCompose"].Value == "" ? null : xNode.Attributes["AttackCompose"].Value;
                string xml_AgilityCompose = xNode.Attributes["AgilityCompose"].Value == "" ? null : xNode.Attributes["AgilityCompose"].Value;
                string xml_ItemValid = xNode.Attributes["ItemValid"].Value == "" ? null : xNode.Attributes["ItemValid"].Value;
                string xml_IsTips = xNode.Attributes["IsTips"].Value == "" ? null : xNode.Attributes["IsTips"].Value;
                int result = InsertUpdateShopGoodsBox.SP_Insert_Update_Shop_Goods_Box(contNode,
                    Convert.ToInt32(xml_ID),
                    Convert.ToInt32(xml_TemplateId), 
                    false,
                    Convert.ToBoolean(xml_IsBind), 
                    Convert.ToInt32(xml_ItemValid), 
                    Convert.ToInt32(xml_ItemCount), 
                    Convert.ToInt32(xml_StrengthenLevel), 
                    Convert.ToInt32(xml_AttackCompose), 
                    Convert.ToInt32(xml_DefendCompose), 
                    Convert.ToInt32(xml_AgilityCompose),
                    Convert.ToInt32(xml_LuckCompose), 10, 
                    Convert.ToBoolean(xml_IsTips), 
                    false, 0);
                if (result == 0)
                {
                    contInsert++;
                    listItems += "Vật phẩm mở: " + xml_ID
                        + " Vật phẩm nhận được: " + xml_TemplateId + "<br/>";
                }
                if (result == 1)
                {
                    contUpdate++;
                }
                contNode++;
            }

            LabelResult.Text = "Thêm mới " + contInsert + " Box Template! <br/>";
            LabelResult.Text += "Cập nhật " + contUpdate + " Box Template! <br/>";
            LabelResult.Text += "Tổng cộng " + contNode + " Box Template! <br/>";
            LabelResult.Text += "Danh sách thêm mới: <br/>" + listItems;
        }

        protected void ButtonLoadMap_Click(object sender, EventArgs e)
        {
            Admin.sendmailDataContext InsertUpdateGameMap = new Admin.sendmailDataContext();

            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(Server.MapPath("XMLImport/LoadMapsItems.xml"));
            XmlNodeList xNodeList = xDoc.SelectNodes("Result/child::node()");

            int contNode = 1;
            int contInsert = 0;
            int contUpdate = 0;
            string listItems = "";
            //int countItems = 0;
            foreach (XmlNode xNode in xNodeList)
            {
                string xml_ID = xNode.Attributes["ID"].Value == "" ? null : xNode.Attributes["ID"].Value;
                string xml_Name = xNode.Attributes["Name"].Value == "" ? null : xNode.Attributes["Name"].Value;
                string xml_Description = xNode.Attributes["Description"].Value == "" ? null : xNode.Attributes["Description"].Value;
                string xml_ForegroundWidth = xNode.Attributes["ForegroundWidth"].Value == "" ? null : xNode.Attributes["ForegroundWidth"].Value;
                string xml_ForegroundHeight = xNode.Attributes["ForegroundHeight"].Value == "" ? null : xNode.Attributes["ForegroundHeight"].Value;
                string xml_BackroundWidht = xNode.Attributes["BackroundWidht"].Value == "" ? null : xNode.Attributes["BackroundWidht"].Value;
                string xml_BackroundHeight = xNode.Attributes["BackroundHeight"].Value == "" ? null : xNode.Attributes["BackroundHeight"].Value;
                string xml_DeadWidth = xNode.Attributes["DeadWidth"].Value == "" ? null : xNode.Attributes["DeadWidth"].Value;
                string xml_DeadHeight = xNode.Attributes["DeadHeight"].Value == "" ? null : xNode.Attributes["DeadHeight"].Value;
                string xml_Weight = xNode.Attributes["Weight"].Value == "" ? null : xNode.Attributes["Weight"].Value;
                string xml_DragIndex = xNode.Attributes["DragIndex"].Value == "" ? null : xNode.Attributes["DragIndex"].Value;
                string xml_ForePic = xNode.Attributes["ForePic"].Value == "" ? null : xNode.Attributes["ForePic"].Value;
                string xml_BackPic = xNode.Attributes["BackPic"].Value == "" ? null : xNode.Attributes["BackPic"].Value;
                string xml_DeadPic = xNode.Attributes["DeadPic"].Value == "" ? null : xNode.Attributes["DeadPic"].Value;
                string xml_Pic = xNode.Attributes["Pic"].Value == "" ? null : xNode.Attributes["Pic"].Value;
                string xml_BackMusic = xNode.Attributes["BackMusic"].Value == "" ? null : xNode.Attributes["BackMusic"].Value;
                string xml_Remark = xNode.Attributes["Remark"].Value == "" ? null : xNode.Attributes["Remark"].Value;
                string xml_Type = xNode.Attributes["Type"].Value == "" ? null : xNode.Attributes["Type"].Value;
                int result = InsertUpdateGameMap.SP_Insert_Update_Game_Map(Convert.ToInt32(xml_ID), 
                    xml_Name, 
                    xml_Description, 
                    Convert.ToInt32(xml_ForegroundWidth), 
                    Convert.ToInt32(xml_ForegroundHeight), 
                    Convert.ToInt32(xml_BackroundWidht), 
                    Convert.ToInt32(xml_BackroundHeight), 
                    Convert.ToInt32(xml_DeadWidth), 
                    Convert.ToInt32(xml_DeadHeight), 
                    Convert.ToInt32(xml_Weight), 
                    Convert.ToInt32(xml_DragIndex), 
                    xml_ForePic, 
                    xml_BackPic, 
                    xml_DeadPic, 
                    xml_Pic, 
                    xml_Remark, 
                    xml_BackMusic, 
                    "500,400|600,420|700,440|800,460", 
                    Convert.ToInt32(xml_Type),
                    "500,400|600,420|700,440|800,460", 0);
                if( result == 0)
                {
                contInsert++;
                listItems += "Id: " + xml_ID + " Tên: " + xml_Name + "<br/>";
                } 
                if (result == 1)
                {
                contUpdate++;
                }
                contNode++;
            }
            
            LabelResult.Text = "Thêm mới " + contInsert + " Map! <br/>";
            LabelResult.Text += "Cập nhật " + contUpdate + " Map! <br/>";
            LabelResult.Text += "Tổng cộng " + contNode + " Map! <br/>";
            LabelResult.Text += "Danh sách thêm mới: <br/>" + listItems;
        }

        protected void ButtonLoadPVE_Click(object sender, EventArgs e)
        {

        }

        protected void ButtonNPCInfo_Click(object sender, EventArgs e)
        {
            Admin.sendmailDataContext InsertUpdateBombConfig = new Admin.sendmailDataContext();

            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(Server.MapPath("XMLImport/NPCInfoList.xml"));
            XmlNodeList xNodeList = xDoc.SelectNodes("Result/child::node()");

            int contNode = 1;
            //int countItems = 0;
            foreach (XmlNode xNode in xNodeList)
            {
                string xml_ID = xNode.Attributes["ID"].Value == "" ? null : xNode.Attributes["ID"].Value;
                string xml_Name = xNode.Attributes["Name"].Value == "" ? null : xNode.Attributes["Name"].Value;
                string xml_Level = xNode.Attributes["Level"].Value == "" ? null : xNode.Attributes["Level"].Value;
                string xml_Camp = xNode.Attributes["Camp"].Value == "" ? null : xNode.Attributes["Camp"].Value;
                string xml_Type = xNode.Attributes["Type"].Value == "" ? null : xNode.Attributes["Type"].Value;
                string xml_Blood = xNode.Attributes["Blood"].Value == "" ? null : xNode.Attributes["Blood"].Value;
                string xml_MoveMin = xNode.Attributes["MoveMin"].Value == "" ? null : xNode.Attributes["MoveMin"].Value;
                string xml_MoveMax = xNode.Attributes["MoveMax"].Value == "" ? null : xNode.Attributes["MoveMax"].Value;
                string xml_BaseDamage = xNode.Attributes["BaseDamage"].Value == "" ? null : xNode.Attributes["BaseDamage"].Value;
                string xml_BaseGuard = xNode.Attributes["BaseGuard"].Value == "" ? null : xNode.Attributes["BaseGuard"].Value;
                string xml_Defence = xNode.Attributes["Defence"].Value == "" ? null : xNode.Attributes["Defence"].Value;
                string xml_Agility = xNode.Attributes["Agility"].Value == "" ? null : xNode.Attributes["Agility"].Value;
                string xml_Lucky = xNode.Attributes["Lucky"].Value == "" ? null : xNode.Attributes["Lucky"].Value;
                string xml_ModelID = xNode.Attributes["ModelID"].Value == "" ? null : xNode.Attributes["ModelID"].Value;
                string xml_ResourcesPath = xNode.Attributes["ResourcesPath"].Value == "" ? null : xNode.Attributes["ResourcesPath"].Value;
                string xml_DropRate = xNode.Attributes["DropRate"].Value == "" ? null : xNode.Attributes["DropRate"].Value;
                string xml_Experience = xNode.Attributes["Experience"].Value == "" ? null : xNode.Attributes["Experience"].Value;
                string xml_Delay = xNode.Attributes["Delay"].Value == "" ? null : xNode.Attributes["Delay"].Value;
                string xml_Immunity = xNode.Attributes["Immunity"].Value == "" ? null : xNode.Attributes["Immunity"].Value;
                string xml_Alert = xNode.Attributes["Alert"].Value == "" ? null : xNode.Attributes["Alert"].Value;
                string xml_Range = xNode.Attributes["Range"].Value == "" ? null : xNode.Attributes["Range"].Value;
                string xml_Preserve = xNode.Attributes["Preserve"].Value == "" ? null : xNode.Attributes["Preserve"].Value;
                string xml_Script = xNode.Attributes["Script"].Value == "" ? null : xNode.Attributes["Script"].Value;
                string xml_FireX = xNode.Attributes["FireX"].Value == "" ? null : xNode.Attributes["FireX"].Value;
                string xml_FireY = xNode.Attributes["FireY"].Value == "" ? null : xNode.Attributes["FireY"].Value;
                string xml_DropId = xNode.Attributes["DropId"].Value == "" ? null : xNode.Attributes["DropId"].Value; 
                
                //int result = InsertUpdateBombConfig.SP_Insert_Update_NPC_Info(xml_ID,xml_Name, xml_Level, xml_Camp, xml_Type,-10,-20,x ;
                contNode++;
            }
            LabelResult.Text = "Tổng cộng " + contNode + " record!";
        }
    }
}