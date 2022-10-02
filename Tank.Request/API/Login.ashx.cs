using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Security;
using Bussiness.Interface;
namespace Tank.Request.API
{
    /// <summary>
    /// Summary description for Login
    /// </summary>
    public class Login : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //string username = context.Request["username"];
            //string password = context.Request["password"];
            //DbMemberDataContext db = new DbMemberDataContext();
            //Member_Info _Info = null;
            try
            {
                //_Info = db.Member_Infos.Where(a => a.Username == username && a.Password == BaseInterface.md5(password)).FirstOrDefault();
            }
            catch
            {

            }
            finally
            {
                //JavaScriptSerializer js = new JavaScriptSerializer();
                context.Response.ContentType = "text/plain";
                //context.Response.Write(_Info == null ? "null" : js.Serialize(new { _Info.Username }));
                context.Response.Write(1);
            }
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