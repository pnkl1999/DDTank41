using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using Bussiness.Managers;
using Bussiness;
using Bussiness.Interface;
using System.Configuration;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ChargeTest : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                string chargeID = context.Request["chargeID"];
                string userName = context.Request["userName"];
                int money = int.Parse(context.Request["money"]);
                string payWay = context.Request["payWay"];
                decimal needMoney = decimal.Parse(context.Request["needMoney"]);
                string nickname = context.Request["nickname"] == null ? "" : HttpUtility.UrlDecode(context.Request["nickname"]);
                string chargekey = HttpUtility.UrlDecode(context.Request["chargekey"]);
                string site = "";

                QYInterface qy = new QYInterface();

                string key = string.Empty;
                if (!string.IsNullOrEmpty(site))
                {
                    key = ConfigurationSettings.AppSettings[string.Format("ChargeKey_a", site)];
                }
                else
                {
                    key = BaseInterface.GetChargeKey;
                }

                if (chargekey != BaseInterface.md5(BaseInterface.GetChargeKey))
                {
                    context.Response.Write("Wrong key!");
                    return;
                }

                string v = BaseInterface.md5(chargeID + userName + money + payWay + needMoney + key);
                string Url = "http://gn-quest.3brogames.com/ChargeMoney.aspx?content=" + chargeID + "|" + userName + "|" + money + "|" + payWay + "|" + needMoney + "|" + v;
                Url += "&site=" + site;
                Url += "&nickname=" + HttpUtility.UrlEncode(nickname);
                context.Response.Write(BaseInterface.RequestContent(Url));

                //int userid = 0;
                //int isResult = 0;
                //using (PlayerBussiness db = new PlayerBussiness())
                //{
                //    db.AddChargeMoney(chargeID, "dandan", 1000, "sdf", 200, out userid, ref isResult);
                //}
                //context.Response.Write(isResult);

            }
            catch (Exception ex)
            {
                context.Response.Write(ex.ToString());
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
