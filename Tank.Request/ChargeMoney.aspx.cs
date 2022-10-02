using System;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using Bussiness;
using Bussiness.CenterService;
using Bussiness.Interface;
using log4net;
using SqlDataProvider.Data;

namespace Tank.Request
{
	public partial class ChargeMoney : System.Web.UI.Page
	{
        
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public static string GetChargeIP => ConfigurationSettings.AppSettings["ChargeIP"];

		protected void Page_Load(object sender, EventArgs e)
		{
			int num = 1;
			try
			{
				num = 10;
                string userHostAddress = Context.Request.UserHostAddress;
                if (ValidLoginIP(userHostAddress))
                {
                    string content = HttpUtility.UrlDecode(base.Request["content"]);
                    string site = ((base.Request["site"] == null) ? "" : HttpUtility.UrlDecode(base.Request["site"]).ToLower());
                    int UserID = Convert.ToInt32(HttpUtility.UrlDecode(base.Request["nickname"]));
                    string[] strArray = BaseInterface.CreateInterface().UnEncryptCharge(content, ref num, site);
                    if (strArray.Length > 5)
                    {
                        string chargeID = strArray[0];
                        string user = strArray[1].Trim();
                        int money = int.Parse(strArray[2]);
                        string str = strArray[3];
                        decimal needMoney = decimal.Parse(strArray[4]);
                        if (!string.IsNullOrEmpty(user))
                        {
                            string nameBySite = BaseInterface.GetNameBySite(user, site);
                            if (money > 0)
                            {
                                using (PlayerBussiness playerBussiness1 = new PlayerBussiness())
                                {
                                    int userID = 0;
                                    DateTime now = DateTime.Now;
                                    if (playerBussiness1.AddChargeMoney(chargeID, nameBySite, money, str, needMoney, ref userID, ref num, now, userHostAddress, UserID))
                                    {
                                        num = 0;
                                        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
                                        {
                                            centerServiceClient.ChargeMoney(userID, chargeID);
                                            using (PlayerBussiness playerBussiness2 = new PlayerBussiness())
                                            {
                                                PlayerInfo userSingleByUserId = playerBussiness2.GetUserSingleByUserID(userID);
                                                if (userSingleByUserId != null)
                                                {
                                                    StaticsMgr.Log(now, nameBySite, userSingleByUserId.Sex, money, str, needMoney);
                                                }
                                                else
                                                {
                                                    StaticsMgr.Log(now, nameBySite, sex: true, money, str, needMoney);
                                                    log.Error("ChargeMoney_StaticsMgr:Player is null!");
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else
                            {
                                num = 3;
                            }
                        }
                        else
                        {
                            num = 2;
                        }
                    }
                }
                else
                {
                    num = 5;
                }
            }
			catch (Exception ex)
			{
				log.Error("ChargeMoney:", ex);
			}
			base.Response.Write(num + Context.Request.UserHostAddress);
		}

		public static bool ValidLoginIP(string ip)
		{
			string getChargeIp = GetChargeIP;
			int num = (string.IsNullOrEmpty(getChargeIp) ? 1 : (getChargeIp.Split('|').Contains(ip) ? 1 : 0));
			return num != 0;
		}
	}
}
