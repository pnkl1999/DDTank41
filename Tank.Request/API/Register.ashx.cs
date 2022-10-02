using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Script.Serialization;
using Bussiness.Interface;
using log4net;

namespace Tank.Request.API
{
    /// <summary>
    /// Summary description for Register
    /// </summary>
    public class Register : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            //string username = context.Request["username"];
            //string password = context.Request["password"];
            //string email = context.Request["email"];
            //string phone = context.Request["phone"];
            //DbMemberDataContext db = new DbMemberDataContext();
            //Member_Info _Info = null;
            try
            {
                //_Info = db.Member_Infos.Where(a => a.Username == username && a.Password == BaseInterface.md5(password)).FirstOrDefault();
                //if (_Info == null)
                //{
                //    _Info = new Member_Info();
                //    _Info.Username = username;
                //    _Info.Password = BaseInterface.md5(password);
                //    _Info.Email = email;
                //    _Info.Phone = phone;
                //    _Info.BroCoin = 0;
                //    db.Member_Infos.InsertOnSubmit(_Info);//add to database
                //    db.SubmitChanges();//savetodatabase
                //}
                //else
                //    _Info = null;
            }
            catch
            { }
            finally
            {
                //JavaScriptSerializer js = new JavaScriptSerializer();
                context.Response.ContentType = "text/plain";
                //context.Response.Write(_Info == null ? "exist" : js.Serialize(new { _Info.Username, _Info.Password }));
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