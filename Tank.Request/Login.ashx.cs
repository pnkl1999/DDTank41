using System;
using System.Configuration;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.SessionState;
using System.Xml.Linq;
using Bussiness;
using Bussiness.Interface;
using Game.Base;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class Login : IHttpHandler, IRequiresSessionState
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        public static string ValidDate
        {
            get
            {
                return ConfigurationManager.AppSettings["ValidDate"];
            }
        }

        public bool IsReusable => false;

        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = LanguageMgr.GetTranslation("Tank.Request.Login.Fail1");
            bool isError = false;
            XElement result = new XElement("Result");
            string p = context.Request["p"];
            try
            {
                BaseInterface inter = BaseInterface.CreateInterface();
                string site = ((context.Request["site"] == null) ? "" : HttpUtility.UrlDecode(context.Request["site"]));
                string IP = context.Request.UserHostAddress;
                if (string.IsNullOrEmpty(p))
                {
                    return;
                }
                byte[] src = CryptoHelper.RsaDecryt2(StaticFunction.RsaCryptor, p);
                string[] strList = Encoding.UTF8.GetString(src, 7, src.Length - 7).Split(',');
                if (strList.Length != 4)
                {
                    return;
                }
                string name = strList[0];
                string pwd = strList[1];
                string newPwd = strList[2];
                string nickname = strList[3];
                //if (PlayerManager.Login(name, pwd))
                //if (PlayerManager.Login(name, pwd/*.ToUpper()*/)/* || ValidDate == "1"*/)
                if(true)
                {
                    //if (true)
                    //{
                    int isFirst = 0;
                    bool isActive = false;
                    bool firstValidate = PlayerManager.GetByUserIsFirst(name);
                    PlayerInfo player = inter.CreateLogin(name, newPwd, int.Parse(ConfigurationManager.AppSettings["ServerID"]), ref message, ref isFirst, IP, ref isError, firstValidate, ref isActive, site, nickname);
                    //log.Error("login != null" + (player != null ? "true" : "false"));
                    //log.Error("flag2" + (isError ? "true" : "false!"));
                    if (isActive)
                    {
                        StaticsMgr.RegCountAdd();
                    }
                    if (player != null && !isError)
                    {
                        //if (player.State == 1)
                        //{
                        //    string msg = "Tài khoản đang online! Đăng nhập thất bại!";
                        //    message = LanguageMgr.GetTranslation(msg);
                        //    log.ErrorFormat("Hack detected =>player.ID: {0}, player.UserName: {1}, player.NickName: {2}. Msg: {3}", player.ID, player.UserName, player.NickName, msg);
                        //}
                        //else
                        //{
                        if (isFirst == 0)
                        {
                            PlayerManager.Update(name, newPwd);
                        }
                        else
                        {
                            PlayerManager.Remove(name);
                        }
                        string str3 = (string.IsNullOrEmpty(player.Style) ? ",,,,,,,," : player.Style);
                        player.Colors = (string.IsNullOrEmpty(player.Colors) ? ",,,,,,,," : player.Colors);
                        XElement xelement2 = new XElement("Item", new XAttribute("ID", player.ID), new XAttribute("IsFirst", isFirst), new XAttribute("NickName", player.NickName), new XAttribute("Date", ""), new XAttribute("IsConsortia", 0), new XAttribute("ConsortiaID", player.ConsortiaID), new XAttribute("Sex", player.Sex), new XAttribute("WinCount", player.Win), new XAttribute("TotalCount", player.Total), new XAttribute("EscapeCount", player.Escape), new XAttribute("DutyName", (player.DutyName == null) ? "" : player.DutyName), new XAttribute("GP", player.GP), new XAttribute("Honor", ""), new XAttribute("Style", str3), new XAttribute("Gold", player.Gold), new XAttribute("Colors", (player.Colors == null) ? "" : player.Colors), new XAttribute("Attack", player.Attack), new XAttribute("Defence", player.Defence), new XAttribute("Agility", player.Agility), new XAttribute("Luck", player.Luck), new XAttribute("Grade", player.Grade), new XAttribute("Hide", player.Hide), new XAttribute("Repute", player.Repute), new XAttribute("ConsortiaName", (player.ConsortiaName == null) ? "" : player.ConsortiaName), new XAttribute("Offer", player.Offer), new XAttribute("Skin", (player.Skin == null) ? "" : player.Skin), new XAttribute("ReputeOffer", player.ReputeOffer), new XAttribute("ConsortiaHonor", player.ConsortiaHonor), new XAttribute("ConsortiaLevel", player.ConsortiaLevel), new XAttribute("ConsortiaRepute", player.ConsortiaRepute), new XAttribute("Money", player.Money + player.MoneyLock), new XAttribute("AntiAddiction", player.AntiAddiction), new XAttribute("IsMarried", player.IsMarried), new XAttribute("SpouseID", player.SpouseID), new XAttribute("SpouseName", (player.SpouseName == null) ? "" : player.SpouseName), new XAttribute("MarryInfoID", player.MarryInfoID), new XAttribute("IsCreatedMarryRoom", player.IsCreatedMarryRoom), new XAttribute("IsGotRing", player.IsGotRing), new XAttribute("LoginName", (player.UserName == null) ? "" : player.UserName), new XAttribute("Nimbus", player.Nimbus), new XAttribute("FightPower", player.FightPower), new XAttribute("AnswerSite", player.AnswerSite), new XAttribute("WeaklessGuildProgressStr", (player.WeaklessGuildProgressStr == null) ? "" : player.WeaklessGuildProgressStr), new XAttribute("IsOldPlayer", false));
                        result.Add(xelement2);
                        value = true;
                        message = LanguageMgr.GetTranslation("Tank.Request.Login.Success");
                        // }
                    }
                    else
                    {
                        log.Error("PlayerManager.Remove(name)");
                        PlayerManager.Remove(name);
                    }
                    //}
                }

                else
                {
                    log.Error("name:" + name + "-pwd:" + pwd);
                    message = LanguageMgr.GetTranslation("BaseInterface.LoginAndUpdate.Try");
                }
            }
            catch (Exception ex)
            {
                byte[] numArray = Convert.FromBase64String(p);
                log.Error("User Login error: (--" + StaticFunction.RsaCryptor.KeySize + "--)" + ex.ToString());
                log.Error("--dataarray: " + Marshal.ToHexDump("fuckingbitch " + numArray.Length, numArray));
                value = false;
                message = LanguageMgr.GetTranslation("Tank.Request.Login.Fail2");
            }
            finally
            {
                result.Add(new XAttribute("value", value));
                result.Add(new XAttribute("message", message));
                context.Response.ContentType = "text/plain";
                context.Response.Write(result.ToString(check: false));
            }
        }
    }
}
