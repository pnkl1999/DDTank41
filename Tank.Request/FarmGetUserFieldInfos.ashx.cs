using Bussiness;
using log4net;
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
    public class FarmGetUserFieldInfos : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static int AccelerateTimeFields(DateTime PlantTime, int FieldValidDate)
        {
            DateTime now = DateTime.Now;
            int num1 = now.Hour - PlantTime.Hour;
            int num2 = now.Minute - PlantTime.Minute;
            if (num1 < 0)
                num1 = 24 + num1;
            if (num2 < 0)
                num2 = 60 + num2;
            int num3 = num1 * 60 + num2;
            if (num3 > FieldValidDate)
                num3 = FieldValidDate;
            return num3;
        }

        private static int AccelerateTimeFields(UserFieldInfo m_field)
        {
            int num = 0;
            if (m_field != null && m_field.SeedID > 0)
                num = FarmGetUserFieldInfos.AccelerateTimeFields(m_field.PlantTime, m_field.FieldValidDate);
            return num;
        }

        public void ProcessRequest(HttpContext context)
        {
            int int32 = Convert.ToInt32(context.Request["selfid"]);
            string str1 = context.Request["key"];
            bool flag = true;
            string str2 = "Success!";
            XElement node = new XElement((XName)"Result");
            using (PlayerBussiness playerBussiness = new PlayerBussiness())
            {
                foreach (FriendInfo friendInfo in playerBussiness.GetFriendsAll(int32))
                {
                    XElement xelement1 = new XElement((XName)"Item");
                    foreach (UserFieldInfo singleField in playerBussiness.GetSingleFields(friendInfo.FriendID))
                    {
                        XElement xelement2 = new XElement((XName)"Item", new object[3]
                        {
              (object) new XAttribute((XName) "SeedID", (object) singleField.SeedID),
              (object) new XAttribute((XName) "AcclerateDate", (object) FarmGetUserFieldInfos.AccelerateTimeFields(singleField)),
              (object) new XAttribute((XName) "GrowTime", (object) singleField.PlantTime.ToString("yyyy-MM-ddTHH:mm:ss"))
                        });
                        xelement1.Add((object)xelement2);
                    }
                    xelement1.Add((object)new XAttribute((XName)"UserID", (object)friendInfo.FriendID));
                    node.Add((object)xelement1);
                }
            }
            node.Add((object)new XAttribute((XName)"value", (object)flag));
            node.Add((object)new XAttribute((XName)"message", (object)str2));
            context.Response.ContentType = "text/plain";
            context.Response.Write(node.ToString(false));
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
