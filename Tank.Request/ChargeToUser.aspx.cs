using Bussiness;
using Bussiness.CenterService;
using Bussiness.Interface;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Tank.Request
{
    public partial class ChargeToUser : System.Web.UI.Page
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        protected void Page_Load(object sender, EventArgs e)
        {
            string result = "false";
            try
            {
                int userID = Convert.ToInt32(HttpUtility.UrlDecode(base.Request["userID"]));
                string chargeID = (HttpUtility.UrlDecode(base.Request["chargeID"]));

                using (CenterServiceClient centerServiceClient = new CenterServiceClient())
                {
                    centerServiceClient.ChargeMoney(userID, chargeID);
                    using (PlayerBussiness playerBussiness2 = new PlayerBussiness())
                    {
                        PlayerInfo userSingleByUserId = playerBussiness2.GetUserSingleByUserID(userID);
                        if (userSingleByUserId != null)
                        {
                            result = "ok";
                        }
                        else
                        {
                            result = "null";
                            log.Error("ChargeMoney_StaticsMgr:Player is null!");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("ChargeMoney:", ex);
            }

            base.Response.Write(result);
        }
    }
}