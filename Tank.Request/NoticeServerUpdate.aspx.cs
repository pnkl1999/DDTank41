using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Bussiness.Protocol;
using Bussiness.Interface;
using log4net;
using System.Reflection;
using Bussiness.CenterService;

namespace Tank.Request
{
    public partial class NoticeServerUpdate : System.Web.UI.Page
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static string GetAdminIP
        {
            get
            {
                return ConfigurationSettings.AppSettings["AdminIP"];
            }
        }

        public static bool ValidLoginIP(string ip)
        {
            string ips = GetAdminIP;
            if (string.IsNullOrEmpty(ips) || ips.Split('|').Contains(ip))
                return true;
            return false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int result = 2;
            try
            {
                int serverID = int.Parse(Context.Request["serverID"]);
                int type = int.Parse(Context.Request["type"]);

                if (ValidLoginIP(Context.Request.UserHostAddress))
                {
                    using (CenterServiceClient temp = new CenterServiceClient())
                    {
                        result = temp.NoticeServerUpdate(serverID, type);
                    }

                    switch (type)
                    {
                        case (int)eReloadType.mapserver:
                            //serverID = param1
                            if (result == 0)
                            {
                                result = HandleServerMapUpdate();
                            }
                            break;
                        default:
                            break;
                    }
                }
                else
                {
                    result = 5;
                }


            }
            catch (Exception ex)
            {
                log.Error("ExperienceRateUpdate:", ex);
                result = 4;
            }
            Response.Write(result);
        }

        private int HandleServerMapUpdate()
        {
            string Url = "http://" + HttpContext.Current.Request.Url.Authority.ToString() + "/MapServerList.ashx";

            string strRlt = BaseInterface.RequestContent(Url);

            if (strRlt.Contains("Success"))
            {
                return 0;
            }
            else
            {
                return 3;
            }
        }
    }
}
