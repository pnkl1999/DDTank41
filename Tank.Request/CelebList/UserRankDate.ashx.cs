using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;
using System;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;

namespace Tank.Request
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class UserRankDate : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool flag = false;
            string str = "Fail!";
            XElement node = new XElement((XName)"Result");
            try
            {
                string s = HttpUtility.UrlDecode(context.Request["userID"]);
                HttpUtility.UrlDecode(context.Request["ConsortiaID"]);
                using (PlayerBussiness playerBussiness = new PlayerBussiness())
                {
                    UserRankDateInfo userRankDateById = playerBussiness.GetUserRankDateByID(int.Parse(s));
                    if (userRankDateById == null)
                        return;
                    node.Add((object)FlashUtils.CreateUserRankDateItems(userRankDateById));
                    flag = true;
                    str = "Success!";
                }
            }
            catch (Exception ex)
            {
                UserRankDate.log.Error((object)nameof(UserRankDate), ex);
            }
            finally
            {
                if (flag)
                {
                    node.Add((object)new XAttribute((XName)"value", (object)flag));
                    node.Add((object)new XAttribute((XName)"message", (object)str));
                    context.Response.ContentType = "text/plain";
                    context.Response.Write(node.ToString(false));
                }
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
