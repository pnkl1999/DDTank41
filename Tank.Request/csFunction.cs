using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.IO;
using Bussiness;
using SqlDataProvider.Data;
using Road.Flash;
using log4net;
using System.Reflection;

namespace Tank.Request
{
    public class csFunction
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static string GetAdminIP
        {
            get
            {
                return ConfigurationSettings.AppSettings["AdminIP"];
            }
        }

        public static bool ValidAdminIP(string ip)
        {
            string ips = GetAdminIP;
            if (string.IsNullOrEmpty(ips) || ips.Split('|').Contains(ip))
                return true;
            return false;
        }

        #region SQLChar

        /// <summary> 
        /// 防止SQL 注入试攻击 
        /// </summary> 
        /// <param name="inputString">用户输入字符串</param> 
        public static string ConvertSql(string inputString)
        {
            inputString = inputString.Trim().ToLower();
            inputString = inputString.Replace("'", "''");
            inputString = inputString.Replace(";--", "");
            inputString = inputString.Replace("=", "");
            inputString = inputString.Replace(" or", "");
            inputString = inputString.Replace(" or ", "");
            inputString = inputString.Replace(" and", "");
            inputString = inputString.Replace("and ", "");
            if (!SqlChar(inputString))
            {
                inputString = "";
            }
            return inputString;
        }

        private static string[] al = ";|and|1=1|exec|insert|select|delete|update|like|count|chr|mid|master|or|truncate|char|declare|join".Split('|');
        public static bool SqlChar(string v)
        {
            if (v.Trim() != "")
            {
                foreach (string a in al)
                {
                    if (v.IndexOf(a + " ") > -1 || v.IndexOf(" " + a) > -1)
                    {
                        return false;
                    }
                }
            }
            return true;
        }

        #endregion

        #region CompressXml

        public static string CreateCompressXml(HttpContext context, XElement result, string file, bool isCompress)
        {        
            string path = context.Server.MapPath("~"); ;
            return CreateCompressXml(path, result, file, isCompress);
        }

        public static string CreateCompressXml(XElement result, string file, bool isCompress)
        {
            //string path = HttpContext.Current.Server.MapPath("~");
            string path = StaticsMgr.CurrentPath;
            return CreateCompressXml(path, result, file, isCompress);
        }

        public static string CreateCompressXml(string path, XElement result, string file, bool isCompress)
        {
            try
            {
                file = file + ".xml";
                path = Path.Combine(path , file);
                using (FileStream fs = new FileStream(path, FileMode.Create))
                {
                    if (isCompress)
                    {
                        using (BinaryWriter writer = new BinaryWriter(fs))
                        {
                            writer.Write(StaticFunction.Compress(result.ToString(false)));
                        }
                    }
                    else
                    {
                        using (StreamWriter wirter = new StreamWriter(fs))
                        {
                            wirter.Write(result.ToString(false));
                        }
                    }
                }

                return "Build:" + file + ",Success!";
            }
            catch (Exception ex)
            {
                log.Error("CreateCompressXml " + file + " is fail!", ex);
                return "Build:" + file + ",Fail!";
            }
        }

        #endregion

        #region Celeb

        public static string BuildCelebConsortia(string file, int order)
        {
            return BuildCelebConsortia(file, order, "");
        }

        public static string BuildCelebConsortia(string file, int order, string fileNotCompress)
        {
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");
            int total = 0;

            try
            {
                int page = 1;
                int size = 50;
                //int order = 10;
                int consortiaID = -1;
                string name = "";
                int level = -1;

                using (ConsortiaBussiness db = new ConsortiaBussiness())
                {
                    ConsortiaInfo[] infos = db.GetConsortiaPage(page, size, ref total, order, name, consortiaID, level,-1);
                    foreach (ConsortiaInfo info in infos)
                    {
                        XElement node = FlashUtils.CreateConsortiaInfo(info);

                        if (info.ChairmanID != 0)
                        {
                            using (PlayerBussiness pb = new PlayerBussiness())
                            {
                                PlayerInfo player = pb.GetUserSingleByUserID(info.ChairmanID);
                                if (player != null)
                                {
                                    node.Add(FlashUtils.CreateCelebInfo(player));
                                }
                            }
                        }
                        result.Add(node);
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error(file + " is fail!", ex);
            }

            result.Add(new XAttribute("total", total));
            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            result.Add(new XAttribute("date", System.DateTime.Today.ToString("yyyy-MM-dd")));

            if (!string.IsNullOrEmpty(fileNotCompress))
            {
                csFunction.CreateCompressXml(result, fileNotCompress, false);
            }

            return csFunction.CreateCompressXml(result, file, true);
        }

        public static string BuildCelebUsers(string file, int order)
        {
            return BuildCelebUsers(file, order, "");
        }

        public static string BuildEliteMatchPlayerList(string file)
        {
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");

            try
            {
                int page = 1;
                int size = 50;
                //int order = 5;
                int userID = -1;
                int total = 0;
                bool resultValue = false;

                using (PlayerBussiness db = new PlayerBussiness())
                {
                    PlayerInfo[] infos = db.GetPlayerPage(page, size, ref total, 7, userID, ref resultValue);
                    if (resultValue)
                    {
                        int rank1 = 1;
                        int rank2 = 1;
                        XElement set1 = new XElement("ItemSet", new XAttribute("value", 1));
                        XElement set2 = new XElement("ItemSet", new XAttribute("value", 2));
                        foreach (PlayerInfo info in infos)
                        {
                            if (info.Grade <= 40)
                            {
                                set1.Add(FlashUtils.CreateEliteMatchPlayersList(info, rank1));
                                rank1++;
                            }
                            else
                            {
                                set2.Add(FlashUtils.CreateEliteMatchPlayersList(info, rank2));
                                rank2++;
                            }
                        }
                        result.Add(set1);
                        result.Add(set2);
                        value = true;
                        message = "Success!";
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error(file + " is fail!", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            result.Add(new XAttribute("lastUpdateTime", System.DateTime.Now.ToString()));

            //csFunction.CreateCompressXml(result, "CelebForUsers", false);
            return csFunction.CreateCompressXml(result, file, true);
        }

        public static string BuildCelebUsers(string file, int order, string fileNotCompress)
        {
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");

            try
            {
                int page = 1;
                int size = 50;
                //int order = 5;
                int userID = -1;
                int total = 0;
                bool resultValue = false;

                using (PlayerBussiness db = new PlayerBussiness())
                {
                    db.UpdateUserReputeFightPower();
                    PlayerInfo[] infos = db.GetPlayerPage(page, size, ref total, order, userID, ref resultValue);
                    if (resultValue)
                    {
                        foreach (PlayerInfo info in infos)
                        {
                            result.Add(FlashUtils.CreateCelebInfo(info));
                        }
                        value = true;
                        message = "Success!";
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error(file + " is fail!", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            result.Add(new XAttribute("date", System.DateTime.Today.ToString("yyyy-MM-dd")));
            if (!string.IsNullOrEmpty(fileNotCompress))
            {
                csFunction.CreateCompressXml(result, fileNotCompress, false);
            }

            return csFunction.CreateCompressXml(result, file, true);
        }

        #endregion


        public static string BuildCelebConsortiaFightPower(string file, string fileNotCompress)
        {
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");
            int total = 0;

            try
            {

                using (ConsortiaBussiness db = new ConsortiaBussiness())
                {
                    ConsortiaInfo[] infos = db.UpdateConsortiaFightPower();
                    total = infos.Length;
                    foreach (ConsortiaInfo info in infos)
                    {
                        XElement node = FlashUtils.CreateConsortiaInfo(info);

                        if (info.ChairmanID != 0)
                        {
                            using (PlayerBussiness pb = new PlayerBussiness())
                            {
                                PlayerInfo player = pb.GetUserSingleByUserID(info.ChairmanID);
                                if (player != null)
                                {
                                    node.Add(FlashUtils.CreateCelebInfo(player));
                                }
                            }
                        }
                        result.Add(node);
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error(file + " is fail!", ex);
            }

            result.Add(new XAttribute("total", total));
            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            result.Add(new XAttribute("date", System.DateTime.Today.ToString("yyyy-MM-dd")));

            if (!string.IsNullOrEmpty(fileNotCompress))
            {
                csFunction.CreateCompressXml(result, fileNotCompress, false);
            }

            return csFunction.CreateCompressXml(result, file, true);
        }

    }
}
