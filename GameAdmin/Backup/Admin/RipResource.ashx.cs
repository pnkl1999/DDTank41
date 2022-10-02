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
using System.ComponentModel;

namespace AdminGunny.Admin
{
    /// <summary>
    /// Summary description for RipResource
    /// </summary>
    public class RipResource : System.Web.UI.Page
    {
         [System.Web.Services.WebMethod]
        public static string ProcessRequest(string urlrip, int countUp)
        {
            string imagePath = System.Configuration.ConfigurationManager.AppSettings["ImagePath"];
            var getAllItem = new Bussiness.ProduceBussiness().GetAllGoods();
            var checkLink = new _Default();
            string returnStr = "";
            string url = "";
            string checkUrl = urlrip;
            string SavePath = "";
            
                var s = countUp;
                url = linkResource(getAllItem[s].Pic, getAllItem[s].CategoryID, getAllItem[s].NeedSex);
                var SysNet = new System.Net.WebClient();
                string[] splitkey = url.Split('|');
                string[] re = new string[] { "/", "icon_1.png", "game.png", "show.png", "00.png", "icon.png", "game1.png", "wings.fla", "wings.swf", "icon.jpg" };
                string[] wi = new string[] { "\\", "", "", "", "", "", "", "", "", "" };
                

                for (int i = 0; i < splitkey.Count(); i++)
                {
                    SavePath = imagePath + splitkey[i];
                    for (int s2 = 0; s2 < re.Count(); s2++)
                    {
                        SavePath = SavePath.Replace(re[s2], wi[s2]);
                    }
                    if (!Directory.Exists(SavePath))
                    {
                        Directory.CreateDirectory(SavePath);
                    }
                    checkUrl += splitkey[i];
                    SavePath = imagePath + splitkey[i].Replace("/", "\\");
                    if (checkLink.IsUrlAvailable(checkUrl))
                    {
                        //SysNet.DownloadFileCompleted += new AsyncCompletedEventHandler(DownloadFileCallback2);
                        SysNet.DownloadFile(checkUrl, SavePath);
                        returnStr += SavePath + "<br />";
                        //newItem++;
                    }
                    else
                    {
                        returnStr = "Link nguồn không chính xác! " + checkUrl;
                        returnStr += "<script type=\"text/javascript\"> clear_Interval(); </script>";
                        break;
                    }
                    //else { oldItem++; }
                    checkUrl = urlrip;
                    SavePath = "";
                }
                return returnStr;

            //}
        }
         [System.Web.Services.WebMethod]
         public static string returnMaxCount()
         {
             var business = new Bussiness.ProduceBussiness();
             var getAllItem = business.GetAllGoods();
             string returnStr = Convert.ToString(getAllItem.Count());
             return returnStr;
         }
        public static string linkResource(string Pic, int CategoryID, int NeedSex)
        {
           
            string imagePath = "";
            //int n = 2;

            string gender = NeedSex == 1 ? "m" : "f";

            switch (CategoryID)
            {

                case 1:
                    
                    imagePath += "image/equip/" + gender + "/head/" + Pic + "/icon_1.png|";
                    imagePath += "image/equip/" + gender + "/head/" + Pic + "/1/game.png|";
                    imagePath += "image/equip/" + gender + "/head/" + Pic + "/1/show.png|";
                    imagePath += "image/equip/" + gender + "/head/" + Pic + "/2/game.png|";
                    imagePath += "image/equip/" + gender + "/head/" + Pic + "/2/show.png";
                    break;
                case 2:
                    
                    imagePath += "image/equip/" + gender + "/glass/" + Pic + "/icon_1.png|";
                    imagePath += "image/equip/" + gender + "/glass/" + Pic + "/1/game.png|";
                    imagePath += "image/equip/" + gender + "/glass/" + Pic + "/1/show.png|";
                    imagePath += "image/equip/" + gender + "/glass/" + Pic + "/2/game.png|";
                    imagePath += "image/equip/" + gender + "/glass/" + Pic + "/2/show.png";
                    break;
                case 3:
                    
                    imagePath += "image/equip/" + gender + "/hair/" + Pic + "/icon_1.png|";
                    imagePath += "image/equip/" + gender + "/hair/" + Pic + "/1/A/game.png|";
                    imagePath += "image/equip/" + gender + "/hair/" + Pic + "/1/A/show.png|";
                    imagePath += "image/equip/" + gender + "/hair/" + Pic + "/2/A/game.png|";
                    imagePath += "image/equip/" + gender + "/hair/" + Pic + "/2/A/show.png|";
                    imagePath += "image/equip/" + gender + "/hair/" + Pic + "/1/B/game.png|";
                    imagePath += "image/equip/" + gender + "/hair/" + Pic + "/1/B/show.png|";
                    imagePath += "image/equip/" + gender + "/hair/" + Pic + "/2/B/game.png|";
                    imagePath += "image/equip/" + gender + "/hair/" + Pic + "/2/B/show.png|";
                    break;
                case 4:
                    
                    imagePath += "image/equip/" + gender + "/eff/" + Pic + "/icon_1.png|";
                    imagePath += "image/equip/" + gender + "/eff/" + Pic + "/1/game.png|";
                    imagePath += "image/equip/" + gender + "/eff/" + Pic + "/1/show.png|"; 
                    imagePath += "image/equip/" + gender + "/eff/" + Pic + "/2/game.png|";
                    imagePath += "image/equip/" + gender + "/eff/" + Pic + "/2/show.png"; 
                    break;
                case 5:
                   
                    imagePath += "image/equip/" + gender + "/cloth/" + Pic + "/icon_1.png|";
                    imagePath += "image/equip/" + gender + "/cloth/" + Pic + "/1/game.png|";
                    imagePath += "image/equip/" + gender + "/cloth/" + Pic + "/1/show.png|";
                    imagePath += "image/equip/" + gender + "/cloth/" + Pic + "/2/game.png|";
                    imagePath += "image/equip/" + gender + "/cloth/" + Pic + "/2/show.png|";
                    imagePath += "image/equip/" + gender + "/cloth/" + Pic + "/3/game.png|";
                    imagePath += "image/equip/" + gender + "/cloth/" + Pic + "/3/show.png";
                    break;
                case 6:
                    
                    imagePath += "image/equip/" + gender + "/face/" + Pic + "/icon_1.png|";
                    imagePath += "image/equip/" + gender + "/face/" + Pic + "/1/game.png|";
                    imagePath += "image/equip/" + gender + "/face/" + Pic + "/1/show.png|";
                    imagePath += "image/equip/" + gender + "/face/" + Pic + "/2/game.png|";
                    imagePath += "image/equip/" + gender + "/face/" + Pic + "/2/show.png|";
                    imagePath += "image/equip/" + gender + "/face/" + Pic + "/3/game.png|";
                    imagePath += "image/equip/" + gender + "/face/" + Pic + "/3/show.png";
                    break;
                case 27:
                case 7:
                   
                    imagePath += "image/arm/" + Pic + "/00.png|";
                    imagePath += "image/arm/" + Pic + "/1/icon.png|";
                    imagePath += "image/arm/" + Pic + "/1/0/show.png|";
                    imagePath += "image/arm/" + Pic + "/1/0/game.png|";
                    imagePath += "image/arm/" + Pic + "/1/1/game.png";
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
                   
                    imagePath += "image/equip/" + gender + "/suits/" + Pic + "/icon_1.png|";
                    imagePath += "image/equip/" + gender + "/suits/" + Pic + "/1/show.png|";
                    imagePath += "image/equip/" + gender + "/suits/" + Pic + "/1/game.png|";
                    imagePath += "image/equip/" + gender + "/suits/" + Pic + "/1/game1.png";
                    break;
                case 14:
                    
                    imagePath += "image/necklace/" + Pic + "/icon.png";
                    break;
                case 15:
                   
                    imagePath += "image/equip/wing/" + Pic + "/icon.png|";
                    imagePath += "image/equip/wing/" + Pic + "/wings.fla|";
                    imagePath += "image/equip/wing/" + Pic + "/wings.swf";
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

        
    }
}