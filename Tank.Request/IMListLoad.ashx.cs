using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using log4net;
using System.Reflection;
using Bussiness;
using SqlDataProvider.Data;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class IMListLoad : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");

            try
            {
                int id = int.Parse(context.Request["id"]);
                using (PlayerBussiness db = new PlayerBussiness())
                {
                    FriendInfo[] infos = db.GetFriendsAll(id);
                    XElement node0 = new XElement("customList",
                        new XAttribute("ID", 0),
                        new XAttribute("Name", "Bạn bè"));
                    result.Add(node0);
                    foreach (FriendInfo g in infos)
                    {
                        XElement node = new XElement("Item", new XAttribute("ID", g.FriendID),
                            //new XAttribute("ID",g.ID),
                            new XAttribute("NickName", g.NickName),
                            new XAttribute("Birthday", DateTime.Now),
                            new XAttribute("ApprenticeshipState", 0),
                            new XAttribute("LoginName", g.UserName),
                            new XAttribute("Style", g.Style),
                            new XAttribute("Sex", g.Sex == 1 ? true : false),
                            new XAttribute("Colors", g.Colors),
                            new XAttribute("Grade", g.Grade),
                            new XAttribute("Hide", g.Hide),
                            new XAttribute("ConsortiaName", g.ConsortiaName),
                            new XAttribute("TotalCount", g.Total),
                            new XAttribute("EscapeCount", g.Escape),
                            new XAttribute("WinCount", g.Win),
                            new XAttribute("Offer", g.Offer),
                            new XAttribute("Relation", g.Relation),
                            new XAttribute("Repute", g.Repute),
                            new XAttribute("State", g.State == 1 ? 1 : 0),
                            new XAttribute("Nimbus",g.Nimbus),
                            new XAttribute("DutyName", g.DutyName));
                        result.Add(node);
                    }
                }

                value = true;
                message = "Success!";
            }
            catch (Exception ex)
            {
                log.Error("IMListLoad", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            context.Response.ContentType = "text/plain";
            context.Response.Write(result.ToString(false));
            //context.Response.BinaryWrite(StaticFunction.Compress(result.ToString(false)));
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
