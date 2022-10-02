using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using Bussiness;
using System.Web.Security;
using System.Web.SessionState;
using log4net;
using System.Reflection;

namespace Tank.Flash.auth
{
    /// <summary>
    /// Summary description for register
    /// </summary>
    public class register : IHttpHandler, IRequiresSessionState
    {
        protected static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected string SiteTitle
        {
            get
            {
                return ((ConfigurationManager.AppSettings["SiteTitle"] == null) ? "DanDanTang" : ConfigurationManager.AppSettings["SiteTitle"]);
            }
        }
        private string code;
        private string email;
        private string message;
        private string password;
        private string repassword;
        private bool sex = false;
        private string username;

        protected bool CheckPara(HttpContext context, ref string message)
        {  
            if (context.Session["CheckCode"] == null || code.ToLower() != context.Session["CheckCode"].ToString().ToLower())
            {
                message = "Sai mã bảo mật!";
                return false;
            }
            using (MemberShipBussiness db = new MemberShipBussiness())
            {
                if (db.ExistsUsername(username))
                {
                    message = "exit";
                    return false;
                }
            }
            return true;
        }

        protected bool CreateUsername(HttpContext context, ref string message)
        {
           password = FormsAuthentication.HashPasswordForStoringInConfigFile(password, "md5");
            using (MemberShipBussiness db = new MemberShipBussiness())
            {
                return db.CreateUsername(SiteTitle, username, password, email, "1", "MD5", sex);
            }
        }

        public void ProcessRequest(HttpContext context)
        {
             
            //if (context.Request.Form.Count > 0)
            //{
                username = context.Request["username"];
                password = context.Request["password"];
                repassword = context.Request["repassword"];
                email = context.Request["email"];
                code = context.Request["code"];
                message = "";
               
                if (CheckPara(context, ref message) && CreateUsername(context, ref message))
                {
                    /*
                    try
                    {
                        using (PlayerBussiness db = new PlayerBussiness())
                        {
                            db.RegisterUser(username, username, password, sex, 0, 0, 0);
                        }
                    }
                    catch (Exception e)
                    {
                        if (log.IsErrorEnabled)
                            log.Error("Init CheckEmailIsValid", e);
                    }
                     */ 
                    message = "ok";
                }
                context.Response.Write(message);
            //}
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