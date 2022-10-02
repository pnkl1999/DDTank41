using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using Bussiness;
using SqlDataProvider.Data;
using log4net;
using System.Reflection;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class IMFriendsGood : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        public void ProcessRequest(HttpContext context)
        {

            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");

            try
            {
                string UserName = context.Request["UserName"];
                using (PlayerBussiness db = new PlayerBussiness())
                {
                    ArrayList friends =   db.GetFriendsGood(UserName);

                    for (int i = 0; i < friends.Count; i++)
                    {
                        XElement node = new XElement("Item",
                                new XAttribute("UserName", friends[i].ToString()));
                        result.Add(node);
                    }                        
                }
                value = true;
                message = "Success!";
            }
            catch (Exception ex)
            {
                log.Error("IMFriendsGood", ex);
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
