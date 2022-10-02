using System;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Web.UI;
using Bussiness.CenterService;
using log4net;

namespace Tank.Request
{
	public class AASGetState : Page
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public static string GetAdminIP => ConfigurationManager.AppSettings["AdminIP"];

		public static bool ValidLoginIP(string ip)
		{
			string getAdminIp = GetAdminIP;
			if (!string.IsNullOrEmpty(getAdminIp) && !getAdminIp.Split('|').Contains(ip))
			{
				return false;
			}
			return true;
		}

		protected void Page_Load(object sender, EventArgs e)
		{
			int num = 2;
			try
			{
				if (ValidLoginIP(Context.Request.UserHostAddress))
				{
					using (CenterServiceClient centerServiceClient = new CenterServiceClient())
					{
						num = centerServiceClient.AASGetState();
					}
				}
			}
			catch (Exception ex)
			{
				log.Error("ASSGetState:", ex);
			}
			base.Response.Write(num);
		}
	}
}
