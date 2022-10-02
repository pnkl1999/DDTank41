using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Collections.Specialized;
using log4net;
using System.Reflection;
using Bussiness;
using System.Configuration;
using Tank.Request.Illegalcharacters;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class VisualizeRegister : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static FileSystem fileIllegal = new FileSystem(HttpContext.Current.Server.MapPath(IllegalCharacters), HttpContext.Current.Server.MapPath(IllegalDirectory), "*.txt");

        public static string IllegalCharacters
        {
            get
            {
                return System.Configuration.ConfigurationManager.AppSettings["IllegalCharacters"];
            }
        }

        public static string IllegalDirectory
        {
            get
            {
                return System.Configuration.ConfigurationManager.AppSettings["IllegalDirectory"];
            }
        }



        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = LanguageMgr.GetTranslation("Tank.Request.VisualizeRegister.Fail1");
            XElement result = new XElement("Result");

            try
            {
                NameValueCollection para = context.Request.Params;
                string name = para["Name"] as string;
                string pass = para["Pass"] as string;
                string nickName = para["NickName"].Trim().Replace(",", ""); ;
                string armColor = para["Arm"] as string;
                string hairColor = para["Hair"] as string;
                string faceColor = para["Face"] as string;
                string ClothColor = para["Cloth"] as string;
                string HatColor = para["Cloth"] as string;

                string armID = para["ArmID"] as string;
                string hairID = para["HairID"] as string;
                string faceID = para["FaceID"] as string;
                string ClothID = para["ClothID"] as string;
                string HatID = para["ClothID"] as string;

                int sex = -1;
                if (bool.Parse(ConfigurationManager.AppSettings["MustSex"]))
                {
                    sex = bool.Parse(para["Sex"]) ? 1 : 0;
                }


                if ((System.Text.Encoding.Default.GetByteCount(nickName) <= 14))               
                {
                    if(!fileIllegal.checkIllegalChar(nickName))
                    {
                        if (!string.IsNullOrEmpty(name) && !string.IsNullOrEmpty(pass) && !string.IsNullOrEmpty(nickName))
                        {

                            string[] styles = sex == 1 ? ConfigurationManager.AppSettings["BoyVisualizeItem"].Split(';') : ConfigurationManager.AppSettings["GrilVisualizeItem"].Split(';');
                            //if (styles[0].Split(',').Contains(armID) && styles[1].Split(',').Contains(hairID) && styles[2].Split(',').Contains(faceID) && styles[3].Split(',').Contains(ClothID))
                            //{
                            armID = styles[0].Split(',')[0];
                            hairID = styles[0].Split(',')[1];
                            faceID = styles[0].Split(',')[2];
                            ClothID = styles[0].Split(',')[3];
                            HatID = styles[0].Split(',')[4];
                            armColor = "";
                            hairColor = "";
                            faceColor = "";
                            ClothColor = "";
                            HatColor = "";
                            using (PlayerBussiness db = new PlayerBussiness())
                            {
                                string style = armID + "," + hairID + "," + faceID + "," + ClothID + "," + HatID;
                                if (db.RegisterPlayer(name, pass, nickName, style,
                                    style, armColor, hairColor, faceColor, ClothColor, HatColor, sex,
                                    ref message, int.Parse(ConfigurationManager.AppSettings["ValidDate"])))
                                {
                                    value = true;
                                    message = LanguageMgr.GetTranslation("Tank.Request.VisualizeRegister.Success");
                                }
                            }
                            //}
                            //else
                            //{
                            //    message = LanguageMgr.GetTranslation("(styles[0].Split(',').Contains(armID)");
                            //}

                        }
                        else
                        {
                            message = LanguageMgr.GetTranslation("!string.IsNullOrEmpty(name) && !");
                        }

                    }
                    else
                    {
                        message = LanguageMgr.GetTranslation("Tank.Request.VisualizeRegister.Illegalcharacters");
                    }
                   
                }
                else
                {
                    //message = "NickName is very long!";
                    message = LanguageMgr.GetTranslation("Tank.Request.VisualizeRegister.Long");
                }
            }
            catch (Exception ex)
            {
                log.Error("VisualizeRegister", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            context.Response.ContentType = "text/plain";
            context.Response.Write(result.ToString(false));
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
